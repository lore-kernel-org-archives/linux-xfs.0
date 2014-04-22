Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DE06A7F3F
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 19:09:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BD3498F8040
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 17:09:26 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	X3c52aWHFN6tTTXs for <xfs@oss.sgi.com>;
	Mon, 21 Apr 2014 17:09:24 -0700 (PDT)
Date: Tue, 22 Apr 2014 10:07:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] generic/009: get the correct dev name when testing
	ext4
Message-ID: <20140422000755.GH18672@dastard>
References: <1397708214-8197-1-git-send-email-eguan@redhat.com>
	<1397708214-8197-3-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397708214-8197-3-git-send-email-eguan@redhat.com>
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

On Thu, Apr 17, 2014 at 12:16:54PM +0800, Eryu Guan wrote:
> If TEST_DEV is a symlink(usually a lvm), we get the wrong DEV
> name. Follow link and get the correct dev name.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>  tests/generic/009 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/generic/009 b/tests/generic/009
> index 1e487b4..7675c69 100644
> --- a/tests/generic/009
> +++ b/tests/generic/009
> @@ -51,7 +51,7 @@ testfile=$TEST_DIR/009.$$
>  
>  # Disable extent zeroing for ext4 as that change where holes are created
>  if [ "$FSTYP" = "ext4" ]; then
> -	DEV=`basename $TEST_DEV`
> +	DEV=`basename $(readlink -f $TEST_DEV)`
>  	echo 0 >/sys/fs/ext4/$DEV/extent_max_zeroout_kb
>  fi

We've made this mistake several times now. Can you add a function
in common/rc that does this. e.g. "_real_dev()" and replace
all the current 'readlink -f $DEV' calls with that function?
i.e. something like:

_real_dev()
{
	local _dev=$1
	if [ -L "$_dev" ]; then
		_dev=`readlink -f $_dev`
	fi
	echo $_dev
}

_short_dev()
{
	echo `basename $(_real_dev $1)`
}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
