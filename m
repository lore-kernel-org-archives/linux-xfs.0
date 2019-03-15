Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:45142 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbfCOWCT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Mar 2019 18:02:19 -0400
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 04/36] debian: drop dangling libhandle.a symlinks in
 xfslibs-dev
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259744781.31886.15637750109545213350.stgit@magnolia>
Message-ID: <6397cd8f-8076-182a-3285-ec5a095e6cfa@oracle.com>
Date: Fri, 15 Mar 2019 15:02:13 -0700
MIME-Version: 1.0
In-Reply-To: <155259744781.31886.15637750109545213350.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org

Alighty, looks ok.

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

On 3/14/19 2:04 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We don't ship static libhandle libraries anymore, so make sure we drop
> the symlink.
> 
> Fixes: ec1cf08dbeb2d ("Several updates to use more modern Debian packaging")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   debian/rules |    1 +
>   1 file changed, 1 insertion(+)
> 
> 
> diff --git a/debian/rules b/debian/rules
> index 4c50654c..80dff4bb 100755
> --- a/debian/rules
> +++ b/debian/rules
> @@ -80,6 +80,7 @@ binary-arch: checkroot built
>   	install -D -m 0755 debian/local/initramfs.hook debian/xfsprogs/usr/share/initramfs-tools/hooks/xfs
>   	rmdir debian/xfslibs-dev/usr/share/doc/xfsprogs
>   	rm -f debian/xfslibs-dev/lib/libhandle.la
> +	rm -f debian/xfslibs-dev/lib/libhandle.a
>   	rm -fr debian/xfslibs-dev/usr/lib
>   	dh_installdocs
>   	dh_installchangelogs
> 
