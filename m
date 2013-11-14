Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B72277F50
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 07:37:58 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A1D6F8F8050
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 05:37:58 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id OGNSGynpW4lDNi8m (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 Nov 2013 05:37:54 -0800 (PST)
Date: Thu, 14 Nov 2013 05:37:49 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC] xfs: set block device logical sector size on
	xfs_buftarg
Message-ID: <20131114133749.GA26268@infradead.org>
References: <5283C41D.7070503@redhat.com>
	<20131113185645.GA20869@infradead.org>
	<5283CE2E.2070702@sandeen.net> <20131113212658.GJ6188@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131113212658.GJ6188@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Thu, Nov 14, 2013 at 08:26:58AM +1100, Dave Chinner wrote:
> Seems like that's the avenue for improvement here to me. i.e. expose
> the correct values to the guest so it's mkfs does the right thing.
> Or, alternatively, make qemu buffer non-aligned/sized IOs itself
> internally.

I've implemented the support to expose these to the guest in qemu
years ago.  But the problem remains that this is information which
needs to be attached to the image, which can't really work with raw
images, and no one has bother to implement the support to store it
for say qcow2.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
