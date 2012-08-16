Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7GA7Hfg098525 for <xfs@oss.sgi.com>; Thu, 16 Aug 2012 05:07:18 -0500
Received: from mail-lb0-f181.google.com (mail-lb0-f181.google.com
	[209.85.217.181]) by cuda.sgi.com with ESMTP id
	KQ6wTBxqNklJCXnF (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 Aug 2012 03:07:16 -0700 (PDT)
Received: by lbbgk1 with SMTP id gk1so1484096lbb.26
	for <xfs@oss.sgi.com>; Thu, 16 Aug 2012 03:07:14 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: Test 272 fails for ext3
In-Reply-To: <20120816093757.GA11519@quack.suse.cz>
References: <20120816092808.GA9057@quack.suse.cz>
	<20120816093757.GA11519@quack.suse.cz>
Date: Thu, 16 Aug 2012 14:07:12 +0400
Message-ID: <871uj7kv5b.fsf@openvz.org>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com
Cc: linux-ext4@vger.kernel.org

On Thu, 16 Aug 2012 11:37:57 +0200, Jan Kara <jack@suse.cz> wrote:
Non-text part: multipart/mixed
>   Hello,
> 
>   I was looking into why test 272 from xfstests fails for ext3 and the
> reason is that ext3 does not support direct IO to file with enabled data
> journalling (open returns EINVAL because ->direct_IO callback is not
> specified). So I was thinking how to accomodate this fact in the test -
> the best I found was to just check using xfs_io whether O_DIRECT open
> succeeds and perform the test only in that case. Attached patch does this
> or do people have other ideas?
Looks reasonable
ACK.
> 
> 								Honza
> 
> PS: Sending again with correct list address. I'm sorry for unnecessary email.
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> From 529429c8497314ef956e470fdb9b94bfe797df69 Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Thu, 16 Aug 2012 11:14:35 +0200
> Subject: [PATCH] Make test 272 work for ext3
> 
> ext3 does not support direct IO for files with data journalling. This
> confuses test 272. Make the test check whether open succeeds and perform
> the writing only if it does.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  272 |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/272 b/272
> index 26dfa3b..e39c52b 100755
> --- a/272
> +++ b/272
> @@ -52,6 +52,12 @@ _workout()
>  		    
>  			echo "OP write_opt: $write_opt 4M, \
>  chattr_opt: $chattr_opt"
> +			if [ "$write_opt" = "oflag=direct" ]; then
> +				# Some filesystems don't support direct IO
> +				# in some cases, check for that
> +				xfs_io -F -d -f -c "" $SCRATCH_MNT/file.$idx \
> +					>> $seq.full 2>&1 || continue
> +			fi
>  			dd if=/dev/zero of=$SCRATCH_MNT/file.$idx \
>  				bs=1M count=4 $write_opt \
>  				>> $seq.full 2>&1 || exit
> -- 
> 1.7.1
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
