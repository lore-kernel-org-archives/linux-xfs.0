Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 390B97FAF
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 10:40:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D3A58AC004
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 08:40:32 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id uT58zcgRyZhJ7LtY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 31 Oct 2013 08:40:31 -0700 (PDT)
Date: Thu, 31 Oct 2013 08:40:30 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: generic/317 use relative paths to avoid
	traversal permission problems
Message-ID: <20131031154030.GA6065@infradead.org>
References: <20131024161235.GA29381@infradead.org>
	<20131024162557.6dd72435@oracle.com>
	<20131025093333.GB24583@infradead.org>
	<20131028114328.4b05e0ee@oracle.com>
	<20131030161955.GA28755@infradead.org>
	<20131030162441.GA1112@infradead.org>
	<20131030143050.34a3b120@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131030143050.34a3b120@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 30, 2013 at 02:30:50PM -0400, Dwight Engen wrote:
> Yep, that makes sense. I modeled this on 219 which was using
> $here/src/lstat64 but didn't think about the fact that in my test fsgqa
> might have traversal problems. I see plenty of other tests are using
> relative paths so the following patch should (hopefully) fix 317 for you.
> Thanks for tracking it down.

Thanks, this fixes the problem for me.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
