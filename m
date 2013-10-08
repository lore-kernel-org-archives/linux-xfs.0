Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CB2F07F54
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 19:53:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6E53DAC002
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 17:53:25 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	gnR6Nl60GvsO1rRA for <xfs@oss.sgi.com>;
	Mon, 07 Oct 2013 17:53:24 -0700 (PDT)
Date: Tue, 8 Oct 2013 11:53:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests XFS: verify extended attributes after
	multi-stream xfsdump/xfsrestore
Message-ID: <20131008005317.GU4446@dastard>
References: <524AF8AE.5030300@sgi.com>
 <20131007193912.256265551@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131007193912.256265551@sgi.com>
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
To: rjohnston@sgi.com
Cc: xfs@oss.sgi.com

On Mon, Oct 07, 2013 at 02:38:35PM -0500, rjohnston@sgi.com wrote:
> Verify extended attributes are not lost after multi-stream
> xfsdump/xfsrestore of wholly-sparse files.  xfsrestore did not
> recognize that if the LAST header was reached with no restoredsz set,
> (i.e the LAST header is the only header), the following warning is
> displayed:
> 
>   "partial_reg: Out of records. Extend attrs applied early."
> 
> and the extended attributes on the current and following restored
> files are lost.
> 
> Signed-off-by: Rich Johnston <rjohnston@sgi.com>
> 
> ---
>  tests/xfs/350     |  134 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/350.out |    2 
>  tests/xfs/group   |    1 
>  3 files changed, 137 insertions(+)
> 
> Index: b/tests/xfs/350
> ===================================================================
> --- /dev/null
> +++ b/tests/xfs/350
....
> +here=`pwd`
> +tmp=/tmp/$$
> +status=0	# success is the default!

status=1

Test failure should always be the default.


> +}
> +echo "Silence is golden."
> +echo "Starting Test 1" >> $seqres.full
> +_clean_dirs
> +_create_test1_files
> +_set_attrs
> +_do_dump_restore
> +_verify_attrs
> +
> +echo "Starting Test 2" >> $seqres.full
> +_clean_dirs
> +_create_test2_files
> +_set_attrs
> +_do_dump_restore
> +_verify_attrs

Two tests, please. move all the common parts into common/dump, and
write them as two separate tests. That way we can easily track what
test is failing just by looking at what harness test is failing...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
