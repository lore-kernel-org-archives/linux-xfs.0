Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Dec 2007 03:08:03 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBCB7W08023873
	for <xfs@oss.sgi.com>; Wed, 12 Dec 2007 03:07:34 -0800
Date: Wed, 12 Dec 2007 22:07:35 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Zero-copy Block IO with XFS
Message-ID: <20071212110735.GH4612@sgi.com>
References: <475E76AB.705@mxtelecom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475E76AB.705@mxtelecom.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Matthew Hodgson <matthew@mxtelecom.com>
Cc: xfs@oss.sgi.com

On Tue, Dec 11, 2007 at 11:38:19AM +0000, Matthew Hodgson wrote:
> Hi all,
> 
> I'm experimenting with using XFS with a network block device (DST), and 
> have come up against the problem that when writing data to the network, 
> it uses kernel_sendpage to hand the page presented at the BIO layer to 
> the network stack.  It then completes the block IO request.
> 
> The problem arises when XFS proceeds to then reuse that page before the 
> NIC actually sends it.

Where does XFS overwrite a page while I/O is still in progress?
Stack trace please.

> Particularly if TX checksumming or TCP 
> segmentation is being offloaded to the NIC, it seems that the NIC will 
> try to access to page after the BIO request has returned, and so operate 
> on stale data. 

That sounds like you are completing the bio before the I/O has
really been completed. Basically, the bio can't be completed until
the data has been sent and that will prevent any use after free or
overwrite of the data while it is being sent...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
