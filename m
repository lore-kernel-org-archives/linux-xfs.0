Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p66E5SFj126834 for <xfs@oss.sgi.com>; Wed, 6 Jul 2011 09:05:28 -0500
Subject: Re: [PATCH 07/27] xfs: split xfs_itruncate_finish
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110706081138.GA5361@infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094603.580931463@bombadil.infradead.org>
	<1309926958.3381.61.camel@doink> <20110706081138.GA5361@infradead.org>
Date: Wed, 6 Jul 2011 09:05:24 -0500
Message-ID: <1309961124.1931.13.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, 2011-07-06 at 04:11 -0400, Christoph Hellwig wrote:
> On Tue, Jul 05, 2011 at 11:35:58PM -0500, Alex Elder wrote:
> > The above comment (if true--I haven't really checked) seems
> > like something significant to preserve.
> 
> The comment at the goto label already catches the important bits of it.

I was referring to this:

    Aborting from this point might lose some blocks in
    the file system, but oh well.

I don't actually understand what the comment means, but if
you feel it isn't important that's fine.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
