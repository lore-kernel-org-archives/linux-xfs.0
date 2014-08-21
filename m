Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BEC4C7F51
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 12:44:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ACCE08F8037
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 10:44:16 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 1HWtbwIeC8kHFIqV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 21 Aug 2014 10:44:15 -0700 (PDT)
Date: Thu, 21 Aug 2014 10:44:14 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: use abort() not ASSERT(0) for impossible
	switch case
Message-ID: <20140821174414.GA28860@infradead.org>
References: <53F62D12.8010505@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53F62D12.8010505@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Aug 21, 2014 at 12:32:02PM -0500, Eric Sandeen wrote:
> The original reason for the expletive below has been lost
> in the mists of time, but at any rate, ASSERT() goes away in
> libxfs, and this leads static analysis checkers to believe that
> XFS_BTNUM_MAX is possible, and that we might overflow an array
> later when using it as an index.
> 
> We can shut this up and mark it as truly impossible with abort().

This won't work in kernel space, and we'd like to keep this file in sync.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
