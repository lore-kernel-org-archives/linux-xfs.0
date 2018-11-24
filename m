Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:60408 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725744AbeKYFLe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Nov 2018 00:11:34 -0500
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 01/12] fsstress: fix compiler warnings
References: <154290950237.1218.9937108728673485814.stgit@magnolia>
 <154290950874.1218.16162093723366805081.stgit@magnolia>
Message-ID: <d60f04c8-9e77-dc93-1cc6-082118f66ba7@oracle.com>
Date: Sat, 24 Nov 2018 11:22:31 -0700
MIME-Version: 1.0
In-Reply-To: <154290950874.1218.16162093723366805081.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, guaneryu@gmail.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org



On 11/22/18 10:58 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix all the gcc warnings in fsstress.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   ltp/fsstress.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index edbb3f2f..8d0734fc 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -499,7 +499,7 @@ int main(int argc, char **argv)
>   		exit(1);
>   	}
>   	if (logname) {
> -		char path[PATH_MAX];
> +		char path[PATH_MAX + NAME_MAX + 1];
>   		snprintf(path, sizeof(path), "%s/%s", rpath, logname);
>   		if (freopen(path, "a", stdout) == NULL) {
>   			perror("freopen logfile failed");
> @@ -583,7 +583,7 @@ int main(int argc, char **argv)
>   				return 0;
>   #endif
>   			if (logname) {
> -				char path[PATH_MAX];
> +				char path[PATH_MAX + NAME_MAX + 2 + 11];
>   				snprintf(path, sizeof(path), "%s/%s.%d",
>   					 rpath, logname, i);
>   				if (freopen(path, "a", stdout) == NULL) {
> 

Looks ok.  I'm assuming the 2 and the 11 are for the slash, dot and 
logname?  Maybe just a comment or two in the commit.  Otherwise looks 
good to me, you can add my review.  Thx!  :-)

Reviewed-By: Allison Henderson <allison.henderson@oracle.com>

Allison
