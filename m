Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBV2uIla024223 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 20:56:18 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E03771799D9B
	for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 18:56:16 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id ZtYV5h5FjOnM3t7f for
	<xfs@oss.sgi.com>; Tue, 30 Dec 2008 18:56:16 -0800 (PST)
Message-ID: <495ADF2D.8050709@sandeen.net>
Date: Tue, 30 Dec 2008 20:55:41 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 3/5] xfstests: test 195, add a testcase for the nodump flag
References: <20081230230810.986105000@bombadil.infradead.org>
	<20081230230913.302710000@bombadil.infradead.org>
In-Reply-To: <20081230230913.302710000@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:

> Based on http://oss.sgi.com/bugzilla/show_bug.cgi?id=340.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfstests/195

...

> +_do_dump()
> +{
> +	xfsdump -l 0 -s d -F  \
> +		-L prova -M prova \
> +		-f $TEST_DIR/dumpfile -e -v excluded_files=debug $TEST_DIR \
> +		| grep "ino $inum" \
> +		| sed -e 's/xfsdump: pruned ino [0-9]*, owner 0, estimated size 0: skip flag set/xfsdump: pruned ino NNN, owner 0, estimated size 0: skip flag set/'
> +}

That's a bigger pattern than I'd have matched but as far as bike sheds
go, looks good to me :)

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
