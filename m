Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1B4BC7FA5
	for <xfs@oss.sgi.com>; Fri, 15 Nov 2013 11:47:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 08DEC8F8059
	for <xfs@oss.sgi.com>; Fri, 15 Nov 2013 09:47:48 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 0mREqdIGdosHOQ2Q for <xfs@oss.sgi.com>;
	Fri, 15 Nov 2013 09:47:48 -0800 (PST)
Message-ID: <52865E41.9020209@sandeen.net>
Date: Fri, 15 Nov 2013 11:47:45 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: remove unused FI_ flags
References: <20131115173848.GA24872@infradead.org>
In-Reply-To: <20131115173848.GA24872@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On 11/15/13, 11:38 AM, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Easy one.  ;)

Reviewed-by: Eric Sandeen <sandeen@redhat.com.>

(heh, is that the last reference to "vop?")

> ---
>  fs/xfs/xfs_vnode.h |    9 ---------
>  1 file changed, 9 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_vnode.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_vnode.h	2013-10-11 17:03:21.244338013 +0100
> +++ xfs/fs/xfs/xfs_vnode.h	2013-10-22 07:21:09.236045186 +0100
> @@ -35,15 +35,6 @@ struct attrlist_cursor_kern;
>  	{ IO_INVIS,	"INVIS"}
>  
>  /*
> - * Flush/Invalidate options for vop_toss/flush/flushinval_pages.
> - */
> -#define FI_NONE			0	/* none */
> -#define FI_REMAPF		1	/* Do a remapf prior to the operation */
> -#define FI_REMAPF_LOCKED	2	/* Do a remapf prior to the operation.
> -					   Prevent VM access to the pages until
> -					   the operation completes. */
> -
> -/*
>   * Some useful predicates.
>   */
>  #define VN_MAPPED(vp)	mapping_mapped(vp->i_mapping)
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
