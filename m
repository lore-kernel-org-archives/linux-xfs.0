Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6773D7F47
	for <xfs@oss.sgi.com>; Thu, 16 Apr 2015 04:33:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 596F6304043
	for <xfs@oss.sgi.com>; Thu, 16 Apr 2015 02:33:32 -0700 (PDT)
Received: from mail-wi0-f171.google.com (mail-wi0-f171.google.com
	[209.85.212.171]) by cuda.sgi.com with ESMTP id
	s8Gu4Jd4YfbEu42C (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 Apr 2015 02:33:30 -0700 (PDT)
Received: by widdi4 with SMTP id di4so90249892wid.0
	for <xfs@oss.sgi.com>; Thu, 16 Apr 2015 02:33:29 -0700 (PDT)
Message-ID: <552F81E6.4050700@plexistor.com>
Date: Thu, 16 Apr 2015 12:33:26 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH 5/8] xfs: add DAX file operations support
References: <1427194266-2885-1-git-send-email-david@fromorbit.com>
	<1427194266-2885-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1427194266-2885-6-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, willy@linux.intel.com, jack@suse.cz

On 03/24/2015 12:51 PM, Dave Chinner wrote:
<>
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 94713c2..8017175 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -385,7 +385,11 @@ xfs_file_splice_read(
>  
>  	trace_xfs_file_splice_read(ip, count, *ppos, ioflags);
>  
> -	ret = generic_file_splice_read(infilp, ppos, pipe, count, flags);
> +	/* for dax, we need to avoid the page cache */
> +	if (IS_DAX(VFS_I(ip)))
> +		ret = default_file_splice_read(infilp, ppos, pipe, count, flags);
> +	else
> +		ret = generic_file_splice_read(infilp, ppos, pipe, count, flags);

Dave hi

Linus has accepted this patch:
  [be64f884be] dax: unify ext2/4_{dax,}_file_operations

Which adds the same exact if(IS_DAX)) to generic_file_splice_read for use
by ext2/4. (It made things easier for both ext2/4)

But also this code is just fine of course

Thanks
Boaz

>  	if (ret > 0)
>  		XFS_STATS_ADD(xs_read_bytes, ret);
>  
<>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
