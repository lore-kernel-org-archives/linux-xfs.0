Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 40EEF7F60
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 20:09:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1E91D8F8065
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 18:08:59 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	GqBbcAajLsLqF4pD for <xfs@oss.sgi.com>;
	Mon, 07 Oct 2013 18:08:57 -0700 (PDT)
Date: Tue, 8 Oct 2013 12:08:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests XFS: verify extended attributes after
	multi-stream xfsdump/xfsrestore
Message-ID: <20131008010822.GW4446@dastard>
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
> +# create files for test 1, a large file so the sparse file
> +# is in the next stream.
> +_create_test1_files()
> +{
> +
> +	dd if=/dev/zero of=$SCRATCH_MNT/$DUMPDIR/10MB bs=1MB \
> +		count=10 2>&1 >> $seqres.full | _filter_dd
> +	truncate --size=1t $SCRATCH_MNT/$DUMPDIR/sparse0 2>&1 \
> +		>> $seqres.full

I just noticed that 'truncate' is used here - we don't use that
anywhere else in xfstests, so either you need test for it in
common/config and use $TRUNCATE_PROG, or do like every other test
does and use:

	$XFS_IO_PROG -c "truncate 1t" $SCRATCH_MNT/$DUMPDIR/sparse0 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
