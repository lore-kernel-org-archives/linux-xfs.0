Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48510 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751721AbeADSqv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Jan 2018 13:46:51 -0500
Subject: Re: [PATCH 5/5] find-api-violations: fix a broken grep pattern
References: <151500479880.7713.6538509149156363572.stgit@magnolia>
 <151500483813.7713.6158652834791382962.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <df6f35bf-8cca-ed24-f5df-e1e670247a3f@sandeen.net>
Date: Thu, 4 Jan 2018 12:46:49 -0600
MIME-Version: 1.0
In-Reply-To: <151500483813.7713.6158652834791382962.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 1/3/18 12:40 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> One of the grep patterns in find-api-violations is mistaken for a
> (broken) range specifier when LC_ALL=C, so fix it to work properly.
> This was found by wiring up the script to xfstests.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I'm gonna have to take your word for it that your cat walked correctly
on the keyboard this time.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  tools/find-api-violations.sh |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/tools/find-api-violations.sh b/tools/find-api-violations.sh
> index c2be4c5..3b976d3 100755
> --- a/tools/find-api-violations.sh
> +++ b/tools/find-api-violations.sh
> @@ -10,7 +10,7 @@ tool_dirs="copy db estimate fsck fsr growfs io logprint mdrestore mkfs quota rep
>  
>  # Calls to xfs_* functions in libxfs/*.c without the libxfs_ prefix
>  find_possible_api_calls() {
> -	grep -rn '[[:space:],-(]xfs_[a-z_]*(' $tool_dirs | sed -e 's/^.*\(xfs_[a-z_]*\)(.*$/\1/g' | sort | uniq
> +	grep -rn '[-[:space:],(]xfs_[a-z_]*(' $tool_dirs | sed -e 's/^.*\(xfs_[a-z_]*\)(.*$/\1/g' | sort | uniq
>  }
>  
>  check_if_api_calls() {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
