Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3DIAW6d253385 for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 13:10:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2619D12FB592
	for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 11:12:26 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 1Wqi0X5eEDXXY1J1 for
	<xfs@oss.sgi.com>; Tue, 13 Apr 2010 11:12:26 -0700 (PDT)
Date: Tue, 13 Apr 2010 14:12:25 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/8] xfs: make the log ticket transaction id random
Message-ID: <20100413181225.GB5043@infradead.org>
References: <1270125691-29266-1-git-send-email-david@fromorbit.com>
	<1270125691-29266-4-git-send-email-david@fromorbit.com>
	<20100403093156.GD20166@infradead.org>
	<20100405233910.GA11036@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100405233910.GA11036@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Apr 06, 2010 at 09:39:10AM +1000, Dave Chinner wrote:
> Ideally, yes. However, I didn't want to introduce a global
> monatomically increasing counter into the transaction code. I'm
> seeing upwards of 50-60k transactions/s on my test box - that's
> getting into the range where reliable global counters become
> scalability limitations. I know this can be solved, but it is
> somewhat complex and I'm not sure at this point that the complexity
> is necessary. What do you think?

I think making log revoery absolutely fail proof is nessecary, but for
now your version defintively is an improvment over the current version,
so ACK.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
