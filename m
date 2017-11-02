Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58828 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964798AbdKBUER (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Nov 2017 16:04:17 -0400
Subject: Re: [PATCH] build: define _DEFAULT_SOURCE if _BSD_SOURCE
References: <20171026172857.8683-1-mcgrof@kernel.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d1635f9c-dcc7-66fe-268d-2aece2d44ba8@sandeen.net>
Date: Thu, 2 Nov 2017 15:04:16 -0500
MIME-Version: 1.0
In-Reply-To: <20171026172857.8683-1-mcgrof@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org

On 10/26/17 12:28 PM, Luis R. Rodriguez wrote:
> ./configure will leave traces of a complaint on config.log when
> _BSD_SOURCE is defined but not _DEFAULT_SOURCE. _BSD_SOURCE is
> deprecated so if defining _BSD_SOURCE also define _DEFAULT_SOURCE.
> 
> From config.log:
> /usr/include/features.h:183:3: warning: #warning "_BSD_SOURCE and _SVID_SOURCE are deprecated, use _DEFAULT_SOURCE" [-Wcpp]

Ok.  Or perhaps a more clear rationale is the preadv(5) manpage
itself:

preadv(), pwritev():
	since glibc 2.19:
		_DEFAULT_SOURCE
	Glibc 2.19 and earlier:
		_BSD_SOURCE

But this is just a feature test macro in a configure script.

What about the code itself, how do we handle this when we
actually use preadv() in the codebase?

-Eric

> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> ---
>  m4/package_libcdev.m4 | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
> index fa5b63978797..af2a9631b8ba 100644
> --- a/m4/package_libcdev.m4
> +++ b/m4/package_libcdev.m4
> @@ -137,6 +137,7 @@ AC_DEFUN([AC_HAVE_PREADV],
>    [ AC_MSG_CHECKING([for preadv])
>      AC_TRY_LINK([
>  #define _BSD_SOURCE
> +#define _DEFAULT_SOURCE
>  #include <sys/uio.h>
>      ], [
>           preadv(0, 0, 0, 0);
> 
