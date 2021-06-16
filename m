Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 531B6C48BE5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 20:58:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 346F9613BD
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 20:58:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233822AbhFPVAa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 17:00:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233809AbhFPVA3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 Jun 2021 17:00:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 149AF6128C;
        Wed, 16 Jun 2021 20:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623877103;
        bh=HOEO2hP+6eKY7LT9OI8u8yiGFwear6ufpswUPGwPsJo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DiRq4mbjKLTIKS9JRvKcCoHScFl10P6PkzF0dikrQp5yhnq4f1bZ3T6NKAAgN1AFh
         qdIMagrVZmw+zB2E0zgIFNLV52ZjpzkYevVy6FA365Nz3OF9KVQodhRwH1QnJsTI6x
         KxDVoKaVJf56AogjvBZEt5zukb3Sx0XxmsyLR/8pTgipOPu1b8sZm/skmnvLNA6dEW
         OkgVHJSg+4beN6VK0W7hx4CPReM9UUAars1xrRaMHIee3dcf0sIdCqx5SZml6dAqjB
         qN/SJGomtu5pwWA7XkwZIMZARhFQfRDoyStcZk9VDF2kbo52ppCJcmm6ybHUSC1dhi
         /4He8WgyM8OZQ==
Date:   Wed, 16 Jun 2021 13:58:21 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com
Subject: Re: [PATCH 12/13] fstests: remove test group management code
Message-ID: <YMpl7YYV6UN6sS87@sol.localdomain>
References: <162370433910.3800603.9623820748404628250.stgit@locust>
 <162370440523.3800603.5113348731405331858.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162370440523.3800603.5113348731405331858.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 14, 2021 at 02:00:05PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Remove all the code that manages group files, since we now generate
> them at build time.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  tools/mvtest     |   12 ------
>  tools/sort-group |  112 ------------------------------------------------------
>  2 files changed, 124 deletions(-)
>  delete mode 100755 tools/sort-group
> 
> 
> diff --git a/tools/mvtest b/tools/mvtest
> index 572ae14e..fa967832 100755
> --- a/tools/mvtest
> +++ b/tools/mvtest
> @@ -32,24 +32,12 @@ did="$(basename "${dest}")"
>  sgroup="$(basename "$(dirname "tests/${src}")")"
>  dgroup="$(basename "$(dirname "tests/${dest}")")"
>  
> -sgroupfile="tests/${sgroup}/group"
> -dgroupfile="tests/${dgroup}/group"

The 'sgroup' and 'dgroup' variables are no longer used and should be removed.

- Eric
