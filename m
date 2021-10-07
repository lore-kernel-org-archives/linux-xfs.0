Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F84AC433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 16:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 416BF611C3
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 16:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242611AbhJGQVW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Oct 2021 12:21:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242392AbhJGQVV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Oct 2021 12:21:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05F4D61130;
        Thu,  7 Oct 2021 16:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633623568;
        bh=C+X78jnx6oPpOhyPNSDt1k84PcnJj4R9QW0zHoOVY6o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mEy5wb98L7y5xxjnuBHozKJgW/RLIrh2ZqUwV5CJdrMiq4xBu8bVvl3E+gw+wH88/
         sXxbP+5PrMpbhLU/HOthNzJmInoqOdk8QABag0MTg/I9j2TQiuBWkKNYIZsak8t5Ub
         ZZYHYDW338gyC4BJm1JmIn8Ioi3YMiy6fbd2zNZgVi9eV75rfSlwwaIcx6QrYoEps/
         08/O+l2fWFOj8bEPnHGevSl1Ikn2EMGyCKvg+SonhjSMFLIn9BCFzeYaZEWsoK+fEL
         p/QRLkLPO2zQDRwNpwi/ULDy/Bs4qtrX+tDr60IDNVvifjc+jNHKbTmTQk5D0zZq2t
         4IIn+n2NPbsbg==
Date:   Thu, 7 Oct 2021 09:19:27 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH v2 3/4] common/log: Move *_dump_log routines to common/log
Message-ID: <20211007161927.GB24282@magnolia>
References: <20211007002641.714906-1-catherine.hoang@oracle.com>
 <20211007002641.714906-4-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007002641.714906-4-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 07, 2021 at 12:26:40AM +0000, Catherine Hoang wrote:
> Move _scratch_remount_dump_log and _test_remount_dump_log from
> common/inject to common/log. These routines do not inject errors and
> should be placed with other common log functions.

Doesn't this mean that all those tests that got changed in the first
patch will also need an update to source common/log?

OH, right, common/inject sources common/log.  Problem solved.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  common/inject | 26 --------------------------
>  common/log    | 26 ++++++++++++++++++++++++++
>  2 files changed, 26 insertions(+), 26 deletions(-)
> 
> diff --git a/common/inject b/common/inject
> index b5334d4a..6b590804 100644
> --- a/common/inject
> +++ b/common/inject
> @@ -111,29 +111,3 @@ _scratch_inject_error()
>  		_fail "Cannot inject error ${type} value ${value}."
>  	fi
>  }
> -
> -# Unmount and remount the scratch device, dumping the log
> -_scratch_remount_dump_log()
> -{
> -	local opts="$1"
> -
> -	if test -n "$opts"; then
> -		opts="-o $opts"
> -	fi
> -	_scratch_unmount
> -	_scratch_dump_log
> -	_scratch_mount "$opts"
> -}
> -
> -# Unmount and remount the test device, dumping the log
> -_test_remount_dump_log()
> -{
> -	local opts="$1"
> -
> -	if test -n "$opts"; then
> -		opts="-o $opts"
> -	fi
> -	_test_unmount
> -	_test_dump_log
> -	_test_mount "$opts"
> -}
> diff --git a/common/log b/common/log
> index c7921f50..0a9aaa7f 100644
> --- a/common/log
> +++ b/common/log
> @@ -608,5 +608,31 @@ _get_log_configs()
>      esac
>  }
>  
> +# Unmount and remount the scratch device, dumping the log
> +_scratch_remount_dump_log()
> +{
> +	local opts="$1"
> +
> +	if test -n "$opts"; then
> +		opts="-o $opts"
> +	fi
> +	_scratch_unmount
> +	_scratch_dump_log
> +	_scratch_mount "$opts"
> +}
> +
> +# Unmount and remount the test device, dumping the log
> +_test_remount_dump_log()
> +{
> +	local opts="$1"
> +
> +	if test -n "$opts"; then
> +		opts="-o $opts"
> +	fi
> +	_test_unmount
> +	_test_dump_log
> +	_test_mount "$opts"
> +}
> +
>  # make sure this script returns success
>  /bin/true
> -- 
> 2.25.1
> 
