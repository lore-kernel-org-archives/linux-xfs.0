Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53626 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757056AbcLOERD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Dec 2016 23:17:03 -0500
Subject: Re: [PATCH 1/1 linux-next] xfs: remove unnecessary return
References: <1481352729-7020-1-git-send-email-fabf@skynet.be>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7ce30624-de82-f682-776c-7b6f1757026d@sandeen.net>
Date: Wed, 14 Dec 2016 22:17:02 -0600
MIME-Version: 1.0
In-Reply-To: <1481352729-7020-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Fabian Frederick <fabf@skynet.be>, Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On 12/10/16 12:52 AM, Fabian Frederick wrote:
> Commit f7a136aee3c1
> ("xfs: several xattr functions can be void")
> 
> updated 2 end of function return 0 to return in void
> functions. Remove it.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Oh, sure.  :)

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> ---
>  fs/xfs/xfs_attr_list.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 97c45b6..5aa46c3 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -433,7 +433,6 @@ xfs_attr3_leaf_list_int(
>  		cursor->offset++;
>  	}
>  	trace_xfs_attr_list_leaf_end(context);
> -	return;
>  }
>  
>  /*
> @@ -543,7 +542,6 @@ xfs_attr_put_listent(
>  	alist->al_offset[context->count++] = context->firstu;
>  	alist->al_count = context->count;
>  	trace_xfs_attr_list_add(context);
> -	return;
>  }
>  
>  /*
> 
