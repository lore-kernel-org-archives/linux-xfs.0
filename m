Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65D5AC433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 16:19:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D2B561260
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 16:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235232AbhJGQVs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Oct 2021 12:21:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242631AbhJGQVs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Oct 2021 12:21:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FE7E61245;
        Thu,  7 Oct 2021 16:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633623594;
        bh=fcOnkhdGtLKq3fftBiwGYepPcojmgCImX9jlDEv5Aqs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sf1DmAGIyzgHCt3YeU24zhjQSVsITYsQdvqBYJ0iA/n8azIDJxGOslrFKjDmT/aAm
         7ZF8ubRq1Lzj4UknIL3J04KZQtG9wLKWgTjEjSQXRt7Mx0Byje2SSS08nR9c6za00z
         bHSPar2FYinNiwca3mMAutwiRqzxJVprIfyjvdGLCbJlNB/2PAeTTsxSrrzKQ6ZH7u
         jIvPrQtcfiAKiJvZ0H8Ob5uu75xMd3QJ0kPcZejDyUVxqxPDfiYpCQvRbx60FQJmoD
         YrZxrnCNtAOkzs64Jnnl5+gufbORItWim6k01oQI2tV8Vi8kSXjA83c4PSg8bGOSmp
         1GlBsIzNY5X2w==
Date:   Thu, 7 Oct 2021 09:19:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH v2 2/4] xfstests: Rename _test_inject_logprint to
 _test_remount_dump_log
Message-ID: <20211007161953.GC24282@magnolia>
References: <20211007002641.714906-1-catherine.hoang@oracle.com>
 <20211007002641.714906-3-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007002641.714906-3-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 07, 2021 at 12:26:39AM +0000, Catherine Hoang wrote:
> Rename _test_inject_logprint to _test_remount_dump_log to better
> describe what this function does. _test_remount_dump_log unmounts
> and remounts the test device, dumping the log.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  common/inject | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/common/inject b/common/inject
> index 3b731df7..b5334d4a 100644
> --- a/common/inject
> +++ b/common/inject
> @@ -126,7 +126,7 @@ _scratch_remount_dump_log()
>  }
>  
>  # Unmount and remount the test device, dumping the log
> -_test_inject_logprint()
> +_test_remount_dump_log()
>  {
>  	local opts="$1"
>  
> -- 
> 2.25.1
> 
