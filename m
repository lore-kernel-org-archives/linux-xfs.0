Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5JJ5T48076718 for <xfs@oss.sgi.com>; Fri, 19 Jun 2009 14:05:29 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1036A8F8049
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2009 12:05:53 -0700 (PDT)
Message-Id: <3DA81BE6-B205-48B4-B0CE-A9667AFB3E83@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <1245434013-9433-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH 1/3] Skip _check_test_fs unless a test is actually run
Date: Fri, 19 Jun 2009 14:05:52 -0500
References: <1245434013-9433-1-git-send-email-tytso@mit.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>
Cc: xfs@oss.sgi.com


On Jun 19, 2009, at 12:53 PM, Theodore Ts'o wrote:

> Running _check_test_fs can take a non-trivial amount of time, and if a
> test has been skipped because it doesn't work on Linux, or it doesn't
> work of for ext4, it's pointless to re-run _check_test_fs.  So move
> the call to _check_test_fs so it is only run if a test is actually  
> run.

Definitely makes sense.

> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Reviewed-by: Felix Blyakher <felixb@sgi.com>

>
> ---
> check |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/check b/check
> index 545c010..1aae528 100755
> --- a/check
> +++ b/check
> @@ -308,10 +308,10 @@ do
>     then
> 	try="$try $seq"
> 	n_try=`expr $n_try + 1`
> +        _check_test_fs
>     fi
>
>     seq="after_$seq"
> -    _check_test_fs
> done
>
> interrupt=false
> -- 
> 1.6.3.2.1.gb9f7d.dirty
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
