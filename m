Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8N5STD0044540 for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 00:28:30 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 213AD1411198
	for <xfs@oss.sgi.com>; Thu, 22 Sep 2011 22:34:00 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id oyue1CzhRO5SDHTE
	for <xfs@oss.sgi.com>; Thu, 22 Sep 2011 22:34:00 -0700 (PDT)
Message-ID: <4E7C18F9.3020007@profihost.ag>
Date: Fri, 23 Sep 2011 07:28:25 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: [xfs-masters] xfs deadlock in stable kernel 3.0.4
References: <20110920172455.GA30757@infradead.org>
	<4E78CEFD.9030603@profihost.ag>
	<20110920223047.GA13758@infradead.org>
	<20110921021133.GM15688@dastard> <4E7994D3.5020103@profihost.ag>
	<20110921114237.GP15688@dastard>
	<20110921122649.GA16602@infradead.org>
	<20110921230718.GS15688@dastard>
	<20110922141457.GA11929@infradead.org>
	<20110922214956.GX15688@dastard>
	<20110922220151.GA21701@infradead.org>
In-Reply-To: <20110922220151.GA21701@infradead.org>
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

Hi,

you can faster reproduce the issue if you set elevator=noop when 
booting. It then happens always on the 1st run of deleting random files.

@Dave:
Were you able to reproduce it too?

Greets
Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
