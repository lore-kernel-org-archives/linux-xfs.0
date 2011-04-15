Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3FHiZxK082013 for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 12:44:36 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6E55F14D8AF4
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 10:47:58 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id 13FtEuJ4AEjVL6Fu for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2011 10:47:58 -0700 (PDT)
Message-ID: <4DA884C3.9050207@oracle.com>
Date: Fri, 15 Apr 2011 10:47:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
Subject: Re: xfs build warning
References: <4DA876C2.8050606@oracle.com>
	<20110415173902.GA27378@infradead.org>
In-Reply-To: <20110415173902.GA27378@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 04/15/11 10:39, Christoph Hellwig wrote:
> On Fri, Apr 15, 2011 at 09:48:02AM -0700, Randy Dunlap wrote:
>> on i386, when CONFIG_LBDAF is not enabled:
>>
>> fs/xfs/linux-2.6/./xfs_trace.h:1354: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t'
> 
> This should fix it:
> 
> Index: linux-2.6/fs/xfs/linux-2.6/xfs_trace.h
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_trace.h	2011-04-15 19:29:11.569340965 +0200
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_trace.h	2011-04-15 19:30:09.679026159 +0200
> @@ -1418,7 +1418,7 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
>  		  __entry->wasfromfl,
>  		  __entry->isfl,
>  		  __entry->userdata,
> -		  __entry->firstblock)
> +		  (unsigned long long)__entry->firstblock)
>  )
>  
>  #define DEFINE_ALLOC_EVENT(name) \

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

-- 
~Randy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
