Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7DMphgf056108 for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 17:51:53 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 64825304112
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 15:52:29 -0700 (PDT)
Message-Id: <1CDE853D-47DB-4E76-8D8F-DA1B77CC1F54@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <4A849096.1010600@sandeen.net>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] xfs_io: actually issue 0 size writes
Date: Thu, 13 Aug 2009 17:52:28 -0500
References: <4A849096.1010600@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>


On Aug 13, 2009, at 5:15 PM, Eric Sandeen wrote:

> While testing some stuff in generic_write_checks() in the
> kernel I realized that you can't actually use xfs_io to send
> a 0-byte write in.  This is actually a condition worth testing:
>
>       If  count  is zero and fd refers to a regular file,
>       then write() may return a failure status if one  of
>       the  errors  below  is  detected.  If no errors are
>       detected, 0 will be returned  without  causing  any
>       other  effect.

As I understand the desire to be able to issue 0 size writes
from xfs_io is to test the possibility of writing to a given fd.
What kind of errors would you expect to test for?

Otherwise looks good.

Felix

>
>
> So fix that up.
>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
>
> iff --git a/io/pwrite.c b/io/pwrite.c
> index 54c3f78..26a7850 100644
> --- a/io/pwrite.c
> +++ b/io/pwrite.c
> @@ -163,7 +163,7 @@ write_buffer(
> 	int		ops = 0;
>
> 	*total = 0;
> -	while (count > 0) {
> +	while (count >= 0) {
> 		if (fd > 0) {	/* input file given, read buffer first */
> 			if (read_buffer(fd, skip + *total, bs, &bar, 0, 1) < 0)
> 				break;
> @@ -182,6 +182,8 @@ write_buffer(
> 			break;
> 		offset += bytes;
> 		count -= bytes;
> +		if (count == 0)
> +			break;
> 	}
> 	return ops;
> }
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
