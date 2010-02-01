Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o11B0lHk102574 for <xfs@oss.sgi.com>; Mon, 1 Feb 2010 05:00:54 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BE5C813695CC
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2010 03:01:55 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id WHxJ1kckxRg7Fq0O for
	<xfs@oss.sgi.com>; Mon, 01 Feb 2010 03:01:55 -0800 (PST)
Date: Mon, 1 Feb 2010 06:01:54 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 2/2] xfs: use scalable vmap API
Message-ID: <20100201110153.GA588@infradead.org>
References: <20081021082735.GB6974@wotan.suse.de>
	<20081021120932.GB13348@infradead.org>
	<20081022093018.GD4359@wotan.suse.de>
	<20100119121505.GA9428@infradead.org>
	<20100125075445.GD19664@laptop>
	<20100125081750.GA20012@infradead.org>
	<20100125083309.GF19664@laptop> <20100125123746.GA24406@laptop>
	<20100125213403.GA1309@infradead.org>
	<20100127083819.GA11072@laptop>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100127083819.GA11072@laptop>
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
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, xfs@oss.sgi.com

On Wed, Jan 27, 2010 at 07:38:19PM +1100, Nick Piggin wrote:
> > So far I've not run out of vmalloc space yet with quite a few xfstests
> > iterations and not encountered any other problems either.
> > 
> > Thanks for looking into this!
> 
> OK thanks for testing. I'll send it upstream if you haven't had any
> problems so far.

Still working fine, so please send it upstream ASAP.  That'll make
re-eabling the scalable vmap API in XFS much more easier for 2.6.34.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
