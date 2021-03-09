Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4886C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 17:15:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 978F96522A
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 17:15:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbhCIROh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 12:14:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:58084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230435AbhCIROU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Mar 2021 12:14:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE89364FCF;
        Tue,  9 Mar 2021 17:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615310060;
        bh=N0pPMrK8HZHwb5BJj+qk6BSsG+2O9CU/YqlNYMGEKpA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ltR5t/nzKKHa7wFgh79pYyxcdr4JFqOtSJov/34oYjORS85fG70G3BOGF6BK9mxMf
         OUShmHdNwV7ogUhnaO1fNVN6HWvdmg1HkcSrBrU5Uk3qepbFdgcFseS0D7DuFHTAcc
         yKB7iUJtzeWl6YGTa78vdjLN01T15J2R42duEKQN+fUWW4VxXYIZel0x7IMv2dvJ9m
         Vpju6behX8JWpdw3UVIotX4GaV2Ub7GVcGeupaDRrrVXC+vIlUkPqZLlKahx1ge9mF
         2E5oFOQf9xkUx7E+WDnwfXJImRqjX8jaVjZ/8No8oVIpGvlxI8yrnJ8yhqbFihUo7w
         r5LeR4SmToteQ==
Date:   Tue, 9 Mar 2021 09:14:19 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@infradead.org
Subject: Re: [PATCH] docs: ABI: Fix the spelling oustanding to outstanding in
 the file sysfs-fs-xfs
Message-ID: <20210309171419.GU3419940@magnolia>
References: <20210213152436.1639458-1-unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210213152436.1639458-1-unixbhaskar@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Feb 13, 2021 at 08:54:36PM +0530, Bhaskar Chowdhury wrote:
> 
> s/oustanding/outstanding/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  Documentation/ABI/testing/sysfs-fs-xfs | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-fs-xfs b/Documentation/ABI/testing/sysfs-fs-xfs
> index ea0cc8c42093..f704925f6fe9 100644
> --- a/Documentation/ABI/testing/sysfs-fs-xfs
> +++ b/Documentation/ABI/testing/sysfs-fs-xfs
> @@ -33,7 +33,7 @@ Contact:	xfs@oss.sgi.com
>  Description:
>  		The current state of the log write grant head. It
>  		represents the total log reservation of all currently
> -		oustanding transactions, including regrants due to
> +		outstanding transactions, including regrants due to
>  		rolling transactions. The grant head is exported in
>  		"cycle:bytes" format.
>  Users:		xfstests
> --
> 2.30.1
> 
