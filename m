Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8MGhosk244390 for <xfs@oss.sgi.com>; Thu, 22 Sep 2011 11:43:51 -0500
Date: Thu, 22 Sep 2011 12:43:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsdump: enable dump header checksums
Message-ID: <20110922164347.GA8686@infradead.org>
References: <1314654106-28548-1-git-send-email-wkendall@sgi.com>
	<1316463141.2941.75.camel@doink> <4E77DBB9.7060400@sgi.com>
	<1316537740.2912.25.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1316537740.2912.25.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 20, 2011 at 11:55:40AM -0500, Alex Elder wrote:
> On Mon, 2011-09-19 at 19:18 -0500, Bill Kendall wrote:
> > On 09/19/2011 03:12 PM, Alex Elder wrote:
> . . .
> > > The theory in doing this unconditionally is that we might as
> > > well record it, even if the restore program chooses to ignore
> > > it, right?
> > 
> > Right. (You probably noticed this also changes restore to
> > unconditionally verify the checksum, provided the flags
> > indicate the checksum was recorded.)
> 
> It *might* be nice to have an option to ignore the
> checksum on restore.  I don't know though.  I was
> thinking it might be useful if whatever dumped the
> data did a buggy checksum but, well, we have no
> evidence that xfsdump has ever done that.

I think we really want this option before cutting a new release.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
