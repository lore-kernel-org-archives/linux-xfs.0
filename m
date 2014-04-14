Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7F0DD29DF7
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2014 10:02:00 -0500 (CDT)
Message-ID: <534BF866.4020007@sgi.com>
Date: Mon, 14 Apr 2014 10:01:58 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] mkfs.xfs: prevent close(-1) on protofile error path
References: <534BF472.8030908@sandeen.net> <534BF53C.4000706@sandeen.net>
In-Reply-To: <534BF53C.4000706@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On 04/14/14 09:48, Eric Sandeen wrote:
> My previous cleanups introduced this; in the case where
> fd=open() failed, the out_fail: path would try to close(-1).
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---
>
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index 308325b..5a47e27 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -84,7 +84,8 @@ setup_proto(
>   	return buf;
>
>   out_fail:
> -	close(fd);
> +	if (fd>= 0)
> +		close(fd);
>   	free(buf);
>   	exit(1);
>   }
>

I would have bypassed the close with a new open error goto, but this 
does the trick as well.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
