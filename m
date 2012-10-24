Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9OBjaVP239060 for <xfs@oss.sgi.com>; Wed, 24 Oct 2012 06:45:37 -0500
Received: from mx2.fusionio.com (mx2.fusionio.com [66.114.96.31]) by
	cuda.sgi.com with ESMTP id 9T4dGmNkx9JsGEH5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Oct 2012 04:47:20 -0700 (PDT)
Date: Wed, 24 Oct 2012 07:47:17 -0400
From: Chris Mason <chris.mason@fusionio.com>
Subject: Re: [RFC, PATCH 0/2] fiemap: filesystem free space mapping
Message-ID: <20121024114711.GB11262@shiny>
References: <1350537079-16246-1-git-send-email-david@fromorbit.com>
	<20121023123044.GG7341@infradead.org>
	<20121023215313.GQ4291@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121023215313.GQ4291@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Oct 23, 2012 at 03:53:13PM -0600, Dave Chinner wrote:
> On Tue, Oct 23, 2012 at 08:30:44AM -0400, Christoph Hellwig wrote:
> > On Thu, Oct 18, 2012 at 04:11:17PM +1100, Dave Chinner wrote:
> > > So, I was bored a few days ago, and I was sick of having to run
> > > xfs_db incorrectly report free space extents when the filesytem is
> > > mounted, so I decided to extend fiemap to export freespace mappings
> > > to userspace so I could get the information coherently through the
> > > mounted filesystem.
> > > 
> > > Yes, this could probably be considered interface abuse but, well, it
> > > was simple to do because extent mapping is exactly what fiemap is
> > > designed to do. Hence I didn't have to write new walkers/formatters
> > > and I was using code I knew worked correctly.
> > 
> > I think the right way to handle this is to introduce a new ioctl which
> > uses the same structures.  That way we have a reasonable interface,
> > without issue like which file does it need to be called on because the
> > VFS glue can turn it into a superblock op.
> 
> A VFS level ioctl or an XFS ioctl?
> 
> I thought about a new ioctl, but then what's the point of having an
> extensible fiemap interface if we create new ioctls with an
> identical interface for doing something that the existing ioctl is
> perfectly capable of doing?  I'd still need special flags to control
> the ioctl behaviour even though it uses struct fiemap and plumbing,
> so it seemed pointless to introduce a new ioctl....

This brings us one step close to the norton disk doctor defrag display.
I'm all for it in the main fiemap call, it makes much more sense for the
users I think.

-chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
