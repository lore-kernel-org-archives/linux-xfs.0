Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B13447CA2
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 02:32:19 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9E4428F8040
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 00:32:19 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Xi4pbL5DbIFi4EH4 for <xfs@oss.sgi.com>;
	Tue, 09 Feb 2016 00:32:17 -0800 (PST)
Date: Tue, 9 Feb 2016 19:32:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 21/23] xfs: aio cow tests
Message-ID: <20160209083215.GP19486@dastard>
References: <20160209011145.23099.95354.stgit@birch.djwong.org>
	<20160209011401.23099.38.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160209011401.23099.38.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Feb 08, 2016 at 05:14:01PM -0800, Darrick J. Wong wrote:
.,,,
> +
> +echo "Check for damage"
> +_dmerror_unmount
> +_dmerror_cleanup
> +_repair_scratch_fs >> "$seqres.full" 2>&1

Are you testing repair here? If so, why doesn't failure matter.
If not, why do it? Or is _require_scratch_nocheck all that is needed
here?

> +echo "CoW and unmount"
> +"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz * bsz)) 1" "$testdir/file2" >> "$seqres.full"
> +"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * bsz)) 0 $((blksz * nr))" "$TEST_DIR/moo" >> "$seqres.full"

offset = block size times block size?

I think some better names might be needed...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
