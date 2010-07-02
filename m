Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o62JZlEp255997 for <xfs@oss.sgi.com>; Fri, 2 Jul 2010 14:35:47 -0500
Subject: Re: [PATCH 09/15] xfs: rewrite XFS_SEND_NAMESP() as a function
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100629075855.GB31118@infradead.org>
References: <201006282205.o5SM5qNZ018194@stout.americas.sgi.com>
	<20100629075855.GB31118@infradead.org>
Date: Fri, 02 Jul 2010 14:37:46 -0500
Message-ID: <1278099466.1876.106.camel@doink>
Mime-Version: 1.0
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

On Tue, 2010-06-29 at 03:58 -0400, Christoph Hellwig wrote:
> A lot of arguments for the namesp even are always NULL or use
> defaults.  You'll make your life a simpler by just removing them.
> This also applies to some of the other dmapi callout, but it's most
> extreme here.
> 
I think I actually did that in later patches in the series,
by setting up a set of new interface routines, one per
event type, rather than multiplexing the namespace event
function for lots of other things.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
