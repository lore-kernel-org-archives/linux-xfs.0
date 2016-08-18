Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 93CC87CA1
	for <xfs@oss.sgi.com>; Thu, 18 Aug 2016 12:45:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 544D8304053
	for <xfs@oss.sgi.com>; Thu, 18 Aug 2016 10:45:14 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id rX94gjc127K7jNVd (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 18 Aug 2016 10:45:12 -0700 (PDT)
Date: Thu, 18 Aug 2016 10:45:11 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHv2 xfsprogs 13/14] xfs.h: require transparent LFS for all
	users
Message-ID: <20160818174511.GM27799@infradead.org>
References: <cover.1471107858.git.felix.janda@posteo.de>
	<663326cb534467d534360d23acb02dc535caa909.1471107858.git.felix.janda@posteo.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <663326cb534467d534360d23acb02dc535caa909.1471107858.git.felix.janda@posteo.de>
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
To: Felix Janda <felix.janda@posteo.de>
Cc: xfs@oss.sgi.com

On Sat, Aug 13, 2016 at 06:03:16PM +0200, Felix Janda wrote:
> Since our interfaces depend on the consistent use of a 64bit offset
> type, force downstreams to use transparent LFS (_FILE_OFFSET_BITS=64),
> so that it becomes impossible for them to use 32bit interfaces.
> 
> Signed-off-by: Felix Janda <felix.janda@posteo.de>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
