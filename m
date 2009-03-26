Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2QMc9GI194048 for <xfs@oss.sgi.com>; Thu, 26 Mar 2009 17:38:19 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2C10A3040E9
	for <xfs@oss.sgi.com>; Thu, 26 Mar 2009 15:37:44 -0700 (PDT)
Message-Id: <A429B4A0-C724-4B86-B5FB-98707C23CF0E@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090318094131.924623000@bombadil.infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH 2/5] xfs: kill mutex_t typedef
Date: Thu, 26 Mar 2009 17:31:10 -0500
References: <20090318094119.561416000@bombadil.infradead.org>
	<20090318094131.924623000@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mar 18, 2009, at 4:41 AM, Christoph Hellwig wrote:

> People continue to complain about this for weird reasons, but there's
> really no point in keeping this typedef for a couple of users anyway.

Yeah, linux community seems to shy away from type_t's in favor of
'struct type'.

Reviewed-by: Felix Blyakher <felixb@sgi.com>


> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
>
> Index: xfs/fs/xfs/linux-2.6/mutex.h
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/mutex.h	2009-02-24 21:01:18.877182725  
> +0100
> +++ /dev/null	1970-01-01 00:00:00.000000000 +0000
> @@ -1,25 +0,0 @@
> -/*
> - * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
> - * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software  
> Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -#ifndef __XFS_SUPPORT_MUTEX_H__
> -#define __XFS_SUPPORT_MUTEX_H__
> -
> -#include <linux/mutex.h>
> -
> -typedef struct mutex mutex_t;
> -
> -#endif /* __XFS_SUPPORT_MUTEX_H__ */
> Index: xfs/fs/xfs/linux-2.6/xfs_linux.h
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_linux.h	2009-02-24  
> 21:01:34.596153088 +0100
> +++ xfs/fs/xfs/linux-2.6/xfs_linux.h	2009-02-24 21:01:47.951030927  
> +0100
> @@ -38,7 +38,6 @@
> #include <kmem.h>
> #include <mrlock.h>
> #include <sv.h>
> -#include <mutex.h>
> #include <time.h>
>
> #include <support/ktrace.h>
> @@ -51,6 +50,7 @@
> #include <linux/blkdev.h>
> #include <linux/slab.h>
> #include <linux/module.h>
> +#include <linux/mutex.h>
> #include <linux/file.h>
> #include <linux/swap.h>
> #include <linux/errno.h>
> Index: xfs/fs/xfs/quota/xfs_dquot.h
> ===================================================================
> --- xfs.orig/fs/xfs/quota/xfs_dquot.h	2009-02-24 20:59:24.413152831  
> +0100
> +++ xfs/fs/xfs/quota/xfs_dquot.h	2009-02-24 20:59:39.642153943 +0100
> @@ -34,7 +34,7 @@
>  */
> typedef struct xfs_dqhash {
> 	struct xfs_dquot *qh_next;
> -	mutex_t		  qh_lock;
> +	struct mutex	  qh_lock;
> 	uint		  qh_version;	/* ever increasing version */
> 	uint		  qh_nelems;	/* number of dquots on the list */
> } xfs_dqhash_t;
> @@ -81,7 +81,7 @@ typedef struct xfs_dquot {
> 	xfs_qcnt_t	 q_res_bcount;	/* total regular nblks used+reserved */
> 	xfs_qcnt_t	 q_res_icount;	/* total inos allocd+reserved */
> 	xfs_qcnt_t	 q_res_rtbcount;/* total realtime blks used+reserved */
> -	mutex_t		 q_qlock;	/* quota lock */
> +	struct mutex	 q_qlock;	/* quota lock */
> 	struct completion q_flush;	/* flush completion queue */
> 	atomic_t          q_pincount;	/* dquot pin count */
> 	wait_queue_head_t q_pinwait;	/* dquot pinning wait queue */
> Index: xfs/fs/xfs/quota/xfs_qm.c
> ===================================================================
> --- xfs.orig/fs/xfs/quota/xfs_qm.c	2009-02-24 21:00:11.195028215 +0100
> +++ xfs/fs/xfs/quota/xfs_qm.c	2009-02-24 21:00:30.583030096 +0100
> @@ -55,7 +55,7 @@
>  * quota functionality, including maintaining the freelist and hash
>  * tables of dquots.
>  */
> -mutex_t		xfs_Gqm_lock;
> +struct mutex	xfs_Gqm_lock;
> struct xfs_qm	*xfs_Gqm;
> uint		ndquot;
>
> @@ -80,7 +80,7 @@ static struct shrinker xfs_qm_shaker = {
> };
>
> #ifdef DEBUG
> -extern mutex_t	qcheck_lock;
> +extern struct mutex	qcheck_lock;
> #endif
>
> #ifdef QUOTADEBUG
> Index: xfs/fs/xfs/quota/xfs_qm.h
> ===================================================================
> --- xfs.orig/fs/xfs/quota/xfs_qm.h	2009-02-24 21:00:11.207028206 +0100
> +++ xfs/fs/xfs/quota/xfs_qm.h	2009-02-24 21:00:52.676027690 +0100
> @@ -27,7 +27,7 @@ struct xfs_qm;
> struct xfs_inode;
>
> extern uint		ndquot;
> -extern mutex_t		xfs_Gqm_lock;
> +extern struct mutex	xfs_Gqm_lock;
> extern struct xfs_qm	*xfs_Gqm;
> extern kmem_zone_t	*qm_dqzone;
> extern kmem_zone_t	*qm_dqtrxzone;
> @@ -79,7 +79,7 @@ typedef xfs_dqhash_t	xfs_dqlist_t;
> typedef struct xfs_frlist {
>        struct xfs_dquot *qh_next;
>        struct xfs_dquot *qh_prev;
> -       mutex_t		 qh_lock;
> +       struct mutex	 qh_lock;
>        uint		 qh_version;
>        uint		 qh_nelems;
> } xfs_frlist_t;
> @@ -115,7 +115,7 @@ typedef struct xfs_quotainfo {
> 	xfs_qwarncnt_t	 qi_bwarnlimit;	 /* limit for blks warnings */
> 	xfs_qwarncnt_t	 qi_iwarnlimit;	 /* limit for inodes warnings */
> 	xfs_qwarncnt_t	 qi_rtbwarnlimit;/* limit for rt blks warnings */
> -	mutex_t		 qi_quotaofflock;/* to serialize quotaoff */
> +	struct mutex	 qi_quotaofflock;/* to serialize quotaoff */
> 	xfs_filblks_t	 qi_dqchunklen;	 /* # BBs in a chunk of dqs */
> 	uint		 qi_dqperchunk;	 /* # ondisk dqs in above chunk */
> 	xfs_qcnt_t	 qi_bhardlimit;	 /* default data blk hard limit */
> Index: xfs/fs/xfs/quota/xfs_qm_syscalls.c
> ===================================================================
> --- xfs.orig/fs/xfs/quota/xfs_qm_syscalls.c	2009-02-24  
> 21:01:03.015027884 +0100
> +++ xfs/fs/xfs/quota/xfs_qm_syscalls.c	2009-02-24 21:01:11.159155659  
> +0100
> @@ -960,7 +960,7 @@ xfs_dqhash_t *qmtest_udqtab;
> xfs_dqhash_t *qmtest_gdqtab;
> int	      qmtest_hashmask;
> int	      qmtest_nfails;
> -mutex_t	      qcheck_lock;
> +struct mutex  qcheck_lock;
>
> #define DQTEST_HASHVAL(mp, id) (((__psunsigned_t)(mp) + \
> 				 (__psunsigned_t)(id)) & \
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
