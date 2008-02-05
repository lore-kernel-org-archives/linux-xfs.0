Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Feb 2008 16:31:07 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m150UvZX009861
	for <xfs@oss.sgi.com>; Mon, 4 Feb 2008 16:31:01 -0800
Date: Tue, 5 Feb 2008 11:31:10 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Some kind of problems with xfs and 2.6.24 kernel
Message-ID: <20080205003109.GI155407@sgi.com>
References: <39932.84.221.232.4.1202164725.squirrel@manage.unbit.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39932.84.221.232.4.1202164725.squirrel@manage.unbit.it>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrea Perotti <andreamtp@goodfellow.it>
Cc: xfs-oss <xfs@oss.sgi.com>

[please report problems direct to xfs@oss.sgi.com, not me ;)]

On Mon, Feb 04, 2008 at 11:38:45PM +0100, Andrea Perotti wrote:
> Hi David
>          I've found you address in a linux kernel mailing list and I guess
> you are the guy I was looking for.
> 
> I'm gentoo linux user and I'm running on my laptop the 2.6.24 kernel with
> the standard gentoo patchset and I have both / and /home on XFS.
> 
> During normal usage I got a couple of time the kernel error you can find
> attached.
> 
> Both of them occurred when I was connected with the imap server (dovecot)
> present on that machine, accessing to the same account (imap was reading
> into /home/$myuser/.maildir/... ) and I get aware that something was gone
> because  I cannot access to one of my dir inside my mailbox.
> 
> I hope these information could be usefull to you. If you need any extra
> info, like the option I used to create and mount FS or anything else, just
> ask me.
>

> Jan 31 15:12:09 stakanov_II BUG: unable to handle kernel paging request at virtual address f8000000
> Jan 31 15:12:09 stakanov_II printing eip: c022dd78 *pde = 00000000
> Jan 31 15:12:09 stakanov_II Oops: 0000 [#1] PREEMPT
> Jan 31 15:12:09 stakanov_II Modules linked in: b43 yenta_socket rsrc_nonstatic ssb
> Jan 31 15:12:09 stakanov_II
> Jan 31 15:12:09 stakanov_II Pid: 19390, comm: imap Not tainted (2.6.24-gentoo-metallica #4)
> Jan 31 15:12:09 stakanov_II EIP: 0060:[<c022dd78>] EFLAGS: 00010282 CPU: 0
> Jan 31 15:12:09 stakanov_II EIP is at xfs_file_readdir+0xf2/0x1aa
> Jan 31 15:12:09 stakanov_II EAX: 00000000 EBX: 000001a4 ECX: 00000058 EDX: 00000000
> Jan 31 15:12:09 stakanov_II ESI: 00000000 EDI: f7fffff8 EBP: f766d780 ESP: e05bbf1c
> Jan 31 15:12:09 stakanov_II DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Jan 31 15:12:09 stakanov_II Process imap (pid: 19390, ti=e05ba000 task=f7310f60 task.ti=e05ba000)
> Jan 31 15:12:09 stakanov_II Stack: 000001a4 00000000 0f49408a 00000000 00000000 c0159838 e05bbf94 e1de1a80
> Jan 31 15:12:09 stakanov_II 00000000 00000000 00000000 000001a4 00000000 f7fff000 00001000 00000ff8
> Jan 31 15:12:09 stakanov_II 000001ad 00000000 c03ae120 f766d780 fffffffe e1de27e8 c0159a00 e05bbf94
> Jan 31 15:12:09 stakanov_II Call Trace:
> Jan 31 15:12:09 stakanov_II [<c0159838>] filldir64+0x0/0xc5
> Jan 31 15:12:09 stakanov_II [<c0159a00>] vfs_readdir+0x4a/0x74
> Jan 31 15:12:09 stakanov_II [<c0159838>] filldir64+0x0/0xc5
> Jan 31 15:12:09 stakanov_II [<c0159a8d>] sys_getdents64+0x63/0xa5
> Jan 31 15:12:09 stakanov_II [<c0102546>] sysenter_past_esp+0x5f/0x85
> Jan 31 15:12:09 stakanov_II =======================
> Jan 31 15:12:09 stakanov_II Code: 04 81 e3 ff ff ff 7f 89 1c 24 ff 54 24 14 85
> c0 0f 85 a9 00 00 00 8b 4f 10 31 d2 83 c1 1f 83 e1 f8 29 4c 24 24 19 54 24 28
> 01 cf <8b> 47 08 8b 57 0c 83 7c 24 28 00 89 44 24 2c 89 54 24 30 7f 99
> Jan 31 15:12:09 stakanov_II EIP: [<c022dd78>] xfs_file_readdir+0xf2/0x1aa SS:ESP 0068:e05bbf1c
> Jan 31 15:12:09 stakanov_II ---[ end trace 96802517b18c4092 ]---
> Feb  4 10:49:18 stakanov_II BUG: unable to handle kernel paging request at virtual address f8000000
> Feb  4 10:49:18 stakanov_II printing eip: c022dd78 *pde = 00000000
> Feb  4 10:49:18 stakanov_II Oops: 0000 [#1] PREEMPT
> Feb  4 10:49:18 stakanov_II Modules linked in: yenta_socket rsrc_nonstatic snd_hda_intel
> Feb  4 10:49:18 stakanov_II
> Feb  4 10:49:18 stakanov_II Pid: 6057, comm: imap Not tainted (2.6.24-gentoo-metallica #9)
> Feb  4 10:49:18 stakanov_II EIP: 0060:[<c022dd78>] EFLAGS: 00010282 CPU: 0
> Feb  4 10:49:18 stakanov_II EIP is at xfs_file_readdir+0xf2/0x1aa
> Feb  4 10:49:18 stakanov_II EAX: 00000000 EBX: 000001a9 ECX: 00000058 EDX: 00000000
> Feb  4 10:49:18 stakanov_II ESI: 00000000 EDI: f7fffff8 EBP: ef5a2880 ESP: ef40bf1c
> Feb  4 10:49:18 stakanov_II DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Feb  4 10:49:18 stakanov_II Process imap (pid: 6057, ti=ef40a000 task=ef626520 task.ti=ef40a000)
> Feb  4 10:49:18 stakanov_II Stack: 000001a9 00000000 132fea33 00000000 00000000 c0159838 ef40bf94 ef98bc00
> Feb  4 10:49:18 stakanov_II 00000000 00000000 00000000 000001a9 00000000 f7fff000 00001000 00000ff8
> Feb  4 10:49:18 stakanov_II 000001b2 00000000 c03a6120 ef5a2880 fffffffe ef98ae28 c0159a00 ef40bf94
> Feb  4 10:49:18 stakanov_II Call Trace:
> Feb  4 10:49:18 stakanov_II [<c0159838>] filldir64+0x0/0xc5
> Feb  4 10:49:18 stakanov_II [<c0159a00>] vfs_readdir+0x4a/0x74
> Feb  4 10:49:18 stakanov_II [<c0159838>] filldir64+0x0/0xc5
> Feb  4 10:49:18 stakanov_II [<c0159a8d>] sys_getdents64+0x63/0xa5
> Feb  4 10:49:18 stakanov_II [<c0102546>] sysenter_past_esp+0x5f/0x85
> Feb  4 10:49:18 stakanov_II [<c0380000>] sta_info_release+0x0/0x5b
> Feb  4 10:49:18 stakanov_II =======================
> Feb  4 10:49:18 stakanov_II Code: 04 81 e3 ff ff ff 7f 89 1c 24 ff 54 24 14 85
> c0 0f 85 a9 00 00 00 8b 4f 10 31 d2 83 c1 1f 83 e1 f8 29 4c 24 24 19 54 24 28
> 01 cf <8b> 47 08 8b 57 0c 83 7c 24 28 00 89 44 24 2c 89 54 24 30 7f 99
> Feb  4 10:49:18 stakanov_II EIP: [<c022dd78>] xfs_file_readdir+0xf2/0x1aa SS:ESP 0068:ef40bf1c
> Feb  4 10:49:18 stakanov_II ---[ end trace d899adf5158e5245 ]---

Yeah, this is the third report of a readdir problem on 2.6.24. The others are
here:

http://oss.sgi.com/archives/xfs/2008-02/msg00019.html
http://oss.sgi.com/archives/xfs/2008-02/msg00007.html

I'm pulling down a metadump image of one of the problem filesystems right now
and I'm going to try to reproduce it locally.

When we find the problem, we'll push the fix into the stable branch. more
details in a while.

Cheers,

Dave.

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
