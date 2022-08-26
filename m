Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8DF5C0502A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Aug 2022 22:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345226AbiHZWWW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Aug 2022 18:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345165AbiHZWWA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Aug 2022 18:22:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9184167E4
        for <linux-xfs@vger.kernel.org>; Fri, 26 Aug 2022 15:20:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFD10B832F1
        for <linux-xfs@vger.kernel.org>; Fri, 26 Aug 2022 22:20:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB11C433C1;
        Fri, 26 Aug 2022 22:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661552426;
        bh=3xUtOwm4YkioVHpH13EBpw8/yXSJSQjW8cOC1+cmOYo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L4sVonsHVpH4Bed+TuoPKlJWelhXF0iaquDbpsqxm2o3YXEDL/kV8HWjw8iYhcaJz
         7XaYNTDbr3KBRtp+4Domyd49dTUdQj415a9jdSDwgeOTLFzFTFjX1dmc8nMtmduZvZ
         Fkdn6A9vKLXS43OfvSUNdZazBPPPEf7PfGTANOWRJNtvb2Wz9lGa398+MidbwAjHxJ
         OTPJ+2Jb884OtSZgTYTyVD7zD9YNqf25AWDtmuTMISoTBHysWpSs7g15gpGmFOoWTT
         HE82BhKklgFVOBSDHvCflDHsmU7Gp2p1mH+pz3G6JId92snXVzfSOjW+lNRshmsx/5
         OwWvzeM8KNPmQ==
Date:   Fri, 26 Aug 2022 15:20:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs: collapse xlog_state_set_callback in caller
Message-ID: <YwlHKbdLMOCtOslW@magnolia>
References: <20220809230353.3353059-1-david@fromorbit.com>
 <20220809230353.3353059-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809230353.3353059-7-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 10, 2022 at 09:03:50AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The function is called from a single place, and it isn't just
> setting the iclog state to XLOG_STATE_CALLBACK - it can mark iclogs
> clean, which moves tehm to states after CALLBACK. Hence the function

Nit: s/tehm/them/

> is now badly named, and should just be folded into the caller where
> the iclog completion logic makes a whole lot more sense.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

I had wondered what xlog_state_set_callback thought it was doing until I
looked ahead and saw this.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c | 31 +++++++++++--------------------
>  1 file changed, 11 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index e420591b1a8a..5b7c91a42edf 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2520,25 +2520,6 @@ xlog_get_lowest_lsn(
>  	return lowest_lsn;
>  }
>  
> -static void
> -xlog_state_set_callback(
> -	struct xlog		*log,
> -	struct xlog_in_core	*iclog,
> -	xfs_lsn_t		header_lsn)
> -{
> -	/*
> -	 * If there are no callbacks on this iclog, we can mark it clean
> -	 * immediately and return. Otherwise we need to run the
> -	 * callbacks.
> -	 */
> -	if (list_empty(&iclog->ic_callbacks)) {
> -		xlog_state_clean_iclog(log, iclog);
> -		return;
> -	}
> -	trace_xlog_iclog_callback(iclog, _RET_IP_);
> -	iclog->ic_state = XLOG_STATE_CALLBACK;
> -}
> -
>  /*
>   * Return true if we need to stop processing, false to continue to the next
>   * iclog. The caller will need to run callbacks if the iclog is returned in the
> @@ -2570,7 +2551,17 @@ xlog_state_iodone_process_iclog(
>  		lowest_lsn = xlog_get_lowest_lsn(log);
>  		if (lowest_lsn && XFS_LSN_CMP(lowest_lsn, header_lsn) < 0)
>  			return false;
> -		xlog_state_set_callback(log, iclog, header_lsn);
> +		/*
> +		 * If there are no callbacks on this iclog, we can mark it clean
> +		 * immediately and return. Otherwise we need to run the
> +		 * callbacks.
> +		 */
> +		if (list_empty(&iclog->ic_callbacks)) {
> +			xlog_state_clean_iclog(log, iclog);
> +			return false;
> +		}
> +		trace_xlog_iclog_callback(iclog, _RET_IP_);
> +		iclog->ic_state = XLOG_STATE_CALLBACK;
>  		return false;
>  	default:
>  		/*
> -- 
> 2.36.1
> 
