Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9DNuajT161476 for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 18:56:36 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6879D178223E
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 16:58:05 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id aPHGL9VgWFGd6zOa for
	<xfs@oss.sgi.com>; Tue, 13 Oct 2009 16:58:05 -0700 (PDT)
Date: Tue, 13 Oct 2009 19:58:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: fsetxattr() fails on a writable descriptor?
Message-ID: <20091013235805.GA18467@infradead.org>
References: <1251987642.3855.36.camel@dhcp-lab-219.englab.brq.redhat.com>
	<20090908184049.GA22050@infradead.org>
	<4AA81CDB.8070509@draigBrady.com> <200909100014.10833@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200909100014.10833@zmi.at>
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

On Thu, Sep 10, 2009 at 12:14:10AM +0200, Michael Monnerie wrote:
> On Mittwoch 09 September 2009 P?draig Brady wrote:
> > The specific issue we have is that `cp --preserve=xattr` gets an
> > error when copying xattrs from a read only file. Since this has been
> > an xattr issue since the start, we'll have to work around it.
> 
> In that context I would call it a bug - shouldn't it be fixed?

It seems pretty late for change behaviour that has been around
since 2002.  But if this was a new interface I would agree with you
that the behaviour is illogical.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
