Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ADA7C7F3F
	for <linux-xfs@oss.sgi.com>; Mon, 18 Mar 2013 16:36:07 -0500 (CDT)
Date: Mon, 18 Mar 2013 16:36:04 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: mount XFS partition fail after repair when uquota and gquota
	are used
Message-ID: <20130318213604.GF22182@sgi.com>
References: <1363600796196-34996.post@n7.nabble.com>
	<20130318164743.GC22182@sgi.com> <51477035.7070200@epfl.ch>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51477035.7070200@epfl.ch>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Guillaume Anciaux <guillaume.anciaux@epfl.ch>
Cc: linux-xfs@oss.sgi.com

Hi Guillaume,

On Mon, Mar 18, 2013 at 08:51:17PM +0100, Guillaume Anciaux wrote:
> On 18/03/2013 17:47, Ben Myers wrote:
> >On Mon, Mar 18, 2013 at 02:59:56AM -0700, anciaux wrote:
> >>I have been struggling to repair a partition after a RAID disk set failure.
> >>
> >>Apparently the data is accessible with no problem since I can mount the
> >>partition.
> >>
> >>The problem is ONLY when I use the uquota and gquota mount option (which I
> >>was using freely before the disk failure).

...

> >>I fear for the filesystem to be corrupted and xfs_repair not able to
> >>notice.  At least for the quota information.  Someone has any hint on
> >>what could be the problem ?
> >
> >Have you tried xfs_repair?  I'm not clear on that.
>
> Sorry I was not clear enough in my message: Yes I did hit xfs_repair
> -L. And it permitted me to mount the partition but ONLYwhen quota
> options are not set. If quota is activated then a corruption message
> (see below for the complete message) is printed in syslog.

Running xfs_repair with the -L option will have zeroed the log so you have
likely lost some recent metadata transactions.  -L is dangerous.

> >>On how I could fix/regenerate the quota
> >>information ?
> >
> >It looks like you're hitting the corruption during quotacheck, which is in the
> >process of regenerating the quota information.  Your paste seems to be missing
> >the output that would be printed by xfs_warn at line 513 which would include
> >ino, total nextents, and the number of blocks used.  Is that info available?
>
> Sorry I did a " | grep -i xfs" for the previous log. The complete
> log is hereafter:
> 
> Mar 18 09:35:50 storage kernel: [  417.883817] XFS (sdb1): corrupt
> dinode 3224608213, extent total = 1, nblocks = 0.
         ^^^^^^^^^^

You know the inode number now.  It has one extent.  It is using 0 blocks which
is why you're having trouble.  You could use 'find' to find that file.

> Corruption detected. Unmount and run xfs_repair

Does a subsequent xfs_repair (without -L) find the inode and fix it?  If not we
have a bug in xfs_repair.  I recommend you try with the latest and greatest
version which you can find here:  git://oss.sgi.com/xfs/cmds/xfsprogs.git

> >Could you provide a metadump?  This bug report isn't ringing any bells for me
> >yet, but maybe it will for someone else.
>
> I wish I could do this but the result of "meta_dump /dev/sdb1" for
> the partition containing 6.9T of data is promising to be quite
> large. Are there special options I should use to extract only the
> information that you would need to investigate my problem ?

A metadump is the best option.  How big?

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
