Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6O8iq2G254745 for <xfs@oss.sgi.com>; Sat, 24 Jul 2010 03:44:54 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 22CD0C25A7F
	for <xfs@oss.sgi.com>; Sat, 24 Jul 2010 01:54:57 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id xJFISB6RR6xt9Zkf for
	<xfs@oss.sgi.com>; Sat, 24 Jul 2010 01:54:57 -0700 (PDT)
Date: Sat, 24 Jul 2010 04:47:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 4k sector drives
Message-ID: <20100724084751.GA32006@infradead.org>
References: <201007211333.48363.eye.of.the.8eholder@gmail.com>
	<201007230809.28111@zmi.at> <20100723095832.GA23174@infradead.org>
	<201007231259.11714@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201007231259.11714@zmi.at>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Jul 23, 2010 at 12:59:07PM +0200, Michael Monnerie wrote:
> On Freitag, 23. Juli 2010 Christoph Hellwig wrote:
> > -b size=4096 is the default anyway, for 4k sector drivers you also
> >  want -s size=4096, which you do not want for 512 byte sector disks.
> 
> Thanks for clarification. Should I use "-s size=4096" despite the drive 
> saying 512b sectors? It's a "hidden" 4K sector drive, so maybe declaring 
> it extra for XFS helps performance? Or does it not matter at all?

If it really is one using -s size=4096 is the right thing to do.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
