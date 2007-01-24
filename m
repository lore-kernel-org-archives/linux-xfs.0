Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Jan 2007 23:01:32 -0800 (PST)
Received: from nz-out-0506.google.com (nz-out-0506.google.com [64.233.162.239])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0O71Qqw010579
	for <xfs@oss.sgi.com>; Tue, 23 Jan 2007 23:01:27 -0800
Received: by nz-out-0506.google.com with SMTP id m22so76118nzf
        for <xfs@oss.sgi.com>; Tue, 23 Jan 2007 23:00:31 -0800 (PST)
Message-ID: <5d96567b0701232234y2ff15762sbd1aaada5c3a0a0@mail.gmail.com>
Date: Wed, 24 Jan 2007 08:34:22 +0200
From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: [DISCUSS] xfs allocation bitmap method over linux raid
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: dgc@sgi.com
Cc: xfs@oss.sgi.com

David Hello.
I have looked up in LKML and hopefully you are the one to ask in
regard to xfs file system in Linux.
My name is Raz and I work for a video servers company.
These servers demand high throughput from the storage.
We applied XFS file system on our machines.

A video server reads a file in a sequential manner. So, if a
file extent size is not a factor of the stripe unit size a sequential
read over a raid would break into several small pieces which
is undesirable for performance.

I have been examining the bitmap of a file over Linux raid5.
According to the documentation XFS tries to align a file on
stripe unit size.

What I have done is to fix the bitmap allocation method during
the writing to be aligned by the stripe unit size.
The thing is , though this seems to work , I do not know whether I
missed something.

The bellow is a patch (a mere two lines) i have applied to the
file system and I would be really grateful to have your opinion.


diff -ru --exclude='*.o'
/d1/rt/kernels/linux-2.6.17-UNI/fs/xfs/xfs_iomap.c
linux-2.6.17-UNI/fs/xfs/xfs_iomap.c
--- /d1/rt/kernels/linux-2.6.17-UNI/fs/xfs/xfs_iomap.c  2006-06-18
01:49:35.000000000 +0000
+++ linux-2.6.17-UNI/fs/xfs/xfs_iomap.c 2006-12-26 14:11:02.000000000 +0000
@@ -441,8 +441,8 @@
    if (unlikely(rt)) {
        if (!(extsz = ip->i_d.di_extsize))
            extsz = mp->m_sb.sb_rextsize;
-   } else {
-       extsz = ip->i_d.di_extsize;
+   } else {
+        extsz =  mp->m_dalign; // raz fix alignment to raid stripe unit
    }

    isize = ip->i_d.di_size;
@@ -663,7 +663,7 @@
        if (!(extsz = ip->i_d.di_extsize))
            extsz = mp->m_sb.sb_rextsize;
    } else {
-       extsz = ip->i_d.di_extsize;
+       extsz =  mp->m_dalign; //  raz fix alignment to raid stripe unit
    }

    offset_fsb = XFS_B_TO_FSBT(mp, offset);
~


Thank you.
-- 
Raz
