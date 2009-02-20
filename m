Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1KMQu8M205181 for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 16:26:57 -0600
Received: from e39.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D246F196B584
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 14:26:24 -0800 (PST)
Received: from e39.co.us.ibm.com (e39.co.us.ibm.com [32.97.110.160]) by
	cuda.sgi.com with ESMTP id MbXsI2JE6kcfei5L for
	<xfs@oss.sgi.com>; Fri, 20 Feb 2009 14:26:24 -0800 (PST)
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com
	[9.17.195.106])
	by e39.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n1KMEXYj009497
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 15:14:33 -0700
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id
	n1KMH1YF165974 for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 15:17:01 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id
	n1KMH1tc010821 for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 15:17:01 -0700
Subject: Re: next-20090220: XFS, IMA: BUG: sleeping function called from
	invalid  context at mm/slub.c:1613
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
In-Reply-To: <20090220122242.b36a778f.akpm@linux-foundation.org>
References: <a4423d670902200300n1d1bfdeeg6daca4b32989c9d3@mail.gmail.com>
	<20090220122242.b36a778f.akpm@linux-foundation.org>
Date: Fri, 20 Feb 2009 17:16:59 -0500
Message-Id: <1235168219.3019.4.camel@localhost.localdomain>
Mime-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Morris <jmorris@namei.org>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Alexander Beregalov <a.beregalov@gmail.com>, xfs@oss.sgi.com

On Fri, 2009-02-20 at 12:22 -0800, Andrew Morton wrote: 
> On Fri, 20 Feb 2009 14:00:21 +0300
> Alexander Beregalov <a.beregalov@gmail.com> wrote:
> 
> > Hi
> > 
> > I have applied the following patch from Mimi Zohar
> > http://marc.info/?l=linux-next&m=123509665514552
> > 
> > That is why it is dirty.
> > The kernel can not boot without it when IMA is enabled.

With CONFIG_DEBUG_SG and IMA defined, it couldn't boot.

> > BUG: sleeping function called from invalid context at mm/slub.c:1613
> > in_atomic(): 1, irqs_disabled(): 0, pid: 1514, name: mkdir
> > 3 locks held by mkdir/1514:
> >  #0:  (&type->i_mutex_dir_key#2/1){+.+.+.}, at: [<ffffffff802d3460>]
> > lookup_create+0x30/0xd0
> >  #1:  (&(&ip->i_lock)->mr_lock/1){+.+.+.}, at: [<ffffffff803ca77f>]
> > xfs_ilock+0xdf/0x120
> >  #2:  (&pag->pag_ici_lock){++++.+}, at: [<ffffffff803caed6>]
> > xfs_iget+0x156/0x650
> > Pid: 1514, comm: mkdir Not tainted 2.6.29-rc5-next-20090220-dirty #1
> > Call Trace:
> >  [<ffffffff8026ad33>] ? __debug_show_held_locks+0x13/0x30
> >  [<ffffffff80234fe5>] __might_sleep+0x105/0x140
> >  [<ffffffff802c6191>] kmem_cache_alloc+0xd1/0x100
> >  [<ffffffff8045fb29>] ima_iint_insert+0x49/0xf0
> >  [<ffffffff8045fbed>] ima_inode_alloc+0x1d/0x30
> >  [<ffffffff802dfa5f>] inode_init_always+0xaf/0x250
> >  [<ffffffff803caf86>] xfs_iget+0x206/0x650
> >  [<ffffffff803eb8e8>] xfs_trans_iget+0x208/0x250
> >  [<ffffffff803ce571>] xfs_ialloc+0xc1/0x700
> >  [<ffffffff803ec6f9>] xfs_dir_ialloc+0xa9/0x340
> >  [<ffffffff8025e009>] ? down_write_nested+0x79/0x90
> >  [<ffffffff803ef0c1>] xfs_create+0x3e1/0x690
> >  [<ffffffff803fb813>] xfs_vn_mknod+0x63/0xf0
> >  [<ffffffff803fb8ae>] xfs_vn_mkdir+0xe/0x10
> >  [<ffffffff802d487c>] vfs_mkdir+0x8c/0xd0
> >  [<ffffffff802d6a56>] sys_mkdirat+0x106/0x120
> >  [<ffffffff8020bc0c>] ? sysret_check+0x27/0x62
> >  [<ffffffff8026c79d>] ? trace_hardirqs_on_caller+0x17d/0x1e0
> >  [<ffffffff802d6a83>] sys_mkdir+0x13/0x20
> >  [<ffffffff8020bbdb>] system_call_fastpath+0x16/0x1b
> > BUG: sleeping function called from invalid context at mm/slub.c:1613
> 
> Please do not be tempted to switch ima_iint_insert() to use GFP_ATOMIC
> to "fix" this.
> 
> Arguably, ima_iint_insert() should requite that the caller pass in the
> gfp_t rather than assuming that GFP_KERNEL can be used.  But that is
> not a suitable fix for this bug.
> 
> We may need to make that change to ima_iint_insert() anyway, as there's
> a good chance that callers will require GFP_NOFS.
> 
> 
> But to fix this bug, xfs needs to stop calling inode_init_always()
> under read_lock().  Because inode_alloc_security() also can sleep (see
> new_inode_smack()).
> 
> Also, ima_iint_insert() does a radix_tree_lookup() without holding
> ima_iint_lock, which appears to be a bug.

Thank you. For now, here's a patch to add locking around the
radix_tree_lookup(). I'll look into passing gfp_t.

Mimi

integrity: ima iint radix_tree_lookup locking fix

Based on Andrew Morton's comments:
- add missing locks around radix_tree_lookup in ima_iint_insert()

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

Index: security-testing-2.6/security/integrity/ima/ima_iint.c
===================================================================
--- security-testing-2.6.orig/security/integrity/ima/ima_iint.c
+++ security-testing-2.6/security/integrity/ima/ima_iint.c
@@ -73,8 +73,10 @@ out:
 	if (rc < 0) {
 		kmem_cache_free(iint_cache, iint);
 		if (rc == -EEXIST) {
+			spin_lock(&ima_iint_lock);
 			iint = radix_tree_lookup(&ima_iint_store,
 						 (unsigned long)inode);
+			spin_unlock(&ima_iint_lock);
 		} else
 			iint = NULL;
 	}




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
