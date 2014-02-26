Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F3DDF7F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 20:15:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 891C4AC002
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 18:15:26 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id wzOoMjf2uEcwUAHl (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 18:15:25 -0800 (PST)
Date: Tue, 25 Feb 2014 18:15:25 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [RFC] xfs: byte range buffer dirty region tracking
Message-ID: <20140226021525.GB26022@infradead.org>
References: <1393194354-12780-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1393194354-12780-1-git-send-email-david@fromorbit.com>
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

Interesting.  I had a prototype of this supporting just a single
region a while ago, but never managed to get it to pass all recovery
tests.  That was before I separated the in-core from the on-disk
log items, though.

> Hence if we just track a signle region, it will almost always cover
> the entire directory buffer - if we only modify a single entry in
> the buffer, then that's a fairly large cost in terms of log space
> and CPU overhead for random individual operations. If we decide that
> we are going to use a single range, then we may as well just use the
> dirty flag and log the entire buffer every time.

Which might not be an all that bad idea given how much log bandwith
we have available.  Defintively would be interesting to instrument
and benchmark it vs the 4 regions version.

Note that we probably should also introduce a log incompat feature to
just log the range instead of converting it to the old bitmap for v5
filesystems.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
