Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9D9D37F37
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 17:30:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8D4268F8049
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 15:30:27 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	SxAOucf744bBYLMy for <xfs@oss.sgi.com>;
	Thu, 30 May 2013 15:30:26 -0700 (PDT)
Date: Fri, 31 May 2013 08:30:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] 285: Fix test for ext4 in some configurations
Message-ID: <20130530223000.GQ29466@dastard>
References: <1369917939-22660-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1369917939-22660-1-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Thu, May 30, 2013 at 02:45:37PM +0200, Jan Kara wrote:
> In some configurations (e.g. 1 KB block size), ext4 can decide it is
> better to zero out several blocks rather than splitting unwritten
> extent. This changes results SEEK_HOLE / SEEK_DATA returns and thus the
> test fails. Fix the problem by disabling the feature for this test.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  tests/generic/285 | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/tests/generic/285 b/tests/generic/285
> index b700a15..8078b1c 100755
> --- a/tests/generic/285
> +++ b/tests/generic/285
> @@ -46,6 +46,12 @@ BASE_TEST_FILE=$TEST_DIR/seek_sanity_testfile
>  
>  [ -x $here/src/seek_sanity_test ] || _notrun "seek_sanitfy_tester not built"
>  
> +# Disable extent zeroing for ext4 as that change where holes are created
> +if [ "$FSTYP" = "ext4" ]; then
> +	DEV=`basename $TEST_DEV`
> +	echo 0 >/sys/fs/ext4/$DEV/extent_max_zeroout_kb
> +fi

would that be better going into _require_seek_data_hole so that 286
also picks up this behaviour for ext4?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
