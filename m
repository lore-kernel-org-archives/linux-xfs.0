Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E6B497F3F
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 16:04:09 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B0F0D8F8035
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 14:04:06 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	7a1BWpapSTvAlvFX for <xfs@oss.sgi.com>;
	Mon, 10 Feb 2014 14:04:04 -0800 (PST)
Date: Tue, 11 Feb 2014 09:04:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfstests: Btrfs: add test for large metadata blocks
Message-ID: <20140210220400.GV13647@dastard>
References: <1392068362-14049-1-git-send-email-koen.de.wit@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1392068362-14049-1-git-send-email-koen.de.wit@oracle.com>
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
To: Koen De Wit <koen.de.wit@oracle.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Feb 10, 2014 at 10:39:22PM +0100, Koen De Wit wrote:
> Tests Btrfs filesystems with all possible metadata block sizes, by
> setting large extended attributes on files.
> 
> Signed-off-by: Koen De Wit <koen.de.wit@oracle.com>
....
> +
> +_test_illegal_leafsize() {
> +        _scratch_mkfs -l $1 >>$seqres.full 2>&1
> +        [ $? -ne 0 ] || _fail "'$1' is an illegal value for the" \
> +                "leafsize option, mkfs should have failed."
> +}

You just re-implemented run_check....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
