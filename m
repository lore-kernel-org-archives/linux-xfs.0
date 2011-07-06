Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p66MpYUv206505 for <xfs@oss.sgi.com>; Wed, 6 Jul 2011 17:51:34 -0500
Received: from a.mail.sonic.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A905E87A26
	for <xfs@oss.sgi.com>; Wed,  6 Jul 2011 15:51:33 -0700 (PDT)
Received: from a.mail.sonic.net (a.mail.sonic.net [64.142.16.245]) by
	cuda.sgi.com with ESMTP id uhQ4pgf2VziRicHc for
	<xfs@oss.sgi.com>; Wed, 06 Jul 2011 15:51:33 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <49309.1309992692@sonic.net>
Date: Wed, 06 Jul 2011 15:51:32 -0700
Subject: Re: xfs_growfs doesn't resize
From: kkeller@sonic.net
Reply-To: kkeller@sonic.net
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Hello again XFS folks,

I have finally made the time to revisit this, after copying most of my data
elsewhere.

On Sun 03/07/11  9:41 PM , Eric Sandeen <sandeen@sandeen.net> wrote:
> On 7/3/11 11:34 PM, kkeller@sonic.net wrote:

> > How safe is running xfs_db with -r on my mounted filesystem? I
> 
> it's safe. At worst it might read inconsistent data, but it's
> perfectly safe.

So, here is my xfs_db output.  This is still on a mounted filesystem.

# xfs_db -r -c 'sb 0' -c 'print' /dev/mapper/saharaVG-saharaLV
magicnum = 0x58465342
blocksize = 4096
dblocks = 5371061248
rblocks = 0
rextents = 0
uuid = 1bffcb88-0d9d-4228-93af-83ec9e208e88
logstart = 2147483652
rootino = 128
rbmino = 129
rsumino = 130
rextsize = 1
agblocks = 91552192
agcount = 59
rbmblocks = 0
logblocks = 32768
versionnum = 0x30e4
sectsize = 512
inodesize = 256
inopblock = 16
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 27
rextslog = 0
inprogress = 0
imax_pct = 25
icount = 19556544
ifree = 1036
fdblocks = 2634477046
frextents = 0
uquotino = 131
gquotino = 132
qflags = 0x7
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 0
width = 0
dirblklog = 0
logsectlog = 0
logsectsize = 0
logsunit = 0
features2 = 0


#  xfs_db -r -c 'sb 1' -c 'print' /dev/mapper/saharaVG-saharaLV
magicnum = 0x58465342
blocksize = 4096
dblocks = 2929670144
rblocks = 0
rextents = 0
uuid = 1bffcb88-0d9d-4228-93af-83ec9e208e88
logstart = 2147483652
rootino = 128
rbmino = 129
rsumino = 130
rextsize = 1
agblocks = 91552192
agcount = 32
rbmblocks = 0
logblocks = 32768
versionnum = 0x30e4
sectsize = 512
inodesize = 256
inopblock = 16
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 27
rextslog = 0
inprogress = 0
imax_pct = 25
icount = 19528640
ifree = 15932
fdblocks = 170285408
frextents = 0
uquotino = 131
gquotino = 132
qflags = 0x7
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 0
width = 0
dirblklog = 0
logsectlog = 0
logsectsize = 0
logsunit = 0
features2 = 0


I can immediately see with a diff that dblocks and agcount are
different.  Some other variables are also different, namely icount,
ifree, and fdblocks, which I am unclear how to interpret.  But judging
from the other threads I quoted, it seems that dblocks and agcount
are using values for a 20TB filesystem, and that therefore on a umount
the filesystem will become (at least temporarily) unmountable.

I've seen two different routes for trying to correct this issue--either use
xfs_db to manipulate the values directly, or using xfs_repair on a frozen
ro-mounted filesystem with a dump from xfs_metadata.  My worry about
the latter is twofold--will I even be able to do a remount?  And will I
have space for a dump from xfs_metadata of an 11TB filesystem?  I have
also seen advice in some of the other threads that xfs_repair can actually
make the damage worse (though presumably xfs_repair -n should be safe).

If xfs_db is a better way to go, and if the values xfs_db returns on a
umount don't change, would I simply do this?

# xfs_db -x /dev/mapper/saharaVG-saharaLV
sb 0 w dblocks = 2929670144 w agcount = 32

and then do an xfs_repair -n?

A route I have used many ages ago, on ext2 filesystems, was to specify
an alternate superblock when running e2fsck.  Can xfs_repair do this?

> Get a recent xfsprogs too, if you haven't already, it scales better
> than the really old versions.

I think I may have asked this in another post, but would you suggest
compiling 3.0 from source?  The version that CentOS distributes is marked
as 2.9.4, but I don't know what patches they've applied (if any).  Would 3.0
be more likely to help recover the fs?

Thanks all for your patience!

--keith

-- 
kkeller@sonic.net


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
