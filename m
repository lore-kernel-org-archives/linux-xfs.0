Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 07 Feb 2007 10:02:43 -0800 (PST)
Received: from imr2.americas.sgi.com (imr2.americas.sgi.com [198.149.16.18])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l17I2Vm7017436
	for <xfs@oss.sgi.com>; Wed, 7 Feb 2007 10:02:32 -0800
Message-ID: <45CA1435.7050100@sgi.com>
Date: Wed, 07 Feb 2007 18:02:29 +0000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] use struct kvec in struct uio
References: <20061129154607.GB6400@lst.de> <20070207125446.GB7740@lst.de>
In-Reply-To: <20070207125446.GB7740@lst.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph,

Looks like another lost take message to oss.

mod xfs-linux-melb:xfs-kern:27701a TAKE message
================================================
Subject: TAKE 954580 -

use struct kvec in struct uio

Date:  Tue Dec 12 13:13:14 AEDT 2006
Workarea:  vpn-emea-sw-emea-160-4.emea.sgi.com:/home/lachlan/isms/2.6.x-xfs
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
   longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:27701a
fs/xfs/support/move.h - 1.19 - changed
fs/xfs/linux-2.6/xfs_ioctl.c - 1.140 - changed
fs/xfs/dmapi/xfs_dm.c - 1.31 - changed
         - use struct kvec in struct uio

I also included this change to fix a warning introduced with your patch.

*** /usr/tmp/TmpDir.8968-0/fs/xfs/dmapi/xfs_dm.c_1.30   2007-02-07 18:00:52.000000000 +0000
--- /usr/tmp/TmpDir.8968-0/fs/xfs/dmapi/xfs_dm.c_1.31   2007-02-07 18:00:52.000000000 +0000
***************
*** 928,934 ****
   {
         int             sink;
         struct uio      auio;
!       struct iovec    aiov;
         int             rval;

         *nreadp = 0;
--- 928,934 ----
   {
         int             sink;
         struct uio      auio;
!       iovec_t         aiov;
         int             rval;

         *nreadp = 0;


Lachlan

Christoph Hellwig wrote:
> On Wed, Nov 29, 2006 at 04:46:07PM +0100, Christoph Hellwig wrote:
> 
>>All but one useage of struct uio are for kernel pointers, so let's use
>>struct kvec instead of struct iovec.  Because readlink by handle still
>>uses it with a user pointer we still have two sparse warnings, but the
>>noise level is reduced quite a bit by this.
> 
> 
> ping?
> 
> 
>>
>>Signed-off-by: Christoph Hellwig <hch@lst.de>
>>
>>Index: linux-2.6/fs/xfs/support/move.h
>>===================================================================
>>--- linux-2.6.orig/fs/xfs/support/move.h	2006-11-29 16:27:25.000000000 +0100
>>+++ linux-2.6/fs/xfs/support/move.h	2006-11-29 16:30:18.000000000 +0100
>>@@ -55,7 +55,7 @@
>> };
>> 
>> struct uio {
>>-	struct iovec	*uio_iov;   /* pointer to array of iovecs */
>>+	struct kvec	*uio_iov;   /* pointer to array of iovecs */
>> 	int		uio_iovcnt; /* number of iovecs in array */
>> 	xfs_off_t	uio_offset; /* offset in file this uio corresponds to */
>> 	int		uio_resid;  /* residual i/o count */
>>@@ -63,7 +63,7 @@
>> };
>> 
>> typedef struct uio uio_t;
>>-typedef struct iovec iovec_t;
>>+typedef struct kvec iovec_t;
>> 
>> extern int	xfs_uio_read (caddr_t, size_t, uio_t *);
>> 
>>Index: linux-2.6/fs/xfs/linux-2.6/xfs_ioctl.c
>>===================================================================
>>--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2006-11-29 16:33:37.000000000 +0100
>>+++ linux-2.6/fs/xfs/linux-2.6/xfs_ioctl.c	2006-11-29 16:34:43.000000000 +0100
>>@@ -388,7 +388,7 @@
>> 	aiov.iov_len	= olen;
>> 	aiov.iov_base	= hreq.ohandle;
>> 
>>-	auio.uio_iov	= &aiov;
>>+	auio.uio_iov	= (struct kvec *)&aiov;
>> 	auio.uio_iovcnt	= 1;
>> 	auio.uio_offset	= 0;
>> 	auio.uio_segflg	= UIO_USERSPACE;
> 
> ---end quoted text---
> 
> 
