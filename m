Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8EEUNdm145442 for <xfs@oss.sgi.com>; Wed, 14 Sep 2011 09:30:23 -0500
Date: Wed, 14 Sep 2011 10:30:21 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs deadlock in stable kernel 3.0.4
Message-ID: <20110914143021.GB28496@infradead.org>
References: <1D2B34A7-7BB9-4E4E-9CA2-382C210E125F@profihost.ag>
	<20110912152133.GA8345@infradead.org>
	<C6515E45-5724-43DD-95A8-1F89AFE29601@profihost.ag>
	<20110912200543.GA22409@infradead.org>
	<4E6EF274.7050007@profihost.ag>
	<20110913205018.GA8543@infradead.org> <4E70571A.80108@profihost.ag>
	<4E705C42.6020909@profihost.ag> <4E706A90.9080200@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E706A90.9080200@profihost.ag>
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

On Wed, Sep 14, 2011 at 10:49:20AM +0200, Stefan Priebe - Profihost AG wrote:
> >Sadly it was now crashing with 3.1 rc-6 + patch again. Sorry i was to
> >fast to write you an email.
> 
> So might it be that the problem at least in 3.1 lies in:
> [] ? mark_held_locks+0xc9/0xef
> [] ? _raw_spin_unlock_irqrestore+0x3f/0x47
> 
> and not in XFS?

That's the lockdep code.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
