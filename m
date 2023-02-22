Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BC04C61DA4
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Feb 2023 08:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbjBVIk0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Feb 2023 03:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbjBVIkZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Feb 2023 03:40:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA4A1E5CA
        for <linux-xfs@vger.kernel.org>; Wed, 22 Feb 2023 00:40:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2AA5B811C6
        for <linux-xfs@vger.kernel.org>; Wed, 22 Feb 2023 08:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971F6C433D2;
        Wed, 22 Feb 2023 08:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677055222;
        bh=voarg6xHIO7G/XLIhyZGDcsY0i6NVuRFTLaplPylQho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u/7w0pmhIeVtcPDPpOrktOyLwi4EYzckt2wpmmxhMA4+b4XK3zyz5qt9N3ASKqAGN
         oOhHaUEJDmw9/rH/tnp6kd+hiZim51k8F6QGGBUL3p3W+pMsnVooae27lyI1aNLF2w
         DHQeK9AtVFFIWSiZwCHpt12H6u78bpIiHokay0tI5RNIRLr/yiXygRTlV59p7Yuf1N
         3d6dRdZHDHTvoiSoogSlZ9Q6n3kck9vsP+5/Z9Sx/yu7gj6nL55/qC7X2iZHNX7rnV
         yYoaZS5lWrWuTlglFQwzyTuAgxgfNN31jp51mFPBrhwM1dlNSU2ZcnE6RhHsVyAfe/
         tXNd7z+nVefYg==
Date:   Wed, 22 Feb 2023 09:40:18 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, daan.j.demeyer@gmail.com
Subject: Re: [PATCH 1/5] xfs_spaceman: fix broken -g behavior in freesp
 command
Message-ID: <20230222084018.spanredntrvnkiry@andromeda>
References: <167658436759.3590000.3700844510708970684.stgit@magnolia>
 <a9_9YJCnku0RDwljZAHh1pvP7v6UmD-qHPJQQEboTu4mSLQkHgl6t82X0rPKpx2MCrpm9TPKgVoB_rBJpZabZg==@protonmail.internalid>
 <167658437328.3590000.18137446679798085024.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167658437328.3590000.18137446679798085024.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 16, 2023 at 01:52:53PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Don't zero out the histogram bucket count when turning on group summary
> mode -- this will screw up the data structures and it's pointless.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  spaceman/freesp.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> 
> diff --git a/spaceman/freesp.c b/spaceman/freesp.c
> index 423568a4248..70dcdb5c923 100644
> --- a/spaceman/freesp.c
> +++ b/spaceman/freesp.c
> @@ -284,7 +284,6 @@ init(
>  			speced = 1;
>  			break;
>  		case 'g':
> -			histcount = 0;
>  			gflag++;
>  			break;
>  		case 'h':
> 

-- 
Carlos Maiolino
