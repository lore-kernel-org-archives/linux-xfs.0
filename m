Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34958 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751090AbdFTUUd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Jun 2017 16:20:33 -0400
Subject: Re: [PATCH 2/2] xfs: remove a whitespace-only line from
 xfs_fs_get_nextdqblk
References: <20170620090244.30876-1-hch@lst.de>
 <20170620090244.30876-3-hch@lst.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <09558ebc-f0bd-85f2-1767-a9ac1b7cf0e6@sandeen.net>
Date: Tue, 20 Jun 2017 15:20:32 -0500
MIME-Version: 1.0
In-Reply-To: <20170620090244.30876-3-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Cc: agruenba@redhat.com

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

On 6/20/17 4:02 AM, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_quotaops.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index f82d79a8c694..de9493253edf 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
> @@ -269,7 +269,6 @@ xfs_fs_get_nextdqblk(
>  	/* ID may be different, so convert back what we got */
>  	*qid = make_kqid(current_user_ns(), qid->type, id);
>  	return 0;
> -	
>  }
>  
>  STATIC int
> 
