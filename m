Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB80BC433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Nov 2022 16:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiKUQya (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Nov 2022 11:54:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiKUQy0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Nov 2022 11:54:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86229C7593;
        Mon, 21 Nov 2022 08:54:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1793CB810EE;
        Mon, 21 Nov 2022 16:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BD1C433C1;
        Mon, 21 Nov 2022 16:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669049662;
        bh=boX5N172gUqh0RSbEPCv7zPygyhpDMy9Jjtflg1HXCU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q/OOJ3f4/pqKeoyKzSaKr5AkPC9wT2/QEkwS8Xl2s4E49DVHjn91yPWR9IoNEpsd3
         rOeSYPLrfj+RZmnV1UEFnip1Av9fLU568SDKzEItZ4gK5bwtYLhlZPYWLzeqGkY5HV
         56+wr03Q8ylNGHMtiqNvntWzLQ/kS4A2JXNJIHpurwCVnieOhC/xrZoAAm2NKMwDgG
         eBQ1r4kW8le6ySt+XKydcmwRz6I9eoyOy9cMc1fhekywEaGWZqXQYxKwoUQy2QYAJl
         5F9CuAHejnKjlLdNzFJP3hXBBPRU4yba1cFfJlHxuEX0LSsRpxMaAay4CLf2FF4KgG
         Cdhre/X2nh36A==
Date:   Mon, 21 Nov 2022 08:54:22 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-doc@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] Documentation: admin-guide: correct "it's" to possessive
 "its"
Message-ID: <Y3utPgX/SjiaWARs@magnolia>
References: <20221118232317.3244-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118232317.3244-1-rdunlap@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 18, 2022 at 03:23:17PM -0800, Randy Dunlap wrote:
> Correct 2 uses of "it's" to the possessive "its" as needed.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Darrick J. Wong <djwong@kernel.org>
> Cc: linux-xfs@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> ---
>  Documentation/admin-guide/mm/numa_memory_policy.rst |    2 +-
>  Documentation/admin-guide/xfs.rst                   |    2 +-

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff -- a/Documentation/admin-guide/mm/numa_memory_policy.rst b/Documentation/admin-guide/mm/numa_memory_policy.rst
> --- a/Documentation/admin-guide/mm/numa_memory_policy.rst
> +++ b/Documentation/admin-guide/mm/numa_memory_policy.rst
> @@ -111,7 +111,7 @@ VMA Policy
>  	* A task may install a new VMA policy on a sub-range of a
>  	  previously mmap()ed region.  When this happens, Linux splits
>  	  the existing virtual memory area into 2 or 3 VMAs, each with
> -	  it's own policy.
> +	  its own policy.
>  
>  	* By default, VMA policy applies only to pages allocated after
>  	  the policy is installed.  Any pages already faulted into the
> diff -- a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
> --- a/Documentation/admin-guide/xfs.rst
> +++ b/Documentation/admin-guide/xfs.rst
> @@ -192,7 +192,7 @@ When mounting an XFS filesystem, the fol
>  	are any integer multiple of a valid ``sunit`` value.
>  
>  	Typically the only time these mount options are necessary if
> -	after an underlying RAID device has had it's geometry
> +	after an underlying RAID device has had its geometry
>  	modified, such as adding a new disk to a RAID5 lun and
>  	reshaping it.
>  
