Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8MK3ea4214397 for <xfs@oss.sgi.com>; Tue, 22 Sep 2009 15:03:52 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D871A131EEC2
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2009 13:04:57 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Q4OwCELe7zTTFD51 for
	<xfs@oss.sgi.com>; Tue, 22 Sep 2009 13:04:57 -0700 (PDT)
Date: Tue, 22 Sep 2009 16:04:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] xfs_repair: fix record_allocation list manipulation
Message-ID: <20090922200456.GA28826@infradead.org>
References: <4AB300CC.5020707@sandeen.net> <4AB4EDBC.9050609@sandeen.net>
	<20090922120231.GB8143@infradead.org> <4AB8EB80.80707@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4AB8EB80.80707@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Tue, Sep 22, 2009 at 10:21:36AM -0500, Eric Sandeen wrote:
> > After reviewing it again I noticed that it can actually work 
> 
> the original code can work?

Well, could in theory if fixed as in your patch ;-)

> IF barry's speedups stuff obsoletes this work should I just put it on
> the shelf for now?

No, it doesn't.  As I mentioned his original patches contained a fix
like yours, but I left it out because I didn't understand it yet.

I think the patch will cause some minor merge pain as it touches
incore.c which gets more or less fully rewritten as part of the
patch series.  I think it's useful enough to be put in, but so are
the other repair patches :)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
