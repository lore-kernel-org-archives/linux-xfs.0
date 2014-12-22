Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B653629DF7
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2014 16:46:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A46558F8035
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2014 14:46:47 -0800 (PST)
Received: from nihrelayxway4.hub.nih.gov (nihrelayxway4.hub.nih.gov
	[128.231.90.98]) by cuda.sgi.com with ESMTP id sm6XCzgbybM9VW74
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2014 14:46:46 -0800 (PST)
MIME-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: weird quota issue
From: "Weber, Charles (NIH/NIA/IRP) [C]" <weberc@grc.nia.nih.gov>
In-Reply-To: <20141222223540.GS15665@dastard>
Date: Mon, 22 Dec 2014 17:46:42 -0500
Message-ID: <2F3F57BB-59EA-4FF9-9254-6A598DE7AC46@grc.nia.nih.gov>
References: <3BD1EE39-8C26-4C5B-94B5-492422EECEDA@mail.nih.gov>
	<20141222204857.GK24183@dastard>
	<6F43BF63-A44E-43F6-A184-9AAC10DDDFDF@grc.nia.nih.gov>
	<20141222223540.GS15665@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

I wonder if it is a thin-provision issue? ~40TB allocated by the SAN but setup to not really allocate space until it is claimed by the OS. 

 xfs_db -c "sb 0" -c p /dev/dm-7

magicnum = 0x58465342
blocksize = 4096
dblocks = 10737418080
rblocks = 0
rextents = 0
uuid = f6a8f271-6e30-4de9-9b60-aa5f91ca1a52
logstart = 5368709124
rootino = 128
rbmino = 129
rsumino = 130
rextsize = 1
agblocks = 268435452
agcount = 40
rbmblocks = 0
logblocks = 521728
versionnum = 0xb5e4
sectsize = 512
inodesize = 256
inopblock = 16
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 28
rextslog = 0
inprogress = 0
imax_pct = 5
icount = 3354944
ifree = 272409
fdblocks = 10317701783
frextents = 0
uquotino = 131
gquotino = 0
qflags = 0
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 4
width = 4096
dirblklog = 0
logsectlog = 0
logsectsize = 0
logsunit = 16384
features2 = 0x8a
bad_features2 = 0x8a
> On Dec 22, 2014, at 5:35 PM, Dave Chinner <david@fromorbit.com> wrote:
> 
> On Mon, Dec 22, 2014 at 05:13:06PM -0500, Weber, Charles (NIH/NIA/IRP) [C] wrote:
>> Thanks for replying. The project part is a red herring and I have
>> abandoned it. The only reason project quotas even came up was the
>> winbind/quota issue. UID is fine.  The more interesting part is
>> the way the /proc/self/mounts and mtab/fstab are not coherent.
> 
> If /etc/mtab is not linked to /proc/mounts, then userspace maintains
> it and it does not reflect the mount options the kernel have active.
> YOU can put any amount of crap in invalid mount options that mount
> will just dump in /etc/mtab even though the kernel ignores them.
> 
> We generally expect that systems are set up like this:
> 
> $ ls -l /etc/mtab
> lrwxrwxrwx 1 root root 12 Jan  9  2012 /etc/mtab -> /proc/mounts
> $
> 
>> 
>> dmesg output
>> SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
>> SGI XFS Quota Management subsystem
>> XFS (dm-7): delaylog is the default now, option is deprecated.
>> XFS (dm-7): Mounting Filesystem
>> XFS (dm-7): Ending clean mount
>> XFS (dm-7): Failed to initialize disk quotas.
> 
> Which indicates that there's problems reading or allocating the
> quota inodes. What is the output of 'xfs_db -c "sb 0" -c p
> /dev/dm-7'?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
