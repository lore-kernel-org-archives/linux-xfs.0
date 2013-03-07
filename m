Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2900F7FC8
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 08:56:37 -0600 (CST)
Message-ID: <5138AAA2.70308@sgi.com>
Date: Thu, 07 Mar 2013 08:56:34 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Fix typo from commit 0c5e67e4 "xfstests 273: fix a typo"
References: <20130307124102.821208303@sgi.com>
	<20130307124125.435047948@sgi.com>
In-Reply-To: <20130307124125.435047948@sgi.com>
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
To: rjohnston@sgi.com
Cc: shhuiw@gmail.com, xfs@oss.sgi.com

On 03/07/13 06:41, rjohnston@sgi.com wrote:
> When updating the patch, the redirect was incorrect.
>
> Reported-by: Wang Sheng-Hui<shhuiw@gmail.com>
> Signed-off-by: Rich Johnston<rjohnston@sgi.com>
>
> ---
>
>   273 |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: b/273
> ===================================================================
> --- a/273
> +++ b/273
> @@ -92,7 +92,7 @@ _porter()
>   		exit
>   	fi
>
> -	cp -r $SCRATCH_MNT/origin $SCRATCH_MNT/sub_$_suffix>$seq.full 2>>&1
> +	cp -r $SCRATCH_MNT/origin $SCRATCH_MNT/sub_$_suffix>>$seq.full 2>&1
>   	if [ $? -ne 0 ]
>   	then
>   		echo "_porter $_suffix not complete"
>


The original patch looked okay:

    http://oss.sgi.com/archives/xfs/2013-02/msg00518.html

Should the bad patch be reverted and the original one put in?

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
