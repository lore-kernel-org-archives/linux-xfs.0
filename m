Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84243E92723
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Oct 2023 15:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237922AbjJEP6E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Oct 2023 11:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235157AbjJEP4y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2023 11:56:54 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37954EED
        for <linux-xfs@vger.kernel.org>; Thu,  5 Oct 2023 06:52:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0477CC32799;
        Thu,  5 Oct 2023 12:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696509390;
        bh=tigQk63FHSxjNDqOYTFJALPqqp9soxshwq4zk1+32Kw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i1wjqcNUxLY49lxH+JTq3jRbqJZSxwJXWPaH+ivBj1PewYlKvctzxZgxX69fOSBcr
         lBwr7lzVuLYd8z0TTJadzkyBoIknpM5XtjL30gM8Zi7LUVn0TGsGkT1AELUGWgDdEo
         +aodZe3KvHAuqBzxjRamwttUM+Iu8FiObZO0uVpgK8V5HA4sVqkExRqMDoOFvDpFOR
         g/CMOClU4aP2r3dJF9Jf7YvSKW1Ck6JZ1YKZq2mPfuPqdlGAyBxtCTmehpOWDvdKBe
         LJnhqv0T0PARNVxVEnm6NDq/S0aw45K/tTlLv2LS+wfzulbB+rAFlH70FWcuqDOvG1
         +jWUT+WnZwbpQ==
Date:   Thu, 5 Oct 2023 14:36:26 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs_scrub: actually return errno from
 check_xattr_ns_names
Message-ID: <20231005123626.nko5a6yqbitwqhhb@andromeda>
References: <169454757570.3539425.3597048437340386509.stgit@frogsfrogsfrogs>
 <ihCtIfcTz4P2cRz_1GFts_rxAyipXLKDnZzKubjmFdPDet1gxhD0ohWByOtKiWFH7z4iKXvUbymCMgvbQSGRrg==@protonmail.internalid>
 <169454759865.3539425.15276862523138913713.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169454759865.3539425.15276862523138913713.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 12, 2023 at 12:39:58PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Actually return the error code when extended attribute checks fail.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Carlos

> ---
>  scrub/phase5.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> 
> diff --git a/scrub/phase5.c b/scrub/phase5.c
> index 1ef234bff68..31405709657 100644
> --- a/scrub/phase5.c
> +++ b/scrub/phase5.c
> @@ -202,6 +202,7 @@ check_xattr_ns_names(
>  	if (error) {
>  		if (errno == ESTALE)
>  			errno = 0;
> +		error = errno;
>  		if (errno)
>  			str_errno(ctx, descr_render(dsc));
>  	}
> 
