Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8DG4w3a069422 for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 11:04:58 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8CD651C0A0B3
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 09:04:56 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	T0rgbTMACSQKLpNg for <xfs@oss.sgi.com>;
	Tue, 13 Sep 2011 09:04:56 -0700 (PDT)
Date: Tue, 13 Sep 2011 12:04:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Code Changes [Review Request]: xfs_trans_ail_delete() gets
	invoked with corrupted values ? Causing Crash and Deadlock.
Message-ID: <20110913160454.GA27569@infradead.org>
References: <CADDb1s0HwQtno3qWJd5CDriGD+m1EJ3fKihrRXuGmqayzwb_Pw@mail.gmail.com>
	<20110913152706.GB21460@infradead.org>
	<CADDb1s2=jHyef=5S6WNV+eLZKD1C3yJX4LzcPJhUAA1ohpAfqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADDb1s2=jHyef=5S6WNV+eLZKD1C3yJX4LzcPJhUAA1ohpAfqQ@mail.gmail.com>
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
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Sep 13, 2011 at 09:28:40PM +0530, Amit Sahrawat wrote:
> Yes, that was not the correct fix. But since I am getting that
> regularly I had to first get over that to avoid crash.

No problem.  I'm more than happy about any kind of analsys and debugging
I get.

> The changes you have mentioned below seems appropriate- I will check
> and update you more on this by tomorrow.
> But I tried to this flushing as part of xlog_dealloc_log - it didn't
> work over there  - i will confirm this.

Hmm.  In that case this one might not work either, but I'd love to
see your results.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
