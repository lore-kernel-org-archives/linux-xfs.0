Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8D0AF7CA0
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 07:32:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4F656304039
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 05:31:59 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id kaa4ILWGjKzU1tyz for <xfs@oss.sgi.com>;
	Fri, 26 Aug 2016 05:31:56 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id E68FF474B81
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 07:31:55 -0500 (CDT)
Subject: Re: [PATCH] xfs_quota: fix missing break after foreign_allowed option
References: <1472200206-15728-1-git-send-email-zlang@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d46ed354-6d72-bafc-08b4-82e43961166d@sandeen.net>
Date: Fri, 26 Aug 2016 07:31:55 -0500
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

On 8/26/16 3:30 AM, Zorro Lang wrote:
> New quota "-f" has been brought in by:
> 
>   29647c8 xfs_quota: add capabilities for use on non-XFS filesystems
> 
> But Coverity Scan find a missing break in quota/init.c: init()
> function.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

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
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
