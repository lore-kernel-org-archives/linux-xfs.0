Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q22AV5Zf039617 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 04:31:05 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	lREHw9HuXrJphaN7 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 02 Mar 2012 02:31:04 -0800 (PST)
Date: Fri, 2 Mar 2012 05:31:02 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/8] xfs: handle kmalloc failure when reading attrs
Message-ID: <20120302103102.GA12499@infradead.org>
References: <1330661507-1121-1-git-send-email-david@fromorbit.com>
	<1330661507-1121-4-git-send-email-david@fromorbit.com>
	<20120302074920.GE4117@infradead.org>
	<20120302094938.GH5091@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120302094938.GH5091@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Mar 02, 2012 at 08:49:38PM +1100, Dave Chinner wrote:
> That only handles vmalloced memory, but kmem_free()
> handles both kmalloc() and vmalloc() memory:
> 
> void
> kmem_free(const void *ptr)
> {
>         if (!is_vmalloc_addr(ptr)) {
>                 kfree(ptr);
>         } else {
>                 vfree(ptr);
>         }
> }
> 
> Avoiding having to open code this vmalloc check is exactly why I
> chose kmem_free() here ;)

Oh - this should have been removed when I changed kmem_alloc to not use
vmalloc anymore.  I'd really prefer to have this kind of check in the
callers as it should be the exception, not the rule.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
