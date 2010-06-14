Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5ECjps8041127 for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 07:45:52 -0500
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AF88B14A180D
	for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 05:51:54 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com
	with ESMTP id qwO3VunGEXkXCFGM for <xfs@oss.sgi.com>;
	Mon, 14 Jun 2010 05:51:54 -0700 (PDT)
Date: Mon, 14 Jun 2010 14:48:04 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] XFS: Fix gcc 4.6 set but not read and unused statement
	warnings v2
Message-ID: <20100614124804.GA8547@lst.de>
References: <20100614081356.GA27499@basil.fritz.box>
	<20100614083021.GA29354@lst.de> <4C15EF75.5080909@linux.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C15EF75.5080909@linux.intel.com>
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
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@lst.de>, dgc@fromorbit.com, xfs@oss.sgi.com

On Mon, Jun 14, 2010 at 10:59:33AM +0200, Andi Kleen wrote:
> >How can this work?  bp->data is a void pointer.
> 
> It compiled with CONFIG_XFS_DEBUG enabled. Do I need to set some other
> option to test this?

It fails for me in a normal CONFIG_XFS_DEBUG build:

fs/xfs/xfs_da_btree.c: In function 'xfs_da_root_join':
fs/xfs/xfs_da_btree.c:737: warning: dereferencing 'void *' pointer
fs/xfs/xfs_da_btree.c:737: error: request for member 'magic' in
something not a structure or union
fs/xfs/xfs_da_btree.c:737: warning: dereferencing 'void *' pointer

...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
