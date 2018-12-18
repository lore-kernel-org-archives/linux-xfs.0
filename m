Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40048 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbeLRRQ1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Dec 2018 12:16:27 -0500
Subject: Re: [PATCH 2/6] xfs: fix function pointer type in ftrace format
References: <154344773243.4341.5458822684407979916.stgit@magnolia>
 <154344774484.4341.10423896160201689613.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <44c11ff2-c9e3-9371-22cc-e3b0e5e9a680@sandeen.net>
Date: Tue, 18 Dec 2018 11:16:26 -0600
MIME-Version: 1.0
In-Reply-To: <154344774484.4341.10423896160201689613.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 11/28/18 5:29 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use %pS instead of %pF in ftrace strings so that we record the actual
> function address instead of the function descriptor.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/scrub/trace.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index f1c144c6dcc5..d67e915cf91a 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -473,7 +473,7 @@ TRACE_EVENT(xchk_xref_error,
>  		__entry->error = error;
>  		__entry->ret_ip = ret_ip;
>  	),
> -	TP_printk("dev %d:%d type %u xref error %d ret_ip %pF",
> +	TP_printk("dev %d:%d type %u xref error %d ret_ip %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->type,
>  		  __entry->error,
> 
