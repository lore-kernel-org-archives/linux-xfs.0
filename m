Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CAD147F3F
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 08:56:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 68970AC002
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 06:56:03 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id kE9mPN8hw8x1126q for <xfs@oss.sgi.com>;
	Thu, 14 Nov 2013 06:56:02 -0800 (PST)
Message-ID: <5284E484.6090001@sandeen.net>
Date: Thu, 14 Nov 2013 08:56:04 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH RFC] xfs: set block device logical sector size on
	xfs_buftarg
References: <5283C41D.7070503@redhat.com>
	<20131113185645.GA20869@infradead.org>
	<5283CE2E.2070702@sandeen.net> <20131113212658.GJ6188@dastard>
	<20131114133749.GA26268@infradead.org>
In-Reply-To: <20131114133749.GA26268@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 11/14/13, 7:37 AM, Christoph Hellwig wrote:
> On Thu, Nov 14, 2013 at 08:26:58AM +1100, Dave Chinner wrote:
>> Seems like that's the avenue for improvement here to me. i.e. expose
>> the correct values to the guest so it's mkfs does the right thing.
>> Or, alternatively, make qemu buffer non-aligned/sized IOs itself
>> internally.
> 
> I've implemented the support to expose these to the guest in qemu
> years ago.  But the problem remains that this is information which
> needs to be attached to the image, which can't really work with raw
> images, and no one has bother to implement the support to store it
> for say qcow2.
> 

Ok but once again - this is not a guest mkfs issue.  The reported
problem is that the guest cannot _boot_ in cache=none mode because
the bios attempts a 512-byte DIO.

Yes, this is all qemu's fault.   We can fight that in the court
of public opinion, I guess.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
