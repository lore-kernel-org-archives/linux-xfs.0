Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6OISqWG168435 for <xfs@oss.sgi.com>; Tue, 24 Jul 2012 13:28:52 -0500
Received: from ppsw-50.csi.cam.ac.uk (ppsw-50.csi.cam.ac.uk [131.111.8.150])
	by cuda.sgi.com with ESMTP id w2PTP3NDHIV0szQ5 for
	<xfs@oss.sgi.com>; Tue, 24 Jul 2012 11:28:50 -0700 (PDT)
Received: from smtp.damtp.cam.ac.uk ([131.111.18.84]:38113
	helo=septal.damtp.cam.ac.uk)
	by ppsw-50.csi.cam.ac.uk (ppsw.cam.ac.uk [131.111.8.137]:25)
	with esmtp id 1Stjqj-000707-rw (Exim 4.72) for xfs@oss.sgi.com
	(return-path <J.S.Peatfield@damtp.cam.ac.uk>);
	Tue, 24 Jul 2012 19:28:49 +0100
Date: Tue, 24 Jul 2012 19:28:48 +0100 (BST)
From: Jon Peatfield <J.S.Peatfield@damtp.cam.ac.uk>
Subject: Re: Assert in xfs_repair (Phase 7) and other xfs_restore problems
In-Reply-To: <20120723235442.GM23387@dastard>
Message-ID: <alpine.LRH.2.02.1207241927350.7993@floggle-toggle.damtp.cam.ac.uk>
References: <alpine.LRH.2.02.1207202022300.7993@floggle-toggle.damtp.cam.ac.uk>
	<20120723235442.GM23387@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Jon Peatfield <J.S.Peatfield@damtp.cam.ac.uk>, xfs@oss.sgi.com

On Tue, 24 Jul 2012, Dave Chinner wrote:

...
>> Now in phase7.c it asserts if nlinks is over 65536 which 13006001
>> clearly is:
>>
>>            do_warn(_("resetting inode %" PRIu64 " nlinks from %u to %u\n"),
>>                    ino, dinoc->di_nlink, nrefs);
>>
>>            if (dinoc->di_version == 1 && nrefs > XFS_MAXLINK_1)  {
>>                    ASSERT(fs_inode_nlink);
>>                    do_warn(
>> _("nlinks %u will overflow v1 ino, ino %" PRIu64 " will be converted to version 2\n"),
>>                            nrefs, ino);
>>
>>            }
>>            dinoc->di_nlink = nrefs;
>
> And that is saying that your superblock does not have the NLINK
> feature bit set, so it can't use version 2 inodes which support link
> counts of up to 2^32.  Use xfs_db to set the NLINK bit, and re-run
> repair.
>
> FWIW, the mkfs default is to set the NLINK. That got changed some
> 4-5 years ago, IIRC...

Thanks for this.

The original filesystem is about 8 years old so it would have been created 
before that change even if we had the latest versions of the xfsprogs at 
the time.

While waiting for the data to copy (before I try anything else) I did a 
quick scan though the xfsprogs 3.1.8 sources looking for things which 
alter the sb version/versionnum to set the XFS_SB_VERSION_NLINKBIT flag 
(assuming that one it right since it is what causes xfs_db to add NLINK to 
the version output).

I can find only one piece of code which does it:

include/xfs_sb.h :
static inline void xfs_sb_version_addnlink(xfs_sb_t *sbp)
{
         if (sbp->sb_versionnum <= XFS_SB_VERSION_2)
                 sbp->sb_versionnum = XFS_SB_VERSION_3;
         else
                 sbp->sb_versionnum |= XFS_SB_VERSION_NLINKBIT;
}

and that function is only used in one place - and can't be reached:

repair/versions.c :
         if (fs_inode_nlink && !xfs_sb_version_hasnlink(sb))  {
                 ASSERT(fs_inode_nlink_allowed);
                 xfs_sb_version_addnlink(sb);
         }
...

Am I missing the obvious way to set this bit?

BTW on a fresh fs made with and older mkfs.xfs (the one from RHEL5) the 
NLINK bit isn't set initially but seems to become set once I cause an 
inode to have more than 65536 links...

# xfs_db -c version /dev/SpudSnaps/Test2
versionnum [0xb584+0x8] = V4,ALIGN,DALIGN,DIRV2,LOGV2,EXTFLG,MOREBITS,ATTR2
# mount /dev/SpudSnaps/Test2 /mnt/testing/
# mkdir /mnt/testing/foo
# for i in $(seq 1 65537); do mkdir /mnt/testing/foo/$i; done
# umount /mnt/testing
# xfs_db -c version /dev/SpudSnaps/Test2
versionnum [0xb5b4+0x8] = V4,ATTR,NLINK,ALIGN,DALIGN,DIRV2,LOGV2,EXTFLG,MOREBITS,ATTR2

So is it actually some other feature which needs to be set to allow NLINK 
to be set?

Looking at the 'bad' fs it has:

# xfs_db -c version /dev/FornixRaid02/damtp-home
versionnum [0x35d4+0x0] = V4,ATTR,QUOTA,ALIGN,DALIGN,DIRV2,LOGV2,EXTFLG

so it seems to just be missing MOREBITS and ATTR2 compared to the earlier 
output from the test fs - but neither seems very likely.

I'm sure that I'm missing something very obvious.

  -- Jon

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
