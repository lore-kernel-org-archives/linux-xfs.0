Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 May 2008 13:18:05 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4JKI2x8007513
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 13:18:03 -0700
Received: from smtp7-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8D21316F2D80
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 13:18:51 -0700 (PDT)
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64]) by cuda.sgi.com with ESMTP id qYfdIiliKQe7CJeF for <xfs@oss.sgi.com>; Mon, 19 May 2008 13:18:51 -0700 (PDT)
Date: Mon, 19 May 2008 22:10:57 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS filesystem reports as full though it isn't
Message-ID: <20080519221057.75e0a775@galadriel.home>
In-Reply-To: <20080518154208.77b6be3e@galadriel.home>
References: <20080516222755.3e557c00@galadriel.home>
	<20080518131855.GA1383@infradead.org>
	<20080518132127.GA19006@infradead.org>
	<20080518154208.77b6be3e@galadriel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Le Sun, 18 May 2008 15:42:08 +0200 vous écriviez:

> IIRC I tried both, however I'll double check monday...

Well obviously I didn't try both, because it worked as expected when
using "inode64". However there'ssomething slightly weird in the data
layout:

/dev/dm-0:
AG     Inodes    IUsed    IFree    Use%
  0      4288     4277       11     99%
  1         0        0        0      0%
  2         0        0        0      0%
  3         0        0        0      0%
  4         0        0        0      0%
  5         0        0        0      0%
  6         0        0        0      0%
  7         0        0        0      0%
  8         0        0        0      0%
  9         0        0        0      0%
 10         0        0        0      0%
 11         0        0        0      0%
 12         0        0        0      0%
 13         0        0        0      0%
 14         0        0        0      0%
 15         0        0        0      0%
 16         0        0        0      0%
 17         0        0        0      0%
 18         0        0        0      0%
 19         0        0        0      0%
 20         0        0        0      0%
 21         0        0        0      0%
 22         0        0        0      0%
 23         0        0        0      0%
 24         0        0        0      0%
 25         0        0        0      0%
 26         0        0        0      0%
 27         0        0        0      0%
 28         0        0        0      0%
 29         0        0        0      0%
 30         0        0        0      0%
 31         0        0        0      0%
 32         0        0        0      0%
 33         0        0        0      0%
 34         0        0        0      0%
 35         0        0        0      0%
 36         0        0        0      0%
 37         0        0        0      0%
 38         0        0        0      0%
 39         0        0        0      0%
 40         0        0        0      0%
 41         0        0        0      0%
 42         0        0        0      0%
 43         0        0        0      0%
 44         0        0        0      0%
 45         0        0        0      0%
 46         0        0        0      0%
ALL      4288     4277       11     99%

See how all inodes are in the same vg? is it OK?

-- 
--------------------------------------------------
Emmanuel Florac               www.intellique.com   
--------------------------------------------------
