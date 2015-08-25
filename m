Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B049D7F47
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 17:53:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9F3058F8037
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 15:53:39 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Tw0XPkzNa8NOO0yP for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 15:53:35 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id B333A63C77A5
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 17:53:34 -0500 (CDT)
Message-ID: <55DCF1EE.6070200@sandeen.net>
Date: Tue, 25 Aug 2015 17:53:34 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_repair: set args.geo in longform_dir2_entry_check_data
References: <55DCB52D.3030809@sandeen.net>
In-Reply-To: <55DCB52D.3030809@sandeen.net>
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
To: xfs-oss <xfs@oss.sgi.com>

On 8/25/15 1:34 PM, Eric Sandeen wrote:
> Here's another one where we miss setting da_args->geo:
> 
> longform_dir2_entry_check_data
>         struct xfs_da_args      da = {
>                 .dp = ip,
> 		// .geo is unset
>         };
> ...
> 	libxfs_dir2_data_make_free(&da ...)
> 		xfs_dir2_data_make_free
> 			endptr = (char *)hdr + args->geo->blksize;
> 				BOOM
> 
> Addresses-Coverity-Id: 1298008
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Have to wonder if there are more of these :(

Spot-checking in userspace wasn't hard; doesn't look like there are any more.

kernelspace looks ok too.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
