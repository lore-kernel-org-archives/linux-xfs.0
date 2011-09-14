Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8EEU9dG145402 for <xfs@oss.sgi.com>; Wed, 14 Sep 2011 09:30:09 -0500
Date: Wed, 14 Sep 2011 10:30:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs deadlock in stable kernel 3.0.4
Message-ID: <20110914143005.GA28496@infradead.org>
References: <1D2B34A7-7BB9-4E4E-9CA2-382C210E125F@profihost.ag>
	<20110912152133.GA8345@infradead.org>
	<C6515E45-5724-43DD-95A8-1F89AFE29601@profihost.ag>
	<20110912200543.GA22409@infradead.org>
	<4E6EF274.7050007@profihost.ag>
	<20110913205018.GA8543@infradead.org> <4E70571A.80108@profihost.ag>
	<4E705C42.6020909@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E705C42.6020909@profihost.ag>
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

On Wed, Sep 14, 2011 at 09:48:18AM +0200, Stefan Priebe - Profihost AG wrote:
> #0: (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [] do_last+0x287/0x693

This means you are running your heavy load with lockdep enabled.  I
can't see how it directly causes your issues, but it will slow anything
down to almost a grinding halt on systems with more than say two cores.

Can you run with CONFIG_DEBUG_LOCK_ALLOC / and CONFIG_PROVE_LOCKING
disabled/  It might be worth if you have other really heavy debugging
options enabled, too.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
