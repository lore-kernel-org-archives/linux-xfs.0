Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 673467F51
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 08:57:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D2859AC008
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 06:57:09 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id qWOWk1X9EIwsD67C for <xfs@oss.sgi.com>;
	Fri, 22 Nov 2013 06:57:08 -0800 (PST)
Message-ID: <528F70C2.6090404@sandeen.net>
Date: Fri, 22 Nov 2013 08:57:06 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH RFC] xfs: set block device logical sector size on
	xfs_buftarg
References: <5283C41D.7070503@redhat.com>	<20131113185645.GA20869@infradead.org>	<5283CE2E.2070702@sandeen.net>
	<20131113212658.GJ6188@dastard>	<20131114133749.GA26268@infradead.org>	<5284E484.6090001@sandeen.net>
	<20131114210156.GP6188@dastard> <528F66A4.7060200@redhat.com>
In-Reply-To: <528F66A4.7060200@redhat.com>
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
To: Ric Wheeler <rwheeler@redhat.com>, Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 11/22/13, 8:13 AM, Ric Wheeler wrote:

<snip>

> I think you do that by using SCSI debug to get a 4K sector drive -
> that is how we tested for RHEL6 for example. Layering on restrictions
> to hardware in the file system seems a bit harsh.
> 
> The QEMU crowd will be working to get better support for 4K drives in
> the future, but I think that we are effectively going to cause a huge
> field issue here since these 512/4K drives are extremely common..
> 
> Given the SCSI debug method for this, does that mean you retract your
> objections and will support Eric's patch :) ?

FWIW, my patch is a disaster, but I'll work on something along those
lines that's not a disaster, so we can discuss it properly.  ;)

To make this go, I think we need to add a structure member to the
xfs_buftarg which describes the logical sector size, and use that
to enforce minimum IO sizes.  The current sector size fields can
remain in place for the mkfs-specified, presumably physical sector
size.

Then, since the sector sizes in the sb, mp, and buftarg have been
disassociated a bit, I'll need to audit things like the sub-block
zeroing paths so that we DTRT on a sub-block DIO.

At that point, the "sector size" semantics in the mkfs.xfs manpage
get a little weird; if we specify a sector size of 4k, how can
we do sub-sector IOs?

What the mkfs option really means at that point is that the specified
size is the minimum size and alignment which will be generated from
within the filesystem for metadata; we can make it clear that the
underlying logical sector size is still the constraint for userspace
DIO.

I'm not quite sure what the XFS_IOC_DIOINFO ioctl should advertise,
at that point.

Anyway, that's about where I'm at in my brain with all this, will
try to get something that actually works relatively soon.

-Eric

> Regards,
> 
> Ric
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
