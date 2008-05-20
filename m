Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 May 2008 03:16:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4KAGfP8028862
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 03:16:43 -0700
Received: from smtp8-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B9EABA084F
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 03:17:31 -0700 (PDT)
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65]) by cuda.sgi.com with ESMTP id wOIXvfhOwxTrCnsP for <xfs@oss.sgi.com>; Tue, 20 May 2008 03:17:31 -0700 (PDT)
Date: Tue, 20 May 2008 12:17:33 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS filesystem reports as full though it isn't
Message-ID: <20080520121733.4b528256@harpe.intellique.com>
In-Reply-To: <20080520061047.GP103491721@sgi.com>
References: <20080516222755.3e557c00@galadriel.home>
	<20080518131855.GA1383@infradead.org>
	<20080518132127.GA19006@infradead.org>
	<20080518154208.77b6be3e@galadriel.home>
	<20080519221057.75e0a775@galadriel.home>
	<20080520061047.GP103491721@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Le Tue, 20 May 2008 16:10:47 +1000
David Chinner <dgc@sgi.com> écrivait:

> If there's no free space in AGs > 0 when you enable inode64, then
> you will still get enospc...
> 
> > See how all inodes are in the same vg? is it OK?  
>                                      ^^ AG
> 
> This is typical of inode32 allocation...

OK. I've mounted it "inode64" and apparently it worked fine. I
started copying 6 more TB of data, I'll check how it goes this
afternoon.

-- 
----------------------------------------
Emmanuel Florac     |   Intellique
----------------------------------------
