Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1FIMRDV087586 for <xfs@oss.sgi.com>; Sun, 15 Feb 2009 12:22:28 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A2A90193EE2B
	for <xfs@oss.sgi.com>; Sun, 15 Feb 2009 10:21:53 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 9RpT4DCgmyB3DeKB for
	<xfs@oss.sgi.com>; Sun, 15 Feb 2009 10:21:53 -0800 (PST)
Date: Sun, 15 Feb 2009 13:21:53 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: add "quick" group
Message-ID: <20090215182153.GA31179@infradead.org>
References: <20090214164245.GD19813@infradead.org>
	<49972260.4000702@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49972260.4000702@sandeen.net>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sat, Feb 14, 2009 at 01:58:24PM -0600, Eric Sandeen wrote:
> Good plan, couple comments:
> 
> should quick only be a subset auto tests or are they orthogonal?

Just a subset of auto, yes.

> A few tests you've flagged as quick don't met the 20s criteria on my
> box, just FWIW; may be filesystem-size specific:
> 
> 013 57

We need this one for sure.

> 028 23
> 031 21
> 049 36
> 075 36
> 076 56
> 078 20
> 091 26
> 112 38
> 113 55
> 178 363
> 
> Most are probably close enough, but 178 looks nasty - seems to be
> xfs_repair that's taking so long.  These are running on 100G partitions,
> though :)

178 only takes 16 seconds for me, running on 10G partitions.

I'm fine removing tests, and 178 would be the first candidate, maybe 076
and 113, too.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
