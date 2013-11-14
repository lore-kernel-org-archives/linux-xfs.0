Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 58AAF7F5E
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 15:02:09 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 37A358F8049
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 13:02:09 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	9Uu0jdaCG8JLOdum for <xfs@oss.sgi.com>;
	Thu, 14 Nov 2013 13:02:04 -0800 (PST)
Date: Fri, 15 Nov 2013 08:01:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] xfs: set block device logical sector size on
	xfs_buftarg
Message-ID: <20131114210156.GP6188@dastard>
References: <5283C41D.7070503@redhat.com>
	<20131113185645.GA20869@infradead.org>
	<5283CE2E.2070702@sandeen.net> <20131113212658.GJ6188@dastard>
	<20131114133749.GA26268@infradead.org>
	<5284E484.6090001@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5284E484.6090001@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Nov 14, 2013 at 08:56:04AM -0600, Eric Sandeen wrote:
> On 11/14/13, 7:37 AM, Christoph Hellwig wrote:
> > On Thu, Nov 14, 2013 at 08:26:58AM +1100, Dave Chinner wrote:
> >> Seems like that's the avenue for improvement here to me. i.e. expose
> >> the correct values to the guest so it's mkfs does the right thing.
> >> Or, alternatively, make qemu buffer non-aligned/sized IOs itself
> >> internally.
> > 
> > I've implemented the support to expose these to the guest in qemu
> > years ago.  But the problem remains that this is information which
> > needs to be attached to the image, which can't really work with raw
> > images, and no one has bother to implement the support to store it
> > for say qcow2.
> > 
> 
> Ok but once again - this is not a guest mkfs issue.  The reported
> problem is that the guest cannot _boot_ in cache=none mode because
> the bios attempts a 512-byte DIO.

A different viewpoint: How can we make sure real 4k sector hardware
works with Linux when it comes along if we can't emulate it via
qemu + virtualisation?

People often use qemu + virutalisation as a method of testing code
for hardware they don't have access to, and this just seems like
another of those things that we should have working in this
environment long before real hardware comes along and requires it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
