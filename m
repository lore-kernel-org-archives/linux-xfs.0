Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q16CC0Ng129433 for <xfs@oss.sgi.com>; Mon, 6 Feb 2012 06:12:01 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	bHlTbEgZJASKpId2 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 Feb 2012 04:11:58 -0800 (PST)
Date: Mon, 6 Feb 2012 07:11:55 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfstests: add btrfs online defragments QA test
Message-ID: <20120206121155.GA16044@infradead.org>
References: <1328516869-19474-1-git-send-email-liubo2009@cn.fujitsu.com>
	<1328516869-19474-3-git-send-email-liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1328516869-19474-3-git-send-email-liubo2009@cn.fujitsu.com>
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
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: hch@infradead.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Feb 06, 2012 at 04:27:49PM +0800, Liu Bo wrote:
> +_runtest()
> +{
> +	$progs_dir/runtest.sh $defrag_args $SCRATCH_MNT $SCRATCH_DEV

please put the actual tests into test cases themselves instead of
calling out into shell scripts under src.  If you have common code
shared between multiple tests please put them into common.defrag.

> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +. ./common.defrag
> +
> +# real QA test starts here
> +_supported_fs xfs btrfs

does it really support xfs?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
