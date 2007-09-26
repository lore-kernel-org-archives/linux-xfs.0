Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Sep 2007 17:11:04 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8Q0AvQ3018759
	for <xfs@oss.sgi.com>; Tue, 25 Sep 2007 17:10:59 -0700
Received: from cxfsmac10.melbourne.sgi.com (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id KAA12460; Wed, 26 Sep 2007 10:10:54 +1000
Message-ID: <46F9A38E.6000200@sgi.com>
Date: Wed, 26 Sep 2007 10:10:54 +1000
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] kill xfs_freeze
References: <20070925194528.GA1818@lst.de>
In-Reply-To: <20070925194528.GA1818@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> No need to have a wrapper just two call two more functions.
...
> 
> Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c	2007-09-23 13:54:35.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c	2007-09-23 13:56:12.000000000 +0200
> @@ -692,7 +692,7 @@ xfs_quiesce_fs(
>   * care of the metadata. New transactions are already blocked, so we need to
>   * wait for any remaining transactions to drain out before proceding.
>   */
> -STATIC void
> +void
>  xfs_attr_quiesce(
>  	xfs_mount_t	*mp)
>  {
> Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.h	2007-09-23 13:56:16.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_vfsops.h	2007-09-23 13:56:34.000000000 +0200

This has removed all use of xfs_freeze, but I cant see a diff
hunk that removes the xfs_freeze implementation from xfs_vfsops.c

Don
