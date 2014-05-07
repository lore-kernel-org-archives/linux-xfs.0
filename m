Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 28BE27F52
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 17:44:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F00448F8037
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 15:44:18 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	qdZAKjRGShPHg17O for <xfs@oss.sgi.com>;
	Wed, 07 May 2014 15:44:16 -0700 (PDT)
Date: Thu, 8 May 2014 08:44:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: fix flink test
Message-ID: <20140507224413.GQ5421@dastard>
References: <1399496087-20431-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1399496087-20431-1-git-send-email-jbacik@fb.com>
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
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, May 07, 2014 at 04:54:47PM -0400, Josef Bacik wrote:
> I don't have flink support in my xfsprogs, but it doesn't fail with "command not
> found" or whatever, it fails because I don't have the -T option.  So fix
> _require_xfs_io_command to check for an invalid option and not run.  This way I
> get notrun instead of a failure.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  common/rc | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 5c13db5..4fa7e63 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1258,6 +1258,8 @@ _require_xfs_io_command()
>  		_notrun "xfs_io $command support is missing"
>  	echo $testio | grep -q "Operation not supported" && \
>  		_notrun "xfs_io $command failed (old kernel/wrong fs?)"
> +	echo $testio | grep -q "invalid option" && \
> +		_notrun "xfs_io $command support is missing"
>  }

Yeah, looks like it throws a different error - it treats -T as an
option, not a command. Rather than multiple checks that result in
the same error, why not just:

-	echo $testio | grep -q "not found" && \
+	echo $testio | egrep -q 'not found|invalid option' && \
                _notrun "xfs_io $command support is missing"

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
