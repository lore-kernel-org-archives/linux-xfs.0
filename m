Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 May 2007 17:42:54 -0700 (PDT)
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4G0gnfB021519
	for <xfs@oss.sgi.com>; Tue, 15 May 2007 17:42:50 -0700
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l4G0gnAC004917
	for <xfs@oss.sgi.com>; Tue, 15 May 2007 20:42:49 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4G0gnkM248582
	for <xfs@oss.sgi.com>; Tue, 15 May 2007 18:42:49 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4G0gmIL017394
	for <xfs@oss.sgi.com>; Tue, 15 May 2007 18:42:49 -0600
Subject: Re: [PATCH 1/5][TAKE3] fallocate() implementation on i86, x86_64
	and powerpc
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
In-Reply-To: <20070515200359.GA5834@amitarora.in.ibm.com>
References: <20070329101010.7a2b8783.akpm@linux-foundation.org>
	 <20070330071417.GI355@devserv.devel.redhat.com>
	 <20070417125514.GA7574@amitarora.in.ibm.com>
	 <20070418130600.GW5967@schatzie.adilger.int>
	 <20070420135146.GA21352@amitarora.in.ibm.com>
	 <20070420145918.GY355@devserv.devel.redhat.com>
	 <20070424121632.GA10136@amitarora.in.ibm.com>
	 <20070426175056.GA25321@amitarora.in.ibm.com>
	 <20070515193722.GA3487@amitarora.in.ibm.com>
	 <20070515195421.GA2948@amitarora.in.ibm.com>
	 <20070515200359.GA5834@amitarora.in.ibm.com>
Content-Type: text/plain
Date: Tue, 15 May 2007 17:42:46 -0700
Message-Id: <1179276167.4819.22.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com

On Wed, 2007-05-16 at 01:33 +0530, Amit K. Arora wrote:
> This patch implements sys_fallocate() and adds support on i386, x86_64
> and powerpc platforms.

> @@ -1137,6 +1148,8 @@ struct inode_operations {
>  	ssize_t (*listxattr) (struct dentry *, char *, size_t);
>  	int (*removexattr) (struct dentry *, const char *);
>  	void (*truncate_range)(struct inode *, loff_t, loff_t);
> +	long (*fallocate)(struct inode *inode, int mode, loff_t offset,
> +			  loff_t len);
>  };

Does the return value from fallocate inode operation has to be *long*?
It's not consistent with the ext4_fallocate() define in patch 4/5, 

+int ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t
len)

thus cause compile warnings.



Mingming
