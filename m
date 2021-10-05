Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65606C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Oct 2021 22:36:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AF9160EE9
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Oct 2021 22:36:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236818AbhJEWip (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Oct 2021 18:38:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236799AbhJEWip (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Oct 2021 18:38:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEF0160EE3;
        Tue,  5 Oct 2021 22:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633473413;
        bh=Uz1oMWOcbIfaWknO1ovXdQahp6B36XtdQjmruHtr8zI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n+NgA7B0aFCvdQ/nEpb2OoQmBi0YF7Gs3fNH0YoFSagg1qO7jBnzECG4E+jQtSDOI
         zNatjr+G3hyHk0CmCgqnoIfsmBvSgoWk1uqvgH7p9kCYV3SWTKdZI9yQeIgZDX5SsX
         n+WJpZZeKGCo6vOMVynHnnQcmps5CH+cW+KTG4BX2I3Z8Gc0nsvc/B1ITuCzY0wo0L
         7p9DTHsGpPDBaqA+GUK8T+znop61ki4RxzKWjberaOcrGf8scB5GdB3476BoqRqwql
         R6dN8swc/zCbAF9dU38YtLpmnUdwqYnwbcn8SshNpT3tIjdVDaa6HCg74o+k7waCzT
         YCJAq3/TRexbg==
Date:   Tue, 5 Oct 2021 15:36:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] Prevent mmap command to map beyond EOF
Message-ID: <20211005223653.GG24307@magnolia>
References: <20211004141140.53607-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004141140.53607-1-cmaiolino@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 04, 2021 at 04:11:40PM +0200, Carlos Maiolino wrote:
> Attempting to access a mmapp'ed region that does not correspond to the
> file results in a SIGBUS, so prevent xfs_io to even attempt to mmap() a
> region beyond EOF.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> 
> There is a caveat about this patch though. It is possible to mmap() a
> non-existent file region, extent the file to go beyond such region, and run
> operations in this mmapped region without such operations triggering a SIGBUS
> (excluding the file corruption factor here :). So, I'm not quite sure if it
> would be ok to check for this in mmap_f() as this patch does, or create a helper
> to check for such condition, and use it on the other operations (mread_f,
> mwrite_f, etc). What you folks think?

What's the motivation for checking this in userspace?  Programs are
allowed to set up this (admittedly minimally functional) configuration,
or even set it up after the mmap by truncating the file.

OTOH if your goal is to write a test to check the SIGBUS functionality,
you could install a sigbus handler to report the signal to stderr, which
would avoid bash writing junk about the sigbus to the terminal.

--D

> 
>  io/mmap.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/io/mmap.c b/io/mmap.c
> index 9816cf68..77c5f2b6 100644
> --- a/io/mmap.c
> +++ b/io/mmap.c
> @@ -242,6 +242,13 @@ mmap_f(
>  		return 0;
>  	}
>  
> +	/* Check if we are mmapping beyond EOF */
> +	if ((offset + length) > filesize()) {
> +		printf(_("Attempting to mmap() beyond EOF\n"));
> +		exitcode = 1;
> +		return 0;
> +	}
> +
>  	/*
>  	 * mmap and munmap memory area of length2 region is helpful to
>  	 * make a region of extendible free memory. It's generally used
> -- 
> 2.31.1
> 
