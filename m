Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7I2h3Fp107936 for <xfs@oss.sgi.com>; Mon, 17 Aug 2009 21:43:20 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AEE051074C31
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2009 19:43:51 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id NG79a4mu2wKECbtk for
	<xfs@oss.sgi.com>; Mon, 17 Aug 2009 19:43:51 -0700 (PDT)
Date: Mon, 17 Aug 2009 22:43:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: disk performance strange/low
Message-ID: <20090818024350.GA3591@infradead.org>
References: <200908172311.07660@zmi.at> <20090817214136.GA26060@infradead.org>
	<200908180408.10738@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200908180408.10738@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Tue, Aug 18, 2009 at 04:08:05AM +0200, Michael Monnerie wrote:
> On Montag 17 August 2009 Christoph Hellwig wrote:
> > Yes, that sounds like the problem of the VM not feeding us enough
> > pages to write. ?What kernel is this on? ?Latest 2.6.31-rc has a
> > workaround for it.
> 
> 2.6.27.23-0.1-xen from openSUSE 11.1
> I can't switch as I use it with the free Xen. Thanks for the info.

Try backporting commit c8a4051c3731b6db224482218cfd535ab9393ff8 from
mainline - it should apply just fine to a 2.6.27-ish kernel.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
