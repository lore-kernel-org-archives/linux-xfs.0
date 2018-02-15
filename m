Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47482 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1423465AbeBORCO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Feb 2018 12:02:14 -0500
Subject: Re: [PATCH] debian: add build-depends on pkg-config
References: <20180215065134.GP5217@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <268bfeb5-f7bf-b2b2-74c3-2c6c74d8b427@sandeen.net>
Date: Thu, 15 Feb 2018 11:02:12 -0600
MIME-Version: 1.0
In-Reply-To: <20180215065134.GP5217@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Nathan Scott <nathans@redhat.com>

On 2/15/18 12:51 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Since the configure scripts now depend on pkg-config to autodetect where
> systemd service files go, we need to list pkg-config as a build
> dependency.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I'd love to have a Debian-savvy person look over these things.

Nathan maybe? :)

Thanks,
-Eric

> ---
>  debian/control |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/debian/control b/debian/control
> index 60fcc46..78720bd 100644
> --- a/debian/control
> +++ b/debian/control
> @@ -3,7 +3,7 @@ Section: admin
>  Priority: optional
>  Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
>  Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>
> -Build-Depends: uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libreadline-gplv2-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libunistring-dev, dh-python
> +Build-Depends: uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libreadline-gplv2-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libunistring-dev, dh-python, pkg-config
>  Standards-Version: 3.9.1
>  Homepage: https://xfs.wiki.kernel.org/
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
