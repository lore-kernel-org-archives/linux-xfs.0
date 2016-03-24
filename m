Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D75BC7CA0
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 11:33:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9BB698F8037
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 09:33:51 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id QmV5l1FgdXUpXcwF for <xfs@oss.sgi.com>;
	Thu, 24 Mar 2016 09:33:49 -0700 (PDT)
Received: from Liberator.local (189.214.92.185.cable.dyn.cableonline.com.mx
	[189.214.92.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 150ED569
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 11:33:47 -0500 (CDT)
Subject: Re: [PATCH 02/19] mkfs: sanitise ftype parameter values.
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-3-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56F416E8.5000704@sandeen.net>
Date: Thu, 24 Mar 2016 11:33:44 -0500
MIME-Version: 1.0
In-Reply-To: <1458818136-56043-3-git-send-email-jtulak@redhat.com>
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



On 3/24/16 6:15 AM, jtulak@redhat.com wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because passing "-n ftype=2" should fail.

but passing crc=1 ftype=1 shouldn't fail, should it?
Seems like it will here.

-Eric

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 36e5b4f..979a860 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1596,7 +1596,15 @@ main(
>  						reqval('n', nopts, N_FTYPE);
>  					if (nftype)
>  						respec('n', nopts, N_FTYPE);
> -					dirftype = atoi(value);
> +					c = atoi(value);
> +					if (c < 0 || c > 1)
> +						illegal(value, "n ftype");
> +					if (crcs_enabled) {
> +						fprintf(stderr,
> +_("cannot specify both crc and ftype\n"));
> +						usage();
> +					}
> +					dirftype = c;
>  					nftype = 1;
>  					break;
>  				default:
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
