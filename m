Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 08BEC7F3F
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 00:11:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E3A338F8064
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 22:11:01 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	hiQkCrCpAVXy9j0M for <xfs@oss.sgi.com>;
	Mon, 21 Apr 2014 22:10:56 -0700 (PDT)
Date: Tue, 22 Apr 2014 15:10:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] common: new function to get real device path name and
	basename
Message-ID: <20140422051051.GI18672@dastard>
References: <1398137247-4883-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1398137247-4883-1-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 22, 2014 at 11:27:27AM +0800, Eryu Guan wrote:
> If TEST_DEV or SCRATCH_DEV is symlink(mostly a lvm lv), a simple
> basename is not enough, symlink should be followed.
> 
> This task is common enough, so introduce new helper functions and
> replace all readlink calls in
> 
> ext4/305
> generic/009
> generic/019
> generic/285
> generic/312
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>  common/rc         | 16 ++++++++++++++++
>  tests/ext4/305    |  2 +-
>  tests/generic/009 |  2 +-
>  tests/generic/019 |  4 +---
>  tests/generic/285 |  2 +-
>  tests/generic/312 |  2 +-
>  6 files changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index acf419b..68b040d 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2302,6 +2302,22 @@ init_rc()
>  	export XFS_IO_PROG="$XFS_IO_PROG -F"
>  }
>  
> +# get real device path name by following link
> +_real_dev()
> +{
> +	local _dev=$1
> +	if [ -b "$_dev" ] && [ -L "$_dev" ]; then
> +		_dev=`readlink -f "$_dev"`
> +	fi
> +	echo $_dev
> +}
> +
> +# basename of a device
> +_basename_dev()
> +{
> +	echo `basename $(_real_dev $1)`
> +}

I don't really like that function name.  It describes the
implementation, not what the function actually returns. i.e. we're
getting the -short- device names here, basename is the implemenation
used to turn a full device name to a short device name...

Cheers,

Dave
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
