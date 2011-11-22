Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAMANbBR136003 for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 04:23:38 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F7D91393DBE
	for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 02:23:34 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	dWtrRCQKtIeF9L1K for <xfs@oss.sgi.com>;
	Tue, 22 Nov 2011 02:23:34 -0800 (PST)
Date: Tue, 22 Nov 2011 05:23:31 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Remove the entries from the queue while waking them
	up.
Message-ID: <20111122102331.GA32485@infradead.org>
References: <1321644054.2201.80.camel@chandra-lucid.austin.ibm.com>
	<20111119181929.GA25739@infradead.org>
	<1321902701.2201.141.camel@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1321902701.2201.141.camel@chandra-lucid.austin.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, XFS Mailing List <xfs@oss.sgi.com>

On Mon, Nov 21, 2011 at 01:11:41PM -0600, Chandra Seetharaman wrote:
> The code does not assume that it got the space when it wakes up. After
> every wake up it does check for free bytes available and compares to
> required bytes before granting the bytes to itself. (IOW, after waking
> up it behaves the same way as the lock-less case)
> 
> As Dave pointed, I can see only the signal case to be effecting this
> scenario. With that case in mind, I can see one change required to my
> patch: Add the ticket to the list the second time (in a function) only
> if the t_queue is not empty.

You can still leak with the process added to the queue if you get a
wakeup and there is space available.  And your second patch now has
to re-add conditional add to queue band aids that the first one so
nicely removed.  My version of that patch has the big advantage of
actually making the whole scheme mirror that of a wait queue.  In fact
we could use workqueues and the helpers for it later (except for the
waker side, which is special).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
