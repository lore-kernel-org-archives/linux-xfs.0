Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1KMjq1B206243 for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 16:45:52 -0600
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 811E5198237E
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 14:45:19 -0800 (PST)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org
	[140.211.169.13]) by cuda.sgi.com with ESMTP id
	mfiHpVThN8c8CDNC for <xfs@oss.sgi.com>;
	Fri, 20 Feb 2009 14:45:19 -0800 (PST)
Date: Fri, 20 Feb 2009 14:28:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: next-20090220: XFS, IMA: BUG: sleeping function called from
	invalid  context at mm/slub.c:1613
Message-Id: <20090220142807.a28734a8.akpm@linux-foundation.org>
In-Reply-To: <1235168219.3019.4.camel@localhost.localdomain>
References: <a4423d670902200300n1d1bfdeeg6daca4b32989c9d3@mail.gmail.com>
	<20090220122242.b36a778f.akpm@linux-foundation.org>
	<1235168219.3019.4.camel@localhost.localdomain>
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
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: jmorris@namei.org, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, a.beregalov@gmail.com, xfs@oss.sgi.com

On Fri, 20 Feb 2009 17:16:59 -0500
Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> integrity: ima iint radix_tree_lookup locking fix
> 
> Based on Andrew Morton's comments:
> - add missing locks around radix_tree_lookup in ima_iint_insert()
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> 
> Index: security-testing-2.6/security/integrity/ima/ima_iint.c
> ===================================================================
> --- security-testing-2.6.orig/security/integrity/ima/ima_iint.c
> +++ security-testing-2.6/security/integrity/ima/ima_iint.c
> @@ -73,8 +73,10 @@ out:
>  	if (rc < 0) {
>  		kmem_cache_free(iint_cache, iint);
>  		if (rc == -EEXIST) {
> +			spin_lock(&ima_iint_lock);
>  			iint = radix_tree_lookup(&ima_iint_store,
>  						 (unsigned long)inode);
> +			spin_unlock(&ima_iint_lock);
>  		} else
>  			iint = NULL;
>  	}

Can the -EEXIST ever actually happen?

On the inode_init_always() path (at least), I don't think that any
other thread of control can have access to this inode*, so there is no
way in which a race can result in someone else adding this inode
first?


Also, idle question: why does the radix tree exist at all?  Would it
have been possible to just add a `struct ima_iint_cache *' field to the
inode instead?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
