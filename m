Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D19E47F50
	for <xfs@oss.sgi.com>; Sun, 21 Jul 2013 01:34:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 51683AC001
	for <xfs@oss.sgi.com>; Sat, 20 Jul 2013 23:34:06 -0700 (PDT)
Received: from mail-ye0-f181.google.com (mail-ye0-f181.google.com
	[209.85.213.181]) by cuda.sgi.com with ESMTP id
	MeMNLeRc2cOILNxx (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 20 Jul 2013 23:34:05 -0700 (PDT)
Received: by mail-ye0-f181.google.com with SMTP id g12so1795591yee.12
	for <xfs@oss.sgi.com>; Sat, 20 Jul 2013 23:34:04 -0700 (PDT)
Message-ID: <51EB80DB.80602@gmail.com>
Date: Sun, 21 Jul 2013 02:34:03 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 00/49] xfsprogs: patches for crc-dev branch
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-1-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On 07/19/2013 02:44 AM, Dave Chinner wrote:

> Comments, thoughts, flames?

I was hoping that I could use this 3.12 patchset with a 3.11.0-rc 
kernel, but the xfstests look like a disaster by going that way.  
The combination of 3.12 XFS code and 3.12 xfsprogs seems to be 
working well.  xfs_repair, mkfs.xfs, and xfs_logprint still seem 
to work either way.

The following patches had issues during the `git am` session:

# Patch 11
Applying: libxfs: sync xfs_ialloc.c to the kernel code
/usr/src/xfs/xfsprogs/.git/rebase-apply/patch:226: trailing whitespace.
		/* 
warning: 1 line adds whitespace errors.

# Patch 20
Applying: xfs: separate dquot on disk format definitions out of xfs_quota.h
/usr/src/xfs/xfsprogs/.git/rebase-apply/patch:64: trailing whitespace.
 * This header file defines all the on-disk format definitions for 
warning: 1 line adds whitespace errors.

# Patch 27
Applying: xfs: move inode fork definitions to a new header file
fatal: corrupt patch at line 2313
Patch failed at 0001 xfs: move inode fork definitions to a new header file
The copy of the patch that failed is found in:
   /usr/src/xfs/xfsprogs/.git/rebase-apply/patch
When you have resolved this problem, run "git am --resolved".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

# Deleted the blank line from the patch (Thunderbird save error?).
# Patch 27 (Take 2)
Applying: xfs: move inode fork definitions to a new header file

# Patch 49
Applying: xfsprogs: add dtype support to mkfs and db
/usr/src/xfs/xfsprogs/.git/rebase-apply/patch:163: new blank line at EOF.
+
warning: 1 line adds whitespace errors.

In other words, everything works so far.  Again, on one PC, the xfstests 
results are awful, with many xfs/* tests failing.  The results have yet 
to be reviwed closely, though.  There's a chance that something in 
xfstests didn't build against xfsprogs...unless all the hole punch and 
dmapi tests really are having issues...not enough info yet...

Thanks!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
