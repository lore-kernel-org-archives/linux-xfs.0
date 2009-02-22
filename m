Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1M1oH7N019863 for <xfs@oss.sgi.com>; Sat, 21 Feb 2009 19:50:20 -0600
Received: from e34.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 911741954570
	for <xfs@oss.sgi.com>; Sat, 21 Feb 2009 17:49:42 -0800 (PST)
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152]) by
	cuda.sgi.com with ESMTP id nVudpoCUTmn2Qvk2 for
	<xfs@oss.sgi.com>; Sat, 21 Feb 2009 17:49:42 -0800 (PST)
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by e34.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n1M1lw1Q005553
	for <xfs@oss.sgi.com>; Sat, 21 Feb 2009 18:47:58 -0700
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id
	n1M1ndBu199388 for <xfs@oss.sgi.com>; Sat, 21 Feb 2009 18:49:41 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id
	n1M1nc6J003866 for <xfs@oss.sgi.com>; Sat, 21 Feb 2009 18:49:39 -0700
Subject: Re: next-20090220: XFS, IMA: BUG: sleeping function called from
	invalid  context at mm/slub.c:1613
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
In-Reply-To: <20090220142807.a28734a8.akpm@linux-foundation.org>
References: <a4423d670902200300n1d1bfdeeg6daca4b32989c9d3@mail.gmail.com>
	<20090220122242.b36a778f.akpm@linux-foundation.org>
	<1235168219.3019.4.camel@localhost.localdomain>
	<20090220142807.a28734a8.akpm@linux-foundation.org>
Date: Sat, 21 Feb 2009 20:49:37 -0500
Message-Id: <1235267377.3441.24.camel@localhost.localdomain>
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
Cc: david safford <safford@watson.ibm.com>, jmorris@namei.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, xfs@oss.sgi.com, a.beregalov@gmail.com

On Fri, 2009-02-20 at 14:28 -0800, Andrew Morton wrote: 
> On Fri, 20 Feb 2009 17:16:59 -0500
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > integrity: ima iint radix_tree_lookup locking fix
> > 
> > Based on Andrew Morton's comments:
> > - add missing locks around radix_tree_lookup in ima_iint_insert()
> > 
> > Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> > 
> > Index: security-testing-2.6/security/integrity/ima/ima_iint.c
> > ===================================================================
> > --- security-testing-2.6.orig/security/integrity/ima/ima_iint.c
> > +++ security-testing-2.6/security/integrity/ima/ima_iint.c
> > @@ -73,8 +73,10 @@ out:
> >  	if (rc < 0) {
> >  		kmem_cache_free(iint_cache, iint);
> >  		if (rc == -EEXIST) {
> > +			spin_lock(&ima_iint_lock);
> >  			iint = radix_tree_lookup(&ima_iint_store,
> >  						 (unsigned long)inode);
> > +			spin_unlock(&ima_iint_lock);
> >  		} else
> >  			iint = NULL;
> >  	}
> 
> Can the -EEXIST ever actually happen?

> On the inode_init_always() path (at least), I don't think that any
> other thread of control can have access to this inode*, so there is no
> way in which a race can result in someone else adding this inode
> first?

True, but for those inodes which were allocated before IMA was enabled
and are being allocated in ima_iint_find_insert_get(), it could be an
issue.

> Also, idle question: why does the radix tree exist at all?  Would it
> have been possible to just add a `struct ima_iint_cache *' field to the
> inode instead?

Up until November the iint was defined directly in the inode. This
changed based on Christoph Hellwig's posting
http://lkml.org/lkml/2008/10/14/170 where he said, "bloating the inode
for this is not an option".

Mimi Zohar

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
