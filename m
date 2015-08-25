Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2632C7F47
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 17:52:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E8A7F8F8049
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 15:52:22 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	JXm4X7Uu2UGCmWWW for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 15:52:17 -0700 (PDT)
Date: Wed, 26 Aug 2015 08:52:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_repair: set args.geo in longform_dir2_entry_check_data
Message-ID: <20150825225201.GJ714@dastard>
References: <55DCB52D.3030809@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Aug 25, 2015 at 01:34:21PM -0500, Eric Sandeen wrote:
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

A quick git grep shows 3 uses of the struct xfs_da_args outside
libxfs. longform_dir2_entry_check() is already fixed, this fixes
longform_dir2_entry_check_data(), and dir2_kill_block() still needs
fixing.

AFAICT all the libxfs/ usage is good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
