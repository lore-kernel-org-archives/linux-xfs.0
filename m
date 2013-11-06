Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E704429E28
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 04:41:11 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B915D8F804C
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 02:41:11 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id N2ZygElPKioDVUBc (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 06 Nov 2013 02:41:11 -0800 (PST)
Date: Wed, 6 Nov 2013 02:41:11 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 36/37] repair: Increase default repair parallelism on
	large filesystems
Message-ID: <20131106104111.GB21067@infradead.org>
References: <1383700043-32305-1-git-send-email-david@fromorbit.com>
	<1383700043-32305-37-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1383700043-32305-37-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Nov 06, 2013 at 12:07:22PM +1100, Dave Chinner wrote:
> +	if (!ag_stride && glob_agcount >= 16 && do_prefetch)
> +		ag_stride = 15;

Shouldn't we have a define for the agcount shared by mkfs and repair, and
derive the stride from it?

Otherwise looks fine.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
