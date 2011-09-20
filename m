Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KA9dmq052114 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 05:09:39 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A20291400E76
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 03:14:54 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id joQNW8fQIiIGQGMq
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 03:14:54 -0700 (PDT)
Message-ID: <4E78665E.8030409@profihost.ag>
Date: Tue, 20 Sep 2011 12:09:34 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: xfs deadlock in stable kernel 3.0.4
References: <1D2B34A7-7BB9-4E4E-9CA2-382C210E125F@profihost.ag>
	<20110912152133.GA8345@infradead.org>
	<C6515E45-5724-43DD-95A8-1F89AFE29601@profihost.ag>
	<20110912200543.GA22409@infradead.org>
	<4E6EF274.7050007@profihost.ag>
	<20110913205018.GA8543@infradead.org>
	<4E70571A.80108@profihost.ag> <4E705C42.6020909@profihost.ag>
	<20110914143005.GA28496@infradead.org>
	<4E75B660.1030502@profihost.ag> <20110918230245.GF15688@dastard>
In-Reply-To: <20110918230245.GF15688@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, aelder@sgi.com

Hi,

any idea how to get deeper into this? I've tried using kgdb but 
strangely the error does not occur when kgdb is remote attached. When i 
unattach kgdb and restart bonnie the error happens again.

So it seems to me a little bit like a timing issue?

Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
