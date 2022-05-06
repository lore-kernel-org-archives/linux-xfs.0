Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64F59C433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  6 May 2022 16:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443382AbiEFQH7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 May 2022 12:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443384AbiEFQHt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 May 2022 12:07:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603A96D95C;
        Fri,  6 May 2022 09:04:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15AD1B832EB;
        Fri,  6 May 2022 16:04:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A9FC385AA;
        Fri,  6 May 2022 16:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651853043;
        bh=ItN/NKAQBycs8x8pKOyjx+zGBlvvesdrf9msspQsjLM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FynfHUdWPlTrUorsRobYtyaloV/KWX21xqAVCVUIUsjYzMICrn4L3Jb9LheYdwqsz
         YsQuXjn4797Ce8k/zdsCheDUJ7UQWN6Z/w1JGm/DY8AeVgJtUsoS9hTvwXbULHxLKE
         M1VTFbwMyb7AvOkdBRL8g0u+n5V+XnPWFBvp1pwPgHQ9E4mr1m0+pl4qqBCFTfIBpN
         NENIWwYUtyGYdQVsUiOqpLmAS0lcB+MkCnK8RP9McAKVHEx0ISPaZx2nl1JVmoE/B5
         SDxhrkYBWfrL+DwavGH62PYjDU3nnMsHfjgMQChEpNbaC+V659s7bzaIZaRbEn952E
         dlH0jmUqHViwg==
Date:   Fri, 6 May 2022 09:04:02 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] xfs: remove unreachable code
Message-ID: <20220506160402.GO27195@magnolia>
References: <20220506082615.19328-1-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506082615.19328-1-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 06, 2022 at 04:26:15PM +0800, Jiapeng Chong wrote:
> Clean up the following smatch warning:
> 
> fs/xfs/xfs_icache.c:1768 xfs_icwalk() warn: ignoring unreachable code.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  fs/xfs/xfs_icache.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 5269354b1b69..5af272c20934 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1765,7 +1765,6 @@ xfs_icwalk(
>  		}
>  	}
>  	return last_error;
> -	BUILD_BUG_ON(XFS_ICWALK_PRIVATE_FLAGS & XFS_ICWALK_FLAGS_VALID);

<cough> Do you know what you're removing?

--D

>  }
>  
>  #ifdef DEBUG
> -- 
> 2.20.1.7.g153144c
> 
