Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3FC627CA2
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 15:25:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CA132AC003
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 13:25:51 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id L4UUNgIHjDiRdBRf for <xfs@oss.sgi.com>;
	Mon, 06 Jun 2016 13:25:49 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id A5D3822C5
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 15:25:49 -0500 (CDT)
Subject: Re: [PATCH] mkfs: update manpage for -i size
References: <1465218531-16192-1-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <218360cc-6e75-1a75-4662-60a7a83ae6ce@sandeen.net>
Date: Mon, 6 Jun 2016 15:25:49 -0500
MIME-Version: 1.0
In-Reply-To: <1465218531-16192-1-git-send-email-jtulak@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com



On 6/6/16 8:08 AM, Jan Tulak wrote:
> Adding CRC changed the minimum size for inode size from 256 to 512 bytes, but
> it is not mentioned in the man page.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  man/man8/mkfs.xfs.8 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index 980b0e1..c3629d9 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -358,7 +358,7 @@ or as the number fitting in a filesystem block with
>  .BR perblock= .
>  The minimum (and default)
>  .I value
> -is 256 bytes.
> +is 256 bytes without crc, 512 bytes with crc enabled.
>  The maximum
>  .I value
>  is 2048 (2 KiB) subject to the restriction that
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
