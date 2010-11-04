Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA4CnTuL146066 for <xfs@oss.sgi.com>; Thu, 4 Nov 2010 07:49:30 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D0C3C1600540
	for <xfs@oss.sgi.com>; Thu,  4 Nov 2010 06:07:14 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id GGUcGd4YhBmCsZS7 for
	<xfs@oss.sgi.com>; Thu, 04 Nov 2010 06:07:14 -0700 (PDT)
Date: Thu, 4 Nov 2010 08:50:52 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS mounting fails on MIPS
Message-ID: <20101104125052.GA22429@infradead.org>
References: <AANLkTi=mLwQ0N_cErHzES1ZWvOa8jQspeYwKgn9sU4Jm@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTi=mLwQ0N_cErHzES1ZWvOa8jQspeYwKgn9sU4Jm@mail.gmail.com>
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
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Nov 04, 2010 at 11:27:24AM +0530, Ajeet Yadav wrote:
> Linux XFS version : 2.6.34
> Architecure: MIPS
> I am getting the following error during mount.

Is this the same mips system that you have the vmap aliasing problems
during log recovery with?

As long as that is not fixed I would deeply distrust any callchain
from the recovery code like this one.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
