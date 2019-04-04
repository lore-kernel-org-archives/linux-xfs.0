Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55306 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728699AbfDDSGZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Apr 2019 14:06:25 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 95F833084212
        for <linux-xfs@vger.kernel.org>; Thu,  4 Apr 2019 18:06:25 +0000 (UTC)
Date: Thu, 4 Apr 2019 13:06:21 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH] scrub: fix typo in unicrash header file
Message-ID: <20190404180621.GA7627@redhat.com>
References: <9e34ab3e-b9ed-6c4c-ce69-97f0f78b9503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e34ab3e-b9ed-6c4c-ce69-97f0f78b9503@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Apr 04, 2019 at 12:24:40PM -0500, Eric Sandeen wrote:
> The no-op #definintion was missing 'fs_' so remained undefined
> in the #else case.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Looks good.
Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> 
> diff --git a/scrub/unicrash.h b/scrub/unicrash.h
> index 85fcabc..fb8f5f7 100644
> --- a/scrub/unicrash.h
> +++ b/scrub/unicrash.h
> @@ -28,7 +28,7 @@ bool unicrash_check_fs_label(struct unicrash *uc, const char *descr,
>  #else
>  # define unicrash_dir_init(u, c, b)		(true)
>  # define unicrash_xattr_init(u, c, b)		(true)
> -# define unicrash_label_init(u, c)		(true)
> +# define unicrash_fs_label_init(u, c)		(true)
>  # define unicrash_free(u)			do {(u) = (u);} while (0)
>  # define unicrash_check_dir_name(u, d, n)	(true)
>  # define unicrash_check_xattr_name(u, d, n)	(true)
> 
