Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DB3C77F50
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 08:14:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 419DDAC007
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 06:14:25 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4rbaWnvNPEGYzx3w for
	<xfs@oss.sgi.com>; Fri, 22 Nov 2013 06:14:23 -0800 (PST)
Message-ID: <528F66A4.7060200@redhat.com>
Date: Fri, 22 Nov 2013 09:13:56 -0500
From: Ric Wheeler <rwheeler@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH RFC] xfs: set block device logical sector size on
	xfs_buftarg
References: <5283C41D.7070503@redhat.com>	<20131113185645.GA20869@infradead.org>	<5283CE2E.2070702@sandeen.net>
	<20131113212658.GJ6188@dastard>	<20131114133749.GA26268@infradead.org>	<5284E484.6090001@sandeen.net>
	<20131114210156.GP6188@dastard>
In-Reply-To: <20131114210156.GP6188@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 11/14/2013 04:01 PM, Dave Chinner wrote:
> On Thu, Nov 14, 2013 at 08:56:04AM -0600, Eric Sandeen wrote:
>> On 11/14/13, 7:37 AM, Christoph Hellwig wrote:
>>> On Thu, Nov 14, 2013 at 08:26:58AM +1100, Dave Chinner wrote:
>>>> Seems like that's the avenue for improvement here to me. i.e. expose
>>>> the correct values to the guest so it's mkfs does the right thing.
>>>> Or, alternatively, make qemu buffer non-aligned/sized IOs itself
>>>> internally.
>>> I've implemented the support to expose these to the guest in qemu
>>> years ago.  But the problem remains that this is information which
>>> needs to be attached to the image, which can't really work with raw
>>> images, and no one has bother to implement the support to store it
>>> for say qcow2.
>>>
>> Ok but once again - this is not a guest mkfs issue.  The reported
>> problem is that the guest cannot _boot_ in cache=none mode because
>> the bios attempts a 512-byte DIO.
> A different viewpoint: How can we make sure real 4k sector hardware
> works with Linux when it comes along if we can't emulate it via
> qemu + virtualisation?
>
> People often use qemu + virutalisation as a method of testing code
> for hardware they don't have access to, and this just seems like
> another of those things that we should have working in this
> environment long before real hardware comes along and requires it...
>
> Cheers,
>
> Dave.

I think you do that by using SCSI debug to get a 4K sector drive - that is how 
we tested for RHEL6 for example.  Layering on restrictions to hardware in the 
file system seems a bit harsh.

The QEMU crowd will be working to get better support for 4K drives in the 
future, but I think that we are effectively going to cause a huge field issue 
here since these 512/4K drives are extremely common..

Given the SCSI debug method for this, does that mean you retract your objections 
and will support Eric's patch :) ?

Regards,

Ric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
