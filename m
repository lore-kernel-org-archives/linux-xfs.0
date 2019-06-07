Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:57920 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728684AbfFGRoQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Jun 2019 13:44:16 -0400
Date: Fri, 7 Jun 2019 11:44:15 -0600
From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] Documentation: xfs: Fix typo
Message-ID: <20190607114415.32cb32dd@lwn.net>
In-Reply-To: <20190509030549.2253-1-ruansy.fnst@cn.fujitsu.com>
References: <20190509030549.2253-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, 9 May 2019 11:05:49 +0800
Shiyang Ruan <ruansy.fnst@cn.fujitsu.com> wrote:

> In "Y+P" of this line, there are two non-ASCII characters(0xd9 0x8d)
> following behind the 'Y'.  Shown as a small '=' under the '+' in VIM
> and a '賺' in webpage[1].
> 
> I think it's a mistake and remove these strange characters.
> 
> [1]: https://www.kernel.org/doc/Documentation/filesystems/xfs-delayed-logging-design.txt
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
> ---
>  Documentation/filesystems/xfs-delayed-logging-design.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/filesystems/xfs-delayed-logging-design.txt b/Documentation/filesystems/xfs-delayed-logging-design.txt
> index 2ce36439c09f..9a6dd289b17b 100644
> --- a/Documentation/filesystems/xfs-delayed-logging-design.txt
> +++ b/Documentation/filesystems/xfs-delayed-logging-design.txt
> @@ -34,7 +34,7 @@ transaction:
>  	   D			A+B+C+D		X+n+m+o
>  	    <object written to disk>
>  	   E			   E		   Y (> X+n+m+o)
> -	   F			  E+F		  Yٍ+p
> +	   F			  E+F		  Y+p

OK, that does look funky, applied.

This patch probably should have been copied to the XFS list (added), even
though get_maintainer.pl doesn't know that.

Thanks,

jon
