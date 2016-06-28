Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8A8ED7CA4
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 08:56:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0C651AC003
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 06:56:36 -0700 (PDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com
	[74.125.82.43]) by cuda.sgi.com with ESMTP id 1F3vvhW58WC3AjCA
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 28 Jun 2016 06:56:34 -0700 (PDT)
Received: by mail-wm0-f43.google.com with SMTP id v199so141049471wmv.0
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 06:56:34 -0700 (PDT)
Message-ID: <5772820E.2080403@plexistor.com>
Date: Tue, 28 Jun 2016 16:56:30 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: xfs: untangle the direct I/O and DAX path, fix DAX locking
References: <1466609236-23801-1-git-send-email-hch@lst.de>
	<20160623232446.GA12670@dastard> <20160624072612.GA22205@lst.de>
	<20160624230045.GG12670@dastard> <20160628131059.GA30475@lst.de>
	<57727B27.7060104@plexistor.com> <20160628133928.GB31283@lst.de>
In-Reply-To: <20160628133928.GB31283@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org, xfs@oss.sgi.com

On 06/28/2016 04:39 PM, Christoph Hellwig wrote:
> On Tue, Jun 28, 2016 at 04:27:03PM +0300, Boaz Harrosh wrote:
>>> Right.  And an existing application can get DAX turned on under its
>>> back, and will now suddently get different synchronization behavior.
>>> That is if it's writes happen to be aligned to the fs block size.
>>>
>>
>> Is there an actual application that does that? or is this purely
>> theoretical right now?
> 
> Lots of them.  The typical case is multithreaded (or preforked like old
> apache) daemons that use O_APPEND to write to a common log file.  Then
> again those log records will usually not be 4k aligned, so they'd still
> accidentally get the exclusive locking even without this patch.  But
> beware the case where a log record actually matches the alignment..
> 

But O_APPEND is exclusion problem of i_size update not of the actual memcpy
done in parallel or not.

Actually with O_APPEND each write request should write a different region
of the file, there are no overlapping writes. And no issue of which version of the
write came last and got its data written.

If it is the issue of isize update vs O_APPEND is a different issue don't
you think? One way that we solved it is to update isize = isize + len;
atomically before starting the IO, then on the error case sub the unwritten
bytes. And still allow concurrent writers. I agree that isize updates needs
to be atomic, but why does the memcpy?

And BTW in NFS O_APPEND concurrent readers to a writer may see
ZEROs in the interim.

I still don't see how an application can use the fact that two writers
will not give them mixed records. And surly it does not work on a shared
FS. So I was really wondering if you know of any such app

Thanks
Boaz

>>
>>
>> Thanks
>> Boaz
> ---end quoted text---
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
