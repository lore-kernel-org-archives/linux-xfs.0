Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8NNK8Jd042935 for <xfs@oss.sgi.com>; Wed, 23 Sep 2009 18:20:09 -0500
Received: from mail.phy.duke.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 847021185F5F
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2009 16:21:26 -0700 (PDT)
Received: from mail.phy.duke.edu (mail.phy.duke.edu [152.3.182.2]) by
	cuda.sgi.com with ESMTP id sXTSQmMbz8jgvd7D for
	<xfs@oss.sgi.com>; Wed, 23 Sep 2009 16:21:26 -0700 (PDT)
Date: Wed, 23 Sep 2009 19:21:21 -0400 (EDT)
From: Jimmy Dorff <jdorff@phy.duke.edu>
Subject: Re: problems with xfs_growfs after lvextend
In-Reply-To: <4ABA9523.60909@thebarn.com>
Message-ID: <Pine.LNX.4.64.0909231918400.14750@login2.phy.duke.edu>
References: <4ABA8D56.2040101@phy.duke.edu> <4ABA9523.60909@thebarn.com>
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
To: Russell Cattelan <cattelan@thebarn.com>
Cc: xfs@oss.sgi.com

On Wed, 23 Sep 2009, Russell Cattelan wrote:
> The good new is you can easily restore the the values of the primary
> super block from one of the other superblocks
> using the xfs_db cmd.
>
> The bad news is that if you have run repair you may have messed things up.
>
> basically pull up xfs_db
>> sb 0 p
> ... output ..
>> sb 1 p
> ... output ...
>
> Send us the result of that and we can figure out which values need to
> be restored.

Here you go. Thanks for your help!

xfs_db> sb 0
xfs_db> p
magicnum = 0x58465342
blocksize = 4096
dblocks = 8053063680
rblocks = 0
rextents = 0
uuid = bada0c85-0739-4fdb-99fb-6bb7777eb4d0
logstart = 1073741828
rootino = 128
rbmino = 129
rsumino = 130
rextsize = 1
agblocks = 50331648
agcount = 160
rbmblocks = 0
logblocks = 32768
versionnum = 0x3084
sectsize = 512
inodesize = 256
inopblock = 16
fname = "DATA\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 26
rextslog = 0
inprogress = 0
imax_pct = 25
icount = 103936
ifree = 269
fdblocks = 6499724269
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
logsectlog = 0
logsectsize = 0
logsunit = 0
features2 = 0
bad_features2 = 0
xfs_db> sb 1
xfs_db> p
magicnum = 0x58465342
blocksize = 4096
dblocks = 1610612736
rblocks = 0
rextents = 0
uuid = bada0c85-0739-4fdb-99fb-6bb7777eb4d0
logstart = 1073741828
rootino = 128
rbmino = 129
rsumino = 130
rextsize = 1
agblocks = 50331648
agcount = 32
rbmblocks = 0
logblocks = 32768
versionnum = 0x3084
sectsize = 512
inodesize = 256
inopblock = 16
fname = "DATA\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 26
rextslog = 0
inprogress = 0
imax_pct = 25
icount = 103936
ifree = 269
fdblocks = 57273829
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
logsectlog = 0
logsectsize = 0
logsunit = 0
features2 = 0
bad_features2 = 0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
