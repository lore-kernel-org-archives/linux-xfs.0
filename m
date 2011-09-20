Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KHN7DS072651 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 12:23:07 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 11098175D59
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 10:23:05 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id NqIaWgdyDIB2ejn3
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 10:23:05 -0700 (PDT)
Message-ID: <4E78CBF4.1030505@profihost.ag>
Date: Tue, 20 Sep 2011 19:23:00 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: xfs deadlock in stable kernel 3.0.4
References: <C6515E45-5724-43DD-95A8-1F89AFE29601@profihost.ag>
	<20110912200543.GA22409@infradead.org>
	<4E6EF274.7050007@profihost.ag>
	<20110913205018.GA8543@infradead.org>
	<4E70571A.80108@profihost.ag> <4E705C42.6020909@profihost.ag>
	<20110914143005.GA28496@infradead.org>
	<4E75B660.1030502@profihost.ag> <20110918230245.GF15688@dastard>
	<4E78665E.8030409@profihost.ag>
	<20110920160226.GA25542@infradead.org>
In-Reply-To: <20110920160226.GA25542@infradead.org>
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
Cc: "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, aelder@sgi.com

> Can you summarize all the data that we gather over this thread into one
> summary, e.g.
Yes - hope it helps.

>   - what kernel does it happens?  Seems like 3.0 and 3.1 hit it easily,
>     2.6.38 some times, 2.6.32 is fine.  Did you test anything between
>     2.6.32 and 2.6.38?
Hits very easily: 3.0.4 and 3.1-rc5
Very rare: 2.6.38 - as it happened only some times i cannot 100% 
guarantee that it is really the same issue
No issues at all: 2.6.32

I've not tested anything between 2.6.32 as i cannot reproduce it under 
2.6.38 at all - seen once a week of 500.

>   - what hardware hits it often/sometimes/never?
I've seen this only on multi core CPUs with > 2.8Ghz and fast SAS Raid 
10 or SSD. I cannot say if it's the CPU or the fast disks - as our low 
cost systems have only small CPUs and the high end ones have big cpus 
with fast disks.

>   - what is the fs geometry?
What do you exactly mean? I've seen this on 1TB and 160GB SSD devices 
with totally different disk layout.

>   - what is the hardware?
see above

>   - is this a 32 or 64-bit kernel, or do you run both?
always 64bit

> I'm pretty sure most got posted somewhere, but let's get a summary
> as things was a bit confusing sometimes.
no problem

> Note that 2.6.38 moved the whole log grant code to a lockless algorithm,
> so this might be a likely culprit if you're managing to hit race windows
> no one else does, i.e. this really is a timing issue.
I'm nearly willing todo anything to solve this. What can i do to help. 
My last hope from today was to get some code lines with kgdb - sadly it 
does not happen at all when kgdb is attached ;-(

Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
