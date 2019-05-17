Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41968 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728535AbfEQOKv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 May 2019 10:10:51 -0400
Subject: Re: [PATCH 02/20] xfs: stop using XFS_LI_ABORTED as a parameter flag
References: <20190517073119.30178-1-hch@lst.de>
 <20190517073119.30178-3-hch@lst.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c1e91d64-f770-3c17-c70e-d8fe6826752f@sandeen.net>
Date: Fri, 17 May 2019 09:10:49 -0500
MIME-Version: 1.0
In-Reply-To: <20190517073119.30178-3-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On 5/17/19 2:31 AM, Christoph Hellwig wrote:
> Just pass a straight bool aborted instead of abusing XFS_LI_ABORTED as a
> flag in function parameters.

...

>  out_abort:
> -	xlog_cil_committed(ctx, XFS_LI_ABORTED);
> +	xlog_cil_committed(ctx, true);
>  	return -EIO;

Technically fine but I'm kind of on the fence about changes like this;
doesn't it make the code less readable?  Passing a self-documenting
flag makes code reading a lot easier than seeing "true" and having
to cross-reference what the bool means.  What's your thought on how this
helps?  Is it worth keeping things like this more self-documenting?

Thanks,
-Eric

> Signed-off-by: Christoph Hellwig <hch@lst.de>
