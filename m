Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Dec 2007 03:19:38 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBCBInT1025470
	for <xfs@oss.sgi.com>; Wed, 12 Dec 2007 03:18:52 -0800
Message-ID: <475FC40C.3030102@mxtelecom.com>
Date: Wed, 12 Dec 2007 11:20:44 +0000
From: Matthew Hodgson <matthew@mxtelecom.com>
MIME-Version: 1.0
Subject: Re: Zero-copy Block IO with XFS
References: <475E76AB.705@mxtelecom.com> <20071212110735.GH4612@sgi.com>
In-Reply-To: <20071212110735.GH4612@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

Hi Dave,

Thanks for the response :)

David Chinner wrote:
> On Tue, Dec 11, 2007 at 11:38:19AM +0000, Matthew Hodgson wrote:
>> I'm experimenting with using XFS with a network block device (DST), and 
>> have come up against the problem that when writing data to the network, 
>> it uses kernel_sendpage to hand the page presented at the BIO layer to 
>> the network stack.  It then completes the block IO request.
>>
>> The problem arises when XFS proceeds to then reuse that page before the 
>> NIC actually sends it.
> 
> Where does XFS overwrite a page while I/O is still in progress?
> Stack trace please.

It doesn't.  The problem is that after the block device has completed 
the IO request with bio_endio(), there's a risk that it may still need 
access to the page in order to retransmit it, perform offloaded 
checksumming, etc.

>> Particularly if TX checksumming or TCP 
>> segmentation is being offloaded to the NIC, it seems that the NIC will 
>> try to access to page after the BIO request has returned, and so operate 
>> on stale data. 
> 
> That sounds like you are completing the bio before the I/O has
> really been completed. Basically, the bio can't be completed until
> the data has been sent and that will prevent any use after free or
> overwrite of the data while it is being sent...

Agreed.  In general that will cause a fairly major performance hit, 
however (you'd have to at least wait for the ACK from the TCP peer 
before completing the BIO).  Or make a copy of the page.  Is there no 
scope (however theoretical - I guess this is starting to become an 
academic question) for providing XFS with hints that particular pages 
are in use elsewhere and should not be overwritten?  Could XFS mandate 
only overwriting pages in its cache with a ->count of 1?

In other news, does XFS still provide the block layer with 
slab-allocated pages for metadata operations?

thanks,

Matthew.

-- 
Matthew Hodgson <matthew@mxtelecom.com>
Media & Systems Project Manager
Tel: +44 (0) 845 666 7778
http://www.mxtelecom.com
