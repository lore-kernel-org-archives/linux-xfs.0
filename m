Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37334 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754517AbdBAWo6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Feb 2017 17:44:58 -0500
Subject: Re: [PATCH] Fix building xfsprogs on 32-bit platforms (again)
References: <20170201045144.29488-1-ebiggers3@gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8eb1c7c5-7289-c8c3-a129-c8fac7de6249@sandeen.net>
Date: Wed, 1 Feb 2017 16:44:52 -0600
MIME-Version: 1.0
In-Reply-To: <20170201045144.29488-1-ebiggers3@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Biggers <ebiggers3@gmail.com>, linux-xfs <linux-xfs@vger.kernel.org>
Cc: Gwendal Grignou <gwendal@chromium.org>, Felix Janda <felix.janda@posteo.de>, Eric Biggers <ebiggers@google.com>

On 1/31/17 10:51 PM, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Building xfsprogs on 32-bit platforms was broken again by the recent
> split of BUILD_CFLAGS from CFLAGS.  -D_FILE_OFFSET_BITS=64 was not added
> to BUILD_CFLAGS, but in fact BUILD_CFLAGS is used to compile
> crc32selftest, which includes xfs.h and therefore requires this
> declaration.  Fix this by adding -D_FILE_OFFSET_BITS=64 to BUILD_CFLAGS.
> 
> Fixes: 0a71e3839630 ("build: Allow compiling xfsprogs in a cross compile environment")
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Oh, I missed this, and sent exactly the same patch to
the person who just reported it on the list, so yes,

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Sorry - I need to add 32-bit builds to my testing, obviously :(

> ---
>  include/builddefs.in | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 612b547d..6554e421 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -26,7 +26,7 @@ MALLOCLIB = @malloc_lib@
>  LOADERFLAGS = @LDFLAGS@
>  LTLDFLAGS = @LDFLAGS@
>  CFLAGS = @CFLAGS@ -D_FILE_OFFSET_BITS=64
> -BUILD_CFLAGS = @BUILD_CFLAGS@
> +BUILD_CFLAGS = @BUILD_CFLAGS@ -D_FILE_OFFSET_BITS=64
>  
>  LIBRT = @librt@
>  LIBUUID = @libuuid@
> 
