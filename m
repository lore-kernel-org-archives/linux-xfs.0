Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47814 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934514AbeFLWJQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jun 2018 18:09:16 -0400
Date: Tue, 12 Jun 2018 15:09:12 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/7] mkfs: parameterize sysconfdir in mkfs.xfs.8
Message-ID: <20180612220912.GN22045@magnolia>
References: <1528831883-21879-1-git-send-email-sandeen@sandeen.net>
 <1528831883-21879-4-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1528831883-21879-4-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 12, 2018 at 02:31:19PM -0500, Eric Sandeen wrote:
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  man/man8/mkfs.xfs.8.in | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
> index dcd95ad..8ea2fe9 100644
> --- a/man/man8/mkfs.xfs.8.in
> +++ b/man/man8/mkfs.xfs.8.in
> @@ -131,7 +131,7 @@ contains built-in default values for every option as described in the sections
>  below.
>  These built-in defaults may evolve over time as new capabilities are added.
>  If the file
> -.B /etc/xfs/mkfs/defaults
> +.B @sysconfdir@/xfs/mkfs/defaults
>  exists, it will be parsed to override built-in defaults, and the defaults
>  described in sections below may no longer apply.
>  .PP
> @@ -143,7 +143,7 @@ as described in the OPTIONS section.
>  .TP
>  .BI \-c " configuration"
>  This option may be used to specify a configuration file other than
> -.B /etc/xfs/mkfs/defaults
> +.B @sysconfdir@/xfs/mkfs/defaults
>  to override selected built-in parameter defaults.
>  If
>  .B configuration
> @@ -155,7 +155,7 @@ Otherwise,
>  will search for
>  .B configuration
>  first in the current working directory, and then in the
> -.B /etc/xfs/mkfs/
> +.B @sysconfdir@/xfs/mkfs/
>  directory.
>  See also the CONFIGURATION FILE FORMAT section below.
>  .TP
> @@ -958,7 +958,7 @@ Do not attempt to discard blocks at mkfs time.
>  Prints the version number and exits.
>  .SH CONFIGURATION FILE FORMAT
>  The optional default configuration file in
> -.B /etc/xfs/mkfs/default
> +.B @sysconfdir@/xfs/mkfs/default
>  as well as any alternate configuration file specified via the
>  .B \-c
>  option follow a simple ini-style format as shown below.
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
