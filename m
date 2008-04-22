Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Apr 2008 05:43:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3MChaBp008805
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 05:43:37 -0700
Received: from wr-out-0506.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8823E12A543B
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 05:44:18 -0700 (PDT)
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.235]) by cuda.sgi.com with ESMTP id 1wobhx8o3LHOlbYw for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 05:44:18 -0700 (PDT)
Received: by wr-out-0506.google.com with SMTP id c48so1169410wra.23
        for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 05:44:17 -0700 (PDT)
Message-ID: <18b102300804220544r4bad21b8pe5fc3d61460389d4@mail.gmail.com>
Date: Tue, 22 Apr 2008 08:44:16 -0400
From: "James Klaas" <jklaas@appalachian.dyndns.org>
Subject: Re: Is my partition repairable?
In-Reply-To: <480AC8C1.1050102@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <18b102300804090813u24423515k4c478635494534dc@mail.gmail.com>
	 <480AC8C1.1050102@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Sun, Apr 20, 2008 at 12:38 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
> James Klaas wrote:
>  > I've been struggling to recover/repair an XFS partition that is on a
>  > Linux software raid.  This is on Ubuntu Feisty (7.04) with xfsprogs
>  > v2.8.18.
>  >
>  > When I try to mount the system, it attempts a recovery:
>  >
>  > [127094.470809] Filesystem "md0": Disabling barriers, not supported by
>  > the underlying device
>  > [127094.471954] XFS mounting filesystem md0
>  > [127094.613551] Starting XFS recovery on filesystem: md0 (logdev: internal)
>  > [127094.858897] Filesystem "md0": XFS internal error
>  > xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller
>  > 0xf8eda9fb
>
>  The simplest approach, though perhaps not the least prone to data loss,
>  is to run xfs_repair with the -L option to zero out the log before
>  proceeding.
>
>  You could also mount -o ro,norecovery first to back up as much critical
>  data as possible, beforehand.
>
>  -Eric
>
Thank you, that actually worked this time for me.  I was probably not
doing it right before.

Now, I have a copy from when I "mount -o ro,norecovery" the partition
and after I ran "xfs_repair -L" on the partition.

I got a lot of lost+found entries which I went through and decided to
mostly throw away (not important files).  Most showed up on the copy
of the norecovery mounted filesystem anyway.

One puzzling thing though.  Many files have different md5sums on the
copied filesystem versus the repaired filesystem.  I've gone through a
few of them, but I've been unable to determine a real difference.  Do
you have any advice as to which files to trust more?  I'm inclined to
trust the files on the repaired filesystem.

James
