Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p06I86EP099798 for <xfs@oss.sgi.com>; Thu, 6 Jan 2011 12:08:11 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C869DFAE710
	for <xfs@oss.sgi.com>; Thu,  6 Jan 2011 10:10:15 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id J6zxK4XmRD7lFldw for
	<xfs@oss.sgi.com>; Thu, 06 Jan 2011 10:10:15 -0800 (PST)
Date: Thu, 6 Jan 2011 13:10:15 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs: add FITRIM support
Message-ID: <20110106181014.GD32670@infradead.org>
References: <20101125112304.GA4195@infradead.org> <201101060910.34534@zmi.at>
	<20110106091707.GH8322@dastard> <201101061750.43556@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201101061750.43556@zmi.at>
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
Cc: Christoph Hellwig <hch@infradead.org>, Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

On Thu, Jan 06, 2011 at 05:50:42PM +0100, Michael Monnerie wrote:
> On Donnerstag, 6. Januar 2011 Dave Chinner wrote:
> > Realistically, we have
> > to design for how we expect devices to behave in 2-3 years time, not
> > waste time trying to optimise for fundamentally broken devices that
> > nobody will be using in 2-3 years time...
> 
> I see, thanks for the explanation. I hope that there will be a solution 
> that allows us to FITRIM on Saturday "in the background", so the thin 
> provisioned VMs are smaller and faster to back up. That's my immediate 
> wish, as we currently don't use SSDs.

That's what you can do with my FITRIM patches.  Right now the only
discard support known to me is my impementation that requires XFS as
backing store for the images.  And a hole punch of an existing hole
is very cheap in XFS, so trimming things multiple times is not an issue.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
