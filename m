Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KG2XOY069479 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 11:02:33 -0500
Date: Tue, 20 Sep 2011 12:02:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs deadlock in stable kernel 3.0.4
Message-ID: <20110920160226.GA25542@infradead.org>
References: <C6515E45-5724-43DD-95A8-1F89AFE29601@profihost.ag>
	<20110912200543.GA22409@infradead.org>
	<4E6EF274.7050007@profihost.ag>
	<20110913205018.GA8543@infradead.org> <4E70571A.80108@profihost.ag>
	<4E705C42.6020909@profihost.ag>
	<20110914143005.GA28496@infradead.org>
	<4E75B660.1030502@profihost.ag> <20110918230245.GF15688@dastard>
	<4E78665E.8030409@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E78665E.8030409@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, aelder@sgi.com

On Tue, Sep 20, 2011 at 12:09:34PM +0200, Stefan Priebe - Profihost AG wrote:
> Hi,
> 
> any idea how to get deeper into this? I've tried using kgdb but
> strangely the error does not occur when kgdb is remote attached.
> When i unattach kgdb and restart bonnie the error happens again.
> 
> So it seems to me a little bit like a timing issue?

Sounds like it.

Can you summarize all the data that we gather over this thread into one
summary, e.g.

 - what kernel does it happens?  Seems like 3.0 and 3.1 hit it easily,
   2.6.38 some times, 2.6.32 is fine.  Did you test anything between
   2.6.32 and 2.6.38?
 - what hardware hits it often/sometimes/never?
 - what is the fs geometry?
 - what is the hardware?
 - is this a 32 or 64-bit kernel, or do you run both?

I'm pretty sure most got posted somewhere, but let's get a summary
as things was a bit confusing sometimes.

Note that 2.6.38 moved the whole log grant code to a lockless algorithm,
so this might be a likely culprit if you're managing to hit race windows
no one else does, i.e. this really is a timing issue.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
