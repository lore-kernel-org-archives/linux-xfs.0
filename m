Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 21 Sep 2007 15:31:57 -0700 (PDT)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com [208.42.117.202])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8LMVoQ3032486
	for <xfs@oss.sgi.com>; Fri, 21 Sep 2007 15:31:51 -0700
Message-ID: <46F431C8.5010309@thebarn.com>
Date: Fri, 21 Sep 2007 16:04:08 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: [PATCH SERIES] untangle spinlock macros
References: <46E6221E.803@sandeen.net> <46E7460D.3000502@sgi.com> <46E749DD.8010200@sandeen.net> <46E78185.5040201@sgi.com> <20070912082940.GA25373@infradead.org> <46E8A848.8010601@sandeen.net>
In-Reply-To: <46E8A848.8010601@sandeen.net>
Content-Type: multipart/mixed;
 boundary="------------050308060602040202040303"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Lachlan McIlroy <lachlan@sgi.com>, Donald Douwsma <donaldd@sgi.com>, xfs-oss <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--------------050308060602040202040303
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Eric Sandeen wrote:
> Christoph Hellwig wrote:
>   
>> On Wed, Sep 12, 2007 at 04:04:53PM +1000, Lachlan McIlroy wrote:
>>   
>>     
>>> These changes look good Eric.
>>>
>>> I'm in two minds about losing the spinlock_destroy() macros though.  If 
>>> Linux
>>> ever implements a spinlock teardown routine it would be nice to still have 
>>> all
>>> the placeholders still there.  Although I can't imagine it would do any more
>>> than assert that the lock is not currently held.  If someone else wants to 
>>> lose
>>> the macros then I'm not going to argue.
>>>     
>>>       
>> I'd say keep them for now.  We don't need the spin.h header for them anyway,
>> as single macro can simply move to xfs_linux.h
>>
>>
>>   
>>     
> Try this on for size.....
>
>   
So this is a bit late now but please please leave the names they are 
useful for tracking locks.
especially in the freebsd witness code.
> ======================
>
> remove spinlock init abstraction macro in spin.h, remove the callers, 
> and  remove the file.  Move no-op spinlock_destroy to xfs_linux.h
>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/spin.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/spin.h
> +++ /dev/null
> @@ -1,27 +0,0 @@
> -/*
> - * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
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
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -#ifndef __XFS_SUPPORT_SPIN_H__
> -#define __XFS_SUPPORT_SPIN_H__
> -
> -#include <linux/sched.h>	/* preempt needs this */
> -#include <linux/spinlock.h>
> -
> -#define spinlock_init(lock, name)	spin_lock_init(lock)
> -#define	spinlock_destroy(lock)
> -
> -#endif /* __XFS_SUPPORT_SPIN_H__ */
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_buf.c
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.c
> @@ -1568,7 +1568,7 @@ xfs_alloc_delwrite_queue(
>  
>  	INIT_LIST_HEAD(&btp->bt_list);
>  	INIT_LIST_HEAD(&btp->bt_delwrite_queue);
> -	spinlock_init(&btp->bt_delwrite_lock, "delwri_lock");
> +	spin_lock_init(&btp->bt_delwrite_lock);
>  	btp->bt_flags = 0;
>  	btp->bt_task = kthread_run(xfsbufd, btp, "xfsbufd");
>  	if (IS_ERR(btp->bt_task)) {
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_linux.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_linux.h
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_linux.h
> @@ -43,7 +43,6 @@
>  
>  #include <kmem.h>
>  #include <mrlock.h>
> -#include <spin.h>
>  #include <sv.h>
>  #include <mutex.h>
>  #include <sema.h>
> @@ -75,6 +74,7 @@
>  #include <linux/notifier.h>
>  #include <linux/delay.h>
>  #include <linux/log2.h>
> +#include <linux/spinlock.h>
>  
>  #include <asm/page.h>
>  #include <asm/div64.h>
> @@ -145,6 +145,8 @@
>  #define current_restore_flags_nested(sp, f)	\
>  		(current->flags = ((current->flags & ~(f)) | (*(sp) & (f))))
>  
> +#define spinlock_destroy(lock)
> +
>  #define NBPP		PAGE_SIZE
>  #define NDPP		(1 << (PAGE_SHIFT - 9))
>  
> Index: linux-2.6-xfs/fs/xfs/quota/xfs_qm.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/quota/xfs_qm.c
> +++ linux-2.6-xfs/fs/xfs/quota/xfs_qm.c
> @@ -1131,7 +1131,7 @@ xfs_qm_init_quotainfo(
>  		return error;
>  	}
>  
> -	spinlock_init(&qinf->qi_pinlock, "xfs_qinf_pin");
> +	spin_lock_init(&qinf->qi_pinlock);
>  	xfs_qm_list_init(&qinf->qi_dqlist, "mpdqlist", 0);
>  	qinf->qi_dqreclaims = 0;
>  
> Index: linux-2.6-xfs/fs/xfs/support/debug.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/support/debug.c
> +++ linux-2.6-xfs/fs/xfs/support/debug.c
> @@ -17,7 +17,6 @@
>   */
>  #include <xfs.h>
>  #include "debug.h"
> -#include "spin.h"
>  
>  static char		message[1024];	/* keep it off the stack */
>  static DEFINE_SPINLOCK(xfs_err_lock);
> Index: linux-2.6-xfs/fs/xfs/support/ktrace.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/support/ktrace.h
> +++ linux-2.6-xfs/fs/xfs/support/ktrace.h
> @@ -18,8 +18,6 @@
>  #ifndef __XFS_SUPPORT_KTRACE_H__
>  #define __XFS_SUPPORT_KTRACE_H__
>  
> -#include <spin.h>
> -
>  /*
>   * Trace buffer entry structure.
>   */
> Index: linux-2.6-xfs/fs/xfs/xfs_alloc.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_alloc.c
> +++ linux-2.6-xfs/fs/xfs/xfs_alloc.c
> @@ -2206,7 +2206,7 @@ xfs_alloc_read_agf(
>  			be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]);
>  		pag->pagf_levels[XFS_BTNUM_CNTi] =
>  			be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
> -		spinlock_init(&pag->pagb_lock, "xfspagb");
> +		spin_lock_init(&pag->pagb_lock);
>  		pag->pagb_list = kmem_zalloc(XFS_PAGB_NUM_SLOTS *
>  					sizeof(xfs_perag_busy_t), KM_SLEEP);
>  		pag->pagf_init = 1;
> Index: linux-2.6-xfs/fs/xfs/xfs_log.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_log.c
> +++ linux-2.6-xfs/fs/xfs/xfs_log.c
> @@ -1189,8 +1189,8 @@ xlog_alloc_log(xfs_mount_t	*mp,
>  	ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
>  	log->l_xbuf = bp;
>  
> -	spinlock_init(&log->l_icloglock, "iclog");
> -	spinlock_init(&log->l_grant_lock, "grhead_iclog");
> +	spin_lock_init(&log->l_icloglock);
> +	spin_lock_init(&log->l_grant_lock);
>  	initnsema(&log->l_flushsema, 0, "ic-flush");
>  	xlog_state_ticket_alloc(log);  /* wait until after icloglock inited */
>  
> Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c
> +++ linux-2.6-xfs/fs/xfs/xfs_mount.c
> @@ -136,8 +136,8 @@ xfs_mount_init(void)
>  		mp->m_flags |= XFS_MOUNT_NO_PERCPU_SB;
>  	}
>  
> -	spinlock_init(&mp->m_ail_lock, "xfs_ail");
> -	spinlock_init(&mp->m_sb_lock, "xfs_sb");
> +	spin_lock_init(&mp->m_ail_lock);
> +	spin_lock_init(&mp->m_sb_lock);
>  	mutex_init(&mp->m_ilock);
>  	mutex_init(&mp->m_growlock);
>  	/*
> @@ -616,7 +616,7 @@ xfs_mount_common(xfs_mount_t *mp, xfs_sb
>  	int	i;
>  
>  	mp->m_agfrotor = mp->m_agirotor = 0;
> -	spinlock_init(&mp->m_agirotor_lock, "m_agirotor_lock");
> +	spin_lock_init(&mp->m_agirotor_lock);
>  	mp->m_maxagi = mp->m_sb.sb_agcount;
>  	mp->m_blkbit_log = sbp->sb_blocklog + XFS_NBBYLOG;
>  	mp->m_blkbb_log = sbp->sb_blocklog - BBSHIFT;
> Index: linux-2.6-xfs/fs/xfs/xfs_mru_cache.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_mru_cache.c
> +++ linux-2.6-xfs/fs/xfs/xfs_mru_cache.c
> @@ -368,7 +368,7 @@ xfs_mru_cache_create(
>  	 */
>  	INIT_RADIX_TREE(&mru->store, GFP_ATOMIC);
>  	INIT_LIST_HEAD(&mru->reap_list);
> -	spinlock_init(&mru->lock, "xfs_mru_cache");
> +	spin_lock_init(&mru->lock);
>  	INIT_DELAYED_WORK(&mru->work, _xfs_mru_cache_reap);
>  
>  	mru->grp_time  = grp_time;
> Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c
> +++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c
> @@ -68,7 +68,7 @@ xfs_init(void)
>  	extern kmem_zone_t	*xfs_dabuf_zone;
>  #ifdef XFS_DABUF_DEBUG
>  	extern spinlock_t        xfs_dabuf_global_lock;
> -	spinlock_init(&xfs_dabuf_global_lock, "xfsda");
> +	spin_lock_init(&xfs_dabuf_global_lock);
>  #endif
>  
>  	/*
>
>
>   


--------------050308060602040202040303
Content-Type: text/x-vcard; charset=utf-8;
 name="cattelan.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cattelan.vcf"

begin:vcard
fn:Russell Cattelan
n:Cattelan;Russell
email;internet:cattelan@thebarn.com
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------050308060602040202040303--
