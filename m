Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 98D7A7CA2
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 08:36:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 55E70304048
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 06:36:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id aTjq57B4xyvxzgxe (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 26 Aug 2016 06:36:29 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id A5B3E80F7C
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 13:36:28 +0000 (UTC)
Date: Fri, 26 Aug 2016 08:36:26 -0500
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [PATCH] xfs_quota: fix missing break after foreign_allowed option
Message-ID: <20160826133626.GA1865@redhat.com>
References: <1472200206-15728-1-git-send-email-zlang@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1472200206-15728-1-git-send-email-zlang@redhat.com>
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
To: Zorro Lang <zlang@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 26, 2016 at 04:30:06PM +0800, Zorro Lang wrote:
> New quota "-f" has been brought in by:
> 
>   29647c8 xfs_quota: add capabilities for use on non-XFS filesystems
> 
> But Coverity Scan find a missing break in quota/init.c: init()
> function.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>

Sorry about that.
Thanks for the patch, Zorro.

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  quota/init.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/quota/init.c b/quota/init.c
> index 44be322..2c18c8b 100644
> --- a/quota/init.c
> +++ b/quota/init.c
> @@ -153,6 +153,7 @@ init(
>  			break;
>  		case 'f':
>  			foreign_allowed = true;
> +			break;
>  		case 't':
>  			mtab_file = optarg;
>  			break;
> -- 
> 2.7.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
