Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 May 2008 01:01:33 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4T81RAS013140
	for <linux-xfs@oss.sgi.com>; Thu, 29 May 2008 01:01:28 -0700
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 43AD71751694
	for <linux-xfs@oss.sgi.com>; Thu, 29 May 2008 01:02:17 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by cuda.sgi.com with ESMTP id 5N3gr2Lj6naoyMST for <linux-xfs@oss.sgi.com>; Thu, 29 May 2008 01:02:17 -0700 (PDT)
Received: from [10.0.0.21] (e179054170.adsl.alicedsl.de [85.179.54.170])
	by mail.lichtvoll.de (Postfix) with ESMTP id 4D0375ADEF
	for <linux-xfs@oss.sgi.com>; Thu, 29 May 2008 10:02:34 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Question for XFS (mounting and clean bit)
Date: Thu, 29 May 2008 10:02:14 +0200
References: <20080527181336.22qjfcgcfdlwsg40@webmail.versatel.de> (sfid-20080527_213946_881555_0B129DA7)
In-Reply-To: <20080527181336.22qjfcgcfdlwsg40@webmail.versatel.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805291002.14665.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Dienstag 27 Mai 2008 schrieb Andre Nitschke:
> Hello,
> i am a Linux User from Germany and chanched to xfs. I use Debian 4 and
> the installer creates lilo. Because of a wrong configuration i
> destroyed the lilo.conf and rebootet with a systemrescuecd. from here i
> mount the xfs partition and try to run lilo, but it fails.
> then i had a realy bad idea. i unmount the xfs partition and then mount
> it as root, but there exit a root file system.

Hi Andre!

Some additional hint on this:

I think what you actually wanted to do was:

mount /dev/sda1 /mnt
chroot /mnt
lilo
Ctrl-D

I.e. you use chroot to change a directory temporarily and only for all 
subsequent commands in the same console session to /.

> i have two questions. first, is the xfs on my working-machine damaged
> by my bad idea mounting two devices as root
> and secound, is the clean bit removed when mounting a xfs or when i
> first write data on it?

Also here some clarification and confirmation on my previous statement:

I believe that a new mount is only seen by process that enter the mount 
point directory after the mount has been done. I think that all the 
processes that are working already in that directory or a sub directory 
of it will still see the situation before the mount.

Lets try this out:

Shell 1:

/mnt/zeit is on the / filesystem:

martin@shambala:~ -> cd /mnt/zeit
martin@shambala:/mnt/zeit -> ls -lid .
89142 drwxr-xr-x 2 root root 6 2008-01-28 14:35 .

Shell 2:

I mount a filesystem on top of it:

root@shambala:~ -> mount /dev/shambala/lugcamp2008 /mnt/zeit
root@shambala:~ -> cd /mnt/zeit
root@shambala:/mnt/zeit -> ls -lid .
128 drwxrwxr-x 3 root martin 18 2008-05-04 00:32 .

128 appears to be the root inode (/) of the XFS filesystem in question.

But see Shell 1 again:

martin@shambala:/mnt/zeit -> ls -lid .
89142 drwxr-xr-x 2 root root 6 2008-01-28 14:35 .

Get the picture? Shell 1 still sees the old inode.

Shell 2:

Lets create a file in there:
root@shambala:/mnt/zeit -> touch fs1

And now shell 3:

Mount another filesystem on top of the same directory:

root@shambala:/mnt/zeit -> ls -lid .
128 drwxr-xr-x 24 root root 4096 2008-05-24 20:57 .
root@shambala:/mnt/zeit -> LANG=EN stat fs1
stat: cannot stat `fs1': No such file or directory
root@shambala:/mnt/zeit -> stat fs1
root@shambala:/mnt/zeit -> touch fs2

I get the same root inode number (since /dev/sda1 is a XFS filesystem as 
well which happens to use 128 as root inode number), but the file "fs1" 
is not there anymore, so this is clearly a different filesystem.

Back to shell 2:

It still sees fs1, but not fs2:

root@shambala:/mnt/zeit -> LANG=EN stat fs2
stat: cannot stat `fs2': No such file or directory

root@shambala:/mnt/zeit -> LANG=EN stat fs1
  File: `fs1'
  Size: 0               Blocks: 0          IO Block: 4096   regular empty 
file
Device: fd00h/64768d    Inode: 184442      Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2008-05-29 09:45:58.754469708 +0200
Modify: 2008-05-29 09:45:58.754469708 +0200
Change: 2008-05-29 09:45:58.754469708 +0200

Back to shell 1:

It still sees neither fs1 or fs2, but the inode before the first mount has 
happened:

martin@shambala:/mnt/zeit -> ls -lid .
89142 drwxr-xr-x 2 root root 6 2008-01-28 14:35 .

martin@shambala:/mnt/zeit -> LANG=EN stat fs1 fs2
stat: cannot stat `fs1': No such file or directory
stat: cannot stat `fs2': No such file or directory

But now lets CD out of the directory and back in again:

martin@shambala:/mnt/zeit -> ls -lid .
128 drwxr-xr-x 24 root root 4096 2008-05-29 09:47 .
martin@shambala:/mnt/zeit -> LANG=EN stat fs1 fs2
stat: cannot stat `fs1': No such file or directory
  File: `fs2'
  Size: 0               Blocks: 0          IO Block: 4096   regular empty 
file
Device: 801h/2049d      Inode: 75339       Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2008-05-29 09:47:58.090807158 +0200
Modify: 2008-05-29 09:47:58.090807158 +0200
Change: 2008-05-29 09:47:58.090807158 +0200

*Now* it sees the current situation of the second mount.

Back to shell 2:

While shell 2 still sees the situation of the first mount:

root@shambala:/mnt/zeit -> LANG=EN stat fs1 fs2
  File: `fs1'
  Size: 0               Blocks: 0          IO Block: 4096   regular empty 
file
Device: fd00h/64768d    Inode: 184442      Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2008-05-29 09:45:58.754469708 +0200
Modify: 2008-05-29 09:45:58.754469708 +0200
Change: 2008-05-29 09:45:58.754469708 +0200
stat: cannot stat `fs2': No such file or directory

Even when I start a new shell, it still sees the first mount cause it 
inherits the namespace from its parent process:

root@shambala:/mnt/zeit -> bash
root@shambala:/mnt/zeit -> LANG=EN stat fs1 fs2
  File: `fs1'
  Size: 0               Blocks: 0          IO Block: 4096   regular empty 
file
Device: fd00h/64768d    Inode: 184442      Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2008-05-29 09:45:58.754469708 +0200
Modify: 2008-05-29 09:45:58.754469708 +0200
Change: 2008-05-29 09:45:58.754469708 +0200
stat: cannot stat `fs2': No such file or directory

Only a change out of the mount point directory updates the view of the 
process:

root@shambala:/mnt -> cd zeit
root@shambala:/mnt/zeit -> LANG=EN stat fs1 fs2
stat: cannot stat `fs1': No such file or directory
  File: `fs2'
  Size: 0               Blocks: 0          IO Block: 4096   regular empty 
file
Device: 801h/2049d      Inode: 75339       Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2008-05-29 09:47:58.090807158 +0200
Modify: 2008-05-29 09:47:58.090807158 +0200
Change: 2008-05-29 09:47:58.090807158 +0200


Confused? ;-) Then I suggest playing around with this a bit. But with a 
different directory than / ;-)

That shown I I think that only processes you started *after* your second 
mount will have seen the XFS fileystem you mounted. So the only thing I 
think that might have happened is that a process that you started in your 
shell *after* you did the mount has written something to the XFS 
filesystem.

And in either case I am quite sure that nothing of all of this could 
actually have corrupted your XFS filesystem.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
