Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4I060aN016568 for <xfs@oss.sgi.com>; Mon, 17 May 2010 19:06:01 -0500
Received: from mail-qy0-f187.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 80C0B9C4949
	for <xfs@oss.sgi.com>; Mon, 17 May 2010 17:09:16 -0700 (PDT)
Received: from mail-qy0-f187.google.com (mail-qy0-f187.google.com
	[209.85.221.187]) by cuda.sgi.com with ESMTP id
	LDoO4ImY6Ps9mVAj for <xfs@oss.sgi.com>;
	Mon, 17 May 2010 17:09:16 -0700 (PDT)
Received: by qyk17 with SMTP id 17so7304176qyk.12
	for <xfs@oss.sgi.com>; Mon, 17 May 2010 17:08:16 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 17 May 2010 17:08:16 -0700
Message-ID: <AANLkTikek9K8-BqNgee_tXz72beHpWEUl41YtDPrD-3P@mail.gmail.com>
Subject: mounting hixfs (Hitachi "tuned" XFS) on 2.6 kernel
From: big beer <bigbeerjr@gmail.com>
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
To: xfs@oss.sgi.com

Hello list,

I seem to find myself in the unlucky situation of having myself some
hixfs filesystems I'm trying to migrate off of.
Some background on hixfs (as I understand it).
At some point in the past, prior to purchasing a NAS company, Hitachi
decided that they could make their own NAS solution using
linux/LVM/XFS. They give you a little integrated 2.4 linux blade in
one of their storage subsystems with a nice (circa yr 2000) web
frontend to manage samba and nfs serving. The disks that are presented
to this little guy are encapsulated in LVM and formatted lv's with a
variant of XFS that is shown as hixfs on the machine. You get a very
limited shell on this guy and you have to run everything through sudo
if you want cli access (which is heavily limited).

I'm in the process of trying to get off said solution and am running
into some issues getting the file system on this black box to be
mounted/recognized on a standard 2.6 linux host.

Here is some output from some xfs tools:

box ~ # xfs_check /dev/vghorclu00/lvARRAY2
xfs_check: unexpected XFS SB magic number 0x48584653
bad superblock magic number 48584653, giving up

box ~ # xfs_repair -v /dev/vghorclu00/lvARRAY2
Phase 1 - find and verify superblock...
bad primary superblock - bad magic number !!!

attempting to find secondary superblock... Sorry, could not find valid
secondary superblock
Exiting now.

box ~ # xfs_db /dev/vghorclu00/lvARRAY2
xfs_db: unexpected XFS SB magic number 0x48584653
xfs_db> sb 0
xfs_db> p
magicnum = 0x48584653
blocksize = 4096
dblocks = 136437760
rblocks = 0
rextents = 0
uuid = bc354b71-ad02-4e47-b27a-428060c18622
logstart = 68157444
rootino = 128
rbmino = 129
rsumino = 130
rextsize = 16
agblocks = 1048576
agcount = 131
rbmblocks = 0
logblocks = 1280
versionnum = 0x20d4
sectsize = 512
inodesize = 256
inopblock = 16
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 20
rextslog = 0
inprogress = 0
imax_pct = 25
icount = 9486016
ifree = 3138839
fdblocks = 14074682
frextents = 0
uquotino = 131
gquotino = 132
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
xfs_db>

I would like to be able to get this FS mounted on a box that supports
vanilla XFS.
I'm hoping that Hitachi has done something like change the magic
number so that the normal user land tools will just bail. I've got a
way to make quick copies of this FS so I am fair game to experiment on
it.

I've made some calls to Hitachi to find out what the deal is, so far
no one there has been very helpful, nor provided me with any insight
to getting these mounted. I'm thinking that since XFS is GPL'd and
they made extensions to it, and sold it, they should at least provide
source for their user land tools/kernel module for the FS. Unless they
licensed it from SGI?

I should note that on their black box solution they've got a different
set of user land tools all prefixed with "hi" (hixfs_db, hixfs_repair,
etc). While I do have ways to grab their userland tools, the kernel
module is for 2.4 so I don't think I'll have much luck just c&p
everything over.

If anyone has any ideas on what to do, and/or where to start, I'd
greatly appreciate it.

Thanks!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
