Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 28 Oct 2007 08:36:46 -0700 (PDT)
Received: from b.mx.filmlight.ltd.uk (bongo.filmlight.ltd.uk [217.40.27.26])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9SFafYr013514
	for <xfs@oss.sgi.com>; Sun, 28 Oct 2007 08:36:43 -0700
Message-ID: <47249E7A.7060709@filmlight.ltd.uk>
Date: Sun, 28 Oct 2007 14:36:42 +0000
From: Roger Willcocks <roger@filmlight.ltd.uk>
MIME-Version: 1.0
Subject: bug: truncate to zero + setuid
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

The nfsv3 setattr call permits a simultaneous truncate + setuid/gid 
operation. Normally XFS handles this fine, but if the file's being 
truncated to zero, and the file's already empty, XFS simply ignores the 
setuid/gid part, returning 'success'.

The error's in xfs_vnodeops.c/xfs_setattr below the comment 
'Short circuit the truncate case for zero length files', which bypasses 
all other changes.

The simplest fix is to test whether this is the only change that's 
happening, otherwise you get tangled in transactions.

        if (mask & XFS_AT_SIZE) {
                /* Short circuit the truncate case for zero length files */
-               if ((vap->va_size == 0) &&
+               if (((mask & ~XFS_AT_SIZE) == 0) && (vap->va_size == 0) &&
                   (ip->i_d.di_size == 0) && (ip->i_d.di_nextents == 0)) {


--
Roger
