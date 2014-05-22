Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2E2577F3F
	for <xfs@oss.sgi.com>; Thu, 22 May 2014 05:01:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1CFA08F8033
	for <xfs@oss.sgi.com>; Thu, 22 May 2014 03:01:43 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 8nu3iLoAF0BdM2oe (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 22 May 2014 03:01:41 -0700 (PDT)
Date: Thu, 22 May 2014 03:01:34 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] [XFS] indent an if statement
Message-ID: <20140522100134.GA23071@infradead.org>
References: <20140521122746.GD23396@mwanda>
	<20140521142909.GA22281@infradead.org>
	<20140521143550.GC15585@mwanda> <537CD96D.2090901@bfs.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <537CD96D.2090901@bfs.de>
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
To: walter harms <wharms@bfs.de>
Cc: Christoph Hellwig <hch@infradead.org>, kernel-janitors@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>, xfs@oss.sgi.com

On Wed, May 21, 2014 at 06:50:53PM +0200, walter harms wrote:
> This looks like a ffsll() maybe there are other implemantions and we can
> make a generic version (acualy i found only a ffsll() in nouvou, NTL).

All the helper in xfs_bit.[ch] are probably candidates for generic
library functions.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
