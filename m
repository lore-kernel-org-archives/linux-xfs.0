Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 May 2007 05:31:39 -0700 (PDT)
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4GCVWfB031927
	for <xfs@oss.sgi.com>; Wed, 16 May 2007 05:31:34 -0700
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l4GCRqMn032279
	for <xfs@oss.sgi.com>; Wed, 16 May 2007 08:27:52 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4GCVSD5155834
	for <xfs@oss.sgi.com>; Wed, 16 May 2007 06:31:28 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4GCVR9a011576
	for <xfs@oss.sgi.com>; Wed, 16 May 2007 06:31:28 -0600
Date: Wed, 16 May 2007 18:01:24 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/5][TAKE3] fallocate() implementation on i86, x86_64 and powerpc
Message-ID: <20070516123124.GA24299@amitarora.in.ibm.com>
References: <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070515193722.GA3487@amitarora.in.ibm.com> <20070515195421.GA2948@amitarora.in.ibm.com> <20070515200359.GA5834@amitarora.in.ibm.com> <1179276167.4819.22.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179276167.4819.22.camel@dyn9047017103.beaverton.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mingming Cao <cmm@us.ibm.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com

On Tue, May 15, 2007 at 05:42:46PM -0700, Mingming Cao wrote:
> On Wed, 2007-05-16 at 01:33 +0530, Amit K. Arora wrote:
> > This patch implements sys_fallocate() and adds support on i386, x86_64
> > and powerpc platforms.
> 
> > @@ -1137,6 +1148,8 @@ struct inode_operations {
> >  	ssize_t (*listxattr) (struct dentry *, char *, size_t);
> >  	int (*removexattr) (struct dentry *, const char *);
> >  	void (*truncate_range)(struct inode *, loff_t, loff_t);
> > +	long (*fallocate)(struct inode *inode, int mode, loff_t offset,
> > +			  loff_t len);
> >  };
> 
> Does the return value from fallocate inode operation has to be *long*?
> It's not consistent with the ext4_fallocate() define in patch 4/5, 

I think ->fallocate() should return a "long", since sys_fallocate() has
to return what ->fallocate() returns and hence their return type should
ideally match.
 
> +int ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t
> len)

I will change the ext4_fallocate() to return a "long" (in patch 4/5)
in the next post.

Agree ?

Thanks!
--
Regards,
Amit Arora

> 
> thus cause compile warnings.
> 
> 
> 
> Mingming
