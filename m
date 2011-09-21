Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LDgWQq145976 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 08:42:32 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 096E21C2ECF3
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 06:42:31 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id FXyCAT1VXGWKojE9
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 06:42:31 -0700 (PDT)
References: <20110918230245.GF15688@dastard> <4E78665E.8030409@profihost.ag>
	<20110920160226.GA25542@infradead.org>
	<4E78CBF4.1030505@profihost.ag>
	<20110920172455.GA30757@infradead.org>
	<4E78CEFD.9030603@profihost.ag>
	<20110920223047.GA13758@infradead.org>
	<20110921021133.GM15688@dastard> <4E7994D3.5020103@profihost.ag>
	<20110921114237.GP15688@dastard>
	<20110921122649.GA16602@infradead.org>
In-Reply-To: <20110921122649.GA16602@infradead.org>
Mime-Version: 1.0 (iPhone Mail 8H7)
Message-Id: <7FDA3158-73EB-412F-86EC-C7E9CECBDE6B@profihost.ag>
From: Stefan Priebe <s.priebe@profihost.ag>
Subject: Re: [xfs-masters] xfs deadlock in stable kernel 3.0.4
Date: Wed, 21 Sep 2011 15:42:22 +0200
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
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Am 21.09.2011 um 14:26 schrieb Christoph Hellwig <hch@infradead.org>:
> What is also strange is that we allocate a xfs_ail_wq, but don't
> actually use it, although it would have the same idea.  Stefan,
> can you try the following patch?  This moves the ail work to it's
> explicit queue, and makes sure we never have the same work item
> (= same fs to be pushed) concurrently.
I will have the chance to test in a few hours again. Perhaps  can test too?

Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
