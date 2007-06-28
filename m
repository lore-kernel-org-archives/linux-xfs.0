Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 11:15:41 -0700 (PDT)
Received: from smtp2.linux-foundation.org (smtp2.linux-foundation.org [207.189.120.14])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5SIFatL020623
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 11:15:36 -0700
Date: Thu, 28 Jun 2007 11:15:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 3/3] Fix XFS_IOC_FSBULKSTAT{,_SINGLE} and
 XFS_IOC_FSINUMBERS in compat mode
Message-Id: <20070628111530.829e7a06.akpm@linux-foundation.org>
In-Reply-To: <20070619132726.893544847@suse.cz>
References: <20070619132549.266927601@suse.cz>
	<20070619132726.893544847@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: mmarek@suse.cz
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007 15:25:52 +0200 mmarek@suse.cz wrote:

> * 32bit struct xfs_fsop_bulkreq has different size and layout of
>   members, no matter the alignment. Move the code out of the #else
>   branch (why was it there in the first place?). Define _32 variants of
>   the ioctl constants.
> * 32bit struct xfs_bstat is different because of time_t and on
>   i386 becaus of different padding. Create a new formatter
>   xfs_bulkstat_one_compat() that takes care of this. To do this, we need
>   to make xfs_bulkstat_one_iget() and xfs_bulkstat_one_dinode()
>   non-static.
> * i386 struct xfs_inogrp has different padding. Introduce a similar
>   "formatter" mechanism for xfs_inumbers: the native formatter is just a
>   copy_to_user, the compat formatter takes care of the different layout

test.kernel.org build failed:

  CC      fs/xfs/linux-2.6/xfs_ioctl32.o
fs/xfs/linux-2.6/xfs_ioctl32.c: In function ‘xfs_ioc_bulkstat_compat’:
fs/xfs/linux-2.6/xfs_ioctl32.c:334: error: ‘xfs_inumbers_fmt_compat’ undeclared (first use in this function)
fs/xfs/linux-2.6/xfs_ioctl32.c:334: error: (Each undeclared identifier is reported only once
fs/xfs/linux-2.6/xfs_ioctl32.c:334: error: for each function it appears in.)


http://test.kernel.org/abat/96972/debug/test.log.0
http://test.kernel.org/abat/96972/build/dotconfig
