Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 77CCE7F37
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 04:27:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 597E9304032
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 02:27:55 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id bR7CN7WmMiodEhI6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 14 Dec 2015 02:27:54 -0800 (PST)
Date: Mon, 14 Dec 2015 02:27:50 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS and nobarrier with SSDs
Message-ID: <20151214102750.GA29192@infradead.org>
References: <E127700EFE58FD45BD6298EAC813FA42020D8173@TIGER2010.xortex.local>
	<3496214.YTSKClH6pV@merkaba> <566E6524.6070401@xortex.com>
	<3911767.qVqsL1TcMv@merkaba> <20151214095823.GA30662@infradead.org>
	<566E978E.2070502@xortex.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <566E978E.2070502@xortex.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Georg Sch?nberger <g.schoenberger@xortex.com>
Cc: Jens Axboe <axboe@kernel.dk>, Linux Block mailing list <linux-block@vger.kernel.org>, XFS mailing list <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>, Linux FS-Devel <linux-fsdevel@vger.kernel.org>

On Mon, Dec 14, 2015 at 10:18:54AM +0000, Georg Sch?nberger wrote:
> > Or to phrase it
> > differently:  If nobarrier makes a difference skipping it is not safe.
> I do not fully understand that sentence, what do you mean by "makes a 
> difference" and "skipping is not safe"?

The rule of thumb is: if nobarrier makes your workload run faster you
should not be using it, aka: don't use it. 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
