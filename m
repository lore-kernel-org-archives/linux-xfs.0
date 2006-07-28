Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 27 Jul 2006 22:14:27 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6S5DuDW008113
	for <xfs@oss.sgi.com>; Thu, 27 Jul 2006 22:14:07 -0700
Message-ID: <44C99C86.2000208@sgi.com>
Date: Fri, 28 Jul 2006 15:11:34 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: review: block bogus bulkstat messages, last stage
References: <20060726101537.H2118045@wobbly.melbourne.sgi.com>
In-Reply-To: <20060726101537.H2118045@wobbly.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: xfs@oss.sgi.com

Nathan Scott wrote:
> Hi,
> 
> Earlier changes removed most of the bogus verbosity from fsstress
> runs with debug kernels, when bulkstat is asked to report on non-
> inode data in its stat'ing.  This resolves the one remaining case
> which is the bulkstat_one vs a xfs_dilocate warning, by passing a
> flag down into dilocate indicating we may be looking up garbage,
> and not to spam the console in that situation.
> 
> cheers.
> 

1. xfs_ialloc.c
+		xfs_stack_trace();
What's the stack trace for?
It is just to give more info after one of the 3 error msgs
beforehand? Happens in DEBUG. Okay.

2. xfs_inode.h:
+#define XFS_IGET_CREATE		0x1
+#define XFS_IGET_BULKSTAT	0x2
Okay.

3. xfs_itable.c
xfs_bulkstat_one_iget calls xfs_iget with XFS_IGET_BULKSTAT flag.
Okay.

4. xfs_inode.c
xfs_iread takes in extra param, imap_flags
and passes it on to call of xfs_itobp
Okay
xfs_ialloc's xfs_trans_iget()'s IGET_CREATE -> XFS_IGET_CREATE
Okay

5. xfs_iget.c
IGET_CREATE -> XFS_IGET_CREATE
ok
some cleanup
xfs_iget_core calls xfs_iread with extra imap_flags of XFS_IMAP_BULKSTAT
if it is given its flag of XFS_IGET_BULKSTAT
ok

6. xfs_dm.c
xfs_dm_bulkall_iget_one calls xfs_iget with XFS_IGET_BULKSTAT
xfs_dm_bulkattr_iget_one calls xfs_iget with XFS_IGET_BULKSTAT
ok

Seems fine.

--Tim
