Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2E32D7F84
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 12:53:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 21A348F8054
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 10:53:25 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id GrDfAL0wKH0AdTpi for <xfs@oss.sgi.com>;
	Thu, 10 Apr 2014 10:53:23 -0700 (PDT)
Message-ID: <5346DA91.3090305@sandeen.net>
Date: Thu, 10 Apr 2014 12:53:21 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: Fix generic/022 output file
References: <1397139797-9650-1-git-send-email-lczerner@redhat.com>
In-Reply-To: <1397139797-9650-1-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

On 4/10/14, 9:23 AM, Lukas Czerner wrote:
> In commit 21723cdb I've accidentally changed header in the output file
> to a wrong number. It should be 022, fix it.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  tests/generic/022.out | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/generic/022.out b/tests/generic/022.out
> index 96c2d33..fbffa59 100644
> --- a/tests/generic/022.out
> +++ b/tests/generic/022.out
> @@ -1,4 +1,4 @@
> -QA output created by 009
> +QA output created by 022
>  	1. into a hole
>  f4f35d60b3cc18aaa6d8d92f0cd3708a
>  	2. into allocated space
> 

I can review this one!  ;)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
