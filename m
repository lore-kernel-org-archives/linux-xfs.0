Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5B5887F4E
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 08:18:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F20E5AC005
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 06:18:53 -0700 (PDT)
Received: from smtprelay01.ispgateway.de (smtprelay01.ispgateway.de
	[80.67.18.43]) by cuda.sgi.com with ESMTP id nEyRGL2qurVTUcm0
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 18 Jul 2013 06:18:51 -0700 (PDT)
Date: Thu, 18 Jul 2013 15:18:49 +0200
Message-ID: <20130718151849.Horde.SOx_yTbdM5xJzVuZr8FMdw2@webmail.df.eu>
From: Andreas.Klauer@metamorpher.de
Subject: Re: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Structure needs
	cleaning
References: <20130718110437.GA8090@EIS> <20130718111306.GB13468@dastard>
	<20130718112938.GB8090@EIS> <20130718124511.GC13468@dastard>
In-Reply-To: <20130718124511.GC13468@dastard>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="Yes"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Quoting Dave Chinner <david@fromorbit.com>:
> There shouldn't be any XFS changes between 3.10.0 and 3.10.1, so I'm
> not sure that's your problem. It looks to me like there's
> pre-existing corruption on disk, and 3.10 is simply finding it. Have
> you recently upgraded from an older kernel (i.e. older than 3.9)?

Hey Dave,

thanks again for your help. You may be right about it being some other  
corruption.
Another kernel panic (this time, reiserfs!) caused the box to hang  
entirely, and
I'm in a Ubuntu 13.04 LiveCD now (sending this mail via webmail  
interface). I will link
to a photo of the reiserfs panic at the bottom of the mail in case  
it's of interest.

I did a memtest and SMART selftest (only short so far, will do a long  
one later on),
no errors there, and everything looks fine from the rescue system as  
well, so I'm
not sure what is going on.

The LVM is on LUKS which in turn is on RAID-5 (mdadm) so even a single  
HDD failure
should be covered by the RAID, although the panic/reset caused it to resync.
There was nothing in dmesg that'd point to a HDD or any other IO  
failure though.

> Ok, so the problem is as expected - the secondary superblock in AG 5
> is not verifying correctly. Can you run:
>
> # xfs_db -r -c "sb 0" -c p -c "sb 5" -c p <dev>
>
> And post the output?

These values are from the Ubuntu live / rescue system now.
While I did not modify it - working with snapshots for now -
I'm not sure how useful they are anymore after the reboot.
The growing of the filesystem worked fine for a snapshot,
no errors at all.

magicnum = 0x58465342
blocksize = 4096
dblocks = 524288000
rblocks = 0
rextents = 0
uuid = cbfe0d27-44d9-4367-8517-0a2835680ef2
logstart = 67108871
rootino = 192
rbmino = 193
rsumino = 194
rextsize = 1
agblocks = 32768000
agcount = 16
rbmblocks = 0
logblocks = 32768
versionnum = 0xbca4
sectsize = 4096
inodesize = 256
inopblock = 16
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 12
inodelog = 8
inopblog = 4
agblklog = 25
rextslog = 0
inprogress = 0
imax_pct = 25
icount = 8704
ifree = 854
fdblocks = 26540703
frextents = 0
uquotino = 0
gquotino = 0
qflags = 0
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 0
width = 0
dirblklog = 0
logsectlog = 12
logsectsize = 4096
logsunit = 4096
features2 = 0xa
bad_features2 = 0xa
magicnum = 0x58465342
blocksize = 4096
dblocks = 524288000
rblocks = 0
rextents = 0
uuid = cbfe0d27-44d9-4367-8517-0a2835680ef2
logstart = 67108871
rootino = 192
rbmino = 193
rsumino = 194
rextsize = 1
agblocks = 32768000
agcount = 16
rbmblocks = 0
logblocks = 32768
versionnum = 0xbca4
sectsize = 4096
inodesize = 256
inopblock = 16
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 12
inodelog = 8
inopblog = 4
agblklog = 25
rextslog = 0
inprogress = 0
imax_pct = 25
icount = 6272
ifree = 575
fdblocks = 19359822
frextents = 0
uquotino = 0
gquotino = 0
qflags = 0
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 0
width = 0
dirblklog = 0
logsectlog = 12
logsectsize = 4096
logsunit = 4096
features2 = 0xa
bad_features2 = 0xa


Regards
Andreas Klauer

PS: the reiserfs panic - sorry it's a photo, if there's an easy way to  
make Linux dump such somewhere digitally, I haven't learned of it yet

http://666kb.com/i/cfw9k11348jh7hlmw.png

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
