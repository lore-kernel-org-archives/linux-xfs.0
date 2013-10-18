Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 59A3F7F3F
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 13:17:48 -0500 (CDT)
Message-ID: <52617B46.3080305@sgi.com>
Date: Fri, 18 Oct 2013 13:17:42 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: Note projid32bit default change in mkfs.xfs
	manpage
References: <52617691.8090101@redhat.com>
In-Reply-To: <52617691.8090101@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Looks good.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

On 10/18/2013 12:57 PM, Eric Sandeen wrote:
> As of xfsprogs 3.2.0, the projid32bit default changed from 0
> to 1.  Document this.
>
> When we document -m crc etc, we'll also need to note that 0 is
> incompatible with crc=1.
>
> Signed-off-by: Eric Sandeen <sandeen@redaht.com>
> ---
>
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index 61122f0..99f7013 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -362,7 +362,8 @@ than version 2.6.16.
>   This is used to enable 32bit quota project identifiers. The
>   .I value
>   is either 0 or 1, with 1 signifying that 32bit projid are to be enabled.
> -If the value is omitted, 0 is assumed.
> +If the value is omitted, 1 is assumed.  (This default changed
> +in release version 3.2.0.)
>   .RE
>   .TP
>   .BI \-l " log_section_options"
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
