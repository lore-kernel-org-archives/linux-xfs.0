Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LJ1FHI167988 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 14:01:16 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A0A0F1406069
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 12:06:38 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id hfNHpvPBeYsREAV1
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 12:06:38 -0700 (PDT)
Message-ID: <4E7A3478.90505@profihost.ag>
Date: Wed, 21 Sep 2011 21:01:12 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: [xfs-masters] xfs deadlock in stable kernel 3.0.4
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
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Am 21.09.2011 14:26, schrieb Christoph Hellwig:
> What is also strange is that we allocate a xfs_ail_wq, but don't
> actually use it, although it would have the same idea.  Stefan,
> can you try the following patch?  This moves the ail work to it's
> explicit queue, and makes sure we never have the same work item
> (= same fs to be pushed) concurrently.

no luck - problem still occurs ;-(

Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
