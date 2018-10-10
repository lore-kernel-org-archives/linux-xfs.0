Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48620 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726693AbeJJVJQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Oct 2018 17:09:16 -0400
Subject: Re: [PATCH 1/2] xfsprogs: document changes for 4.19.0-rc0
References: <20181010071023.6765-1-david@fromorbit.com>
 <20181010071023.6765-2-david@fromorbit.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <fb999fa8-0a0e-f63a-5082-0520de2fcef7@sandeen.net>
Date: Wed, 10 Oct 2018 08:46:59 -0500
MIME-Version: 1.0
In-Reply-To: <20181010071023.6765-2-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On 10/10/18 2:10 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because 'make deb' breaks without them.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Ugh, sorry about that, still not used to build systems that break on unchangelogged git tags ...


(that is the trigger, right?  the tag?)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>


> ---
>  debian/changelog | 7 +++++++
>  doc/CHANGES      | 7 +++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/debian/changelog b/debian/changelog
> index 01639f9efeec..ef129e278948 100644
> --- a/debian/changelog
> +++ b/debian/changelog
> @@ -1,3 +1,10 @@
> +xfsprogs (4.19.0-rc0-1) unstable; urgency=low
> +
> +  * New upstream pre-release
> +  * Merge libxfs changes from kernel-4.19
> +
> + -- Nathan Scott <nathans@debian.org>  Wed, 10 Oct 2018 17:52:48 +1100
> +
>  xfsprogs (4.18.0-1) unstable; urgency=low
>  
>    * New upstream release
> diff --git a/doc/CHANGES b/doc/CHANGES
> index 3c1e39469008..1c41bd90a1c5 100644
> --- a/doc/CHANGES
> +++ b/doc/CHANGES
> @@ -1,3 +1,10 @@
> +xfsprogs-4.18.0-rc0 (10 Oct 2018)
> +	- Majority of 4.18 libxfs changes merged from kernel
> +	- Big sparse static checker cleanup (Eric Sandeen)
> +	- mkfs.xfs discard fixes (Jan Tulak)
> +	- xfs_io readv/writev cleanup (Zorro Lang)
> +	- libxfs transaction commit error checking (Darrick Wong)
> +
>  xfsprogs-4.18.0 (24 Aug 2018)
>  	- Tweak SPDX license in xfs_cksum.h (Darrick Wong)
>  
> 
