Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9DAZAaw166124 for <xfs@oss.sgi.com>; Thu, 13 Oct 2011 05:35:11 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6FC0315306FD
	for <xfs@oss.sgi.com>; Thu, 13 Oct 2011 03:42:36 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	E7uWByAQ5F2nhhj1 for <xfs@oss.sgi.com>;
	Thu, 13 Oct 2011 03:42:36 -0700 (PDT)
Date: Thu, 13 Oct 2011 06:35:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Help with xfs and Fedora 8
Message-ID: <20111013103504.GA16466@infradead.org>
References: <CADDFK--585nmGJMuVhbhyO5S7tvCxR0Ur_1qxX73AvpAgau8Ew@mail.gmail.com>
	<20111012231424.GK3159@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111012231424.GK3159@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Ram Natarajan <ram@arohisystems.com>, xfs@oss.sgi.com

On Thu, Oct 13, 2011 at 10:14:24AM +1100, Dave Chinner wrote:
> > For various technical reasons, I cannot move to a
> > later kernel, but it would be great if I can build the latest xfs modules
> > and xfs support code for 2.6.23. Does anybody know if this is possible, and
> > if it is possible, will it work reliably?
> 
> The kernel code is not so simple. Indeed, if you're not a kernel
> programmer and familiar with the XFS code, then I'd put it in the
> impossible basket. It'll take at least 3 months to do the backport
> and adequately test it for production use, and that's if you pay an
> expert to do it.
> 
> It's far, far simpler to just upgrade your machines to a more recent
> distribution that it is to backport code to kernels that old....

Indeed.  If you insist on an old kernel version with a semi recent XFS
please get a RHEL/Centos 5 kernel.  That one is actually labelled 2.6.18
but contains many fixes and updated components, including a relatively
new XFS codebase.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
