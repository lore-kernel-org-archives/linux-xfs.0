Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8743B7F7B
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 12:19:02 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5F823304064
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 10:19:02 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id avjdA8FQz1BmgQGk for <xfs@oss.sgi.com>;
	Tue, 12 Nov 2013 10:19:01 -0800 (PST)
Message-ID: <52827113.3080609@sandeen.net>
Date: Tue, 12 Nov 2013 12:18:59 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: stop special casing nfs and udf
References: <20131107204635.GA22954@infradead.org>
In-Reply-To: <20131107204635.GA22954@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On 11/7/13, 2:46 PM, Christoph Hellwig wrote:
> For historical reasons beyond my knowledge xfstests tries to abuse the
> scratch device as test device for nfs and udf.  Because not all test
> have inherited the right usage of the _setup_testdir and _cleanup_testdir
> helpers this leads to lots of unessecary test failures.
> 
> Remove the special casing, which gets nfs down to a minimal number of
> failures.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>


Oof, that was a lot of cruft.  Were you able to run UDF tests with
these changes?  I wonder if Jan is using this for UDF?

(I don't have the UDF verifier that many(/all?) of the UDF tests
require).

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
