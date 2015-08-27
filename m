Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8DFDD29DF5
	for <xfs@oss.sgi.com>; Thu, 27 Aug 2015 08:41:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 28D89AC008
	for <xfs@oss.sgi.com>; Thu, 27 Aug 2015 06:41:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gbH3wHBELGEN535E (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 27 Aug 2015 06:41:54 -0700 (PDT)
Message-ID: <55DF13A0.1090706@redhat.com>
Date: Thu, 27 Aug 2015 09:41:52 -0400
From: David Jeffery <djeffery@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: return errors from partial I/O failures to files
References: <20150826190636.GA16540@rage.redhat.com>
	<20150826221951.GE3902@dastard>
In-Reply-To: <20150826221951.GE3902@dastard>
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
Cc: xfs@oss.sgi.com

On 08/26/2015 06:19 PM, Dave Chinner wrote:
> On Wed, Aug 26, 2015 at 03:06:36PM -0400, David Jeffery wrote:
>> There is an issue with xfs's error reporting in some cases of I/O partially
>> failing and partially succeeding. Calls like fsync() can report success even
>> though not all I/O was successful.
> 
> Hi David,
> 
> I read your bug report last night and after considering all the work
> you put into it, I was going to ask if you wanted to finish off the
> job by writing the patch to fix it. But you beat me to it.
> 
> Nice work! :)
> 
>> The issue can occur when there are multiple bio per xfs_ioend struct.
>> Each call to xfs_end_bio() for a bio completing will write a value to
>> ioend->io_error.  If a successful bio completes after any failed bio, no
>> error is reported do to it writing 0 over the error code set by any failed bio.
>> The I/O error information is now lost and when the ioend is completed
>> only success is reported back up the filesystem stack.
> 
> It's worth mentioning the case that this was seen in - a single
> failed disk in a raid 0 stripe, and the error from the bio to the
> failed disk was overwritten by the successes from the bios to the
> other disks.
> 
> FWIW, I think that we also need to create an xfstest for this case,
> too, because it's clear that this is a big hole in our test coverage
> (i.e.  partial block device failure). It might be best to talk to
> Eryu (cc'd) to get your reproducer converted into a xfstest case
> that we can then test all filesystems against?
> 
>> xfs_end_bio() should only set ioend->io_error in the case of BIO_UPTODATE
>> being clear.  ioend->io_error is initialized to 0 at allocation so only needs
>> to be updated by any failed bio structs. This ensures an error can be reported
>> to the application.
>>
>> Signed-off-by: David Jeffery <djeffery@redhat.com>
>> ---
> 
> Best to add a "cc: <stable@vger.kernel.org>" so that it gets pushed
> back to all the stable kernels automatically which it hits Linus'
> tree.
> 
> One minor change to the fix:
> 
>> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
>> index 3859f5e..b82b128 100644
>> --- a/fs/xfs/xfs_aops.c
>> +++ b/fs/xfs/xfs_aops.c
>> @@ -356,7 +356,8 @@ xfs_end_bio(
>>  {
>>  	xfs_ioend_t		*ioend = bio->bi_private;
>>  
>> -	ioend->io_error = test_bit(BIO_UPTODATE, &bio->bi_flags) ? 0 : error;
>> +	if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
>> +		ioend->io_error = error;
> 
> We should preserve the original error that was reported, rather than
> report the last one. ioend->io_error is always initialised to zero,
> so we can simply do:

Is there a particular reason to prefer the first error?  Is it just
standard practice?  I originally made a version which preserved the
first error but couldn't think of a reason why the first or last would
be best.  So I went with the patch which has the simpler if statement.

> 
> 	if (!ioend->io_error && !test_bit(BIO_UPTODATE, &bio->bi_flags))
> 		ioend->io_error = error;
> 
> Can you update the patch and resend it? I've got a couple of other
> fixes that I need to push to the for-next tree in the next couple of
> days (i.e. before the 4.3. merge window opens) and I'd like to get
> this one in as well.
> 
> Cheers,
> 
> Dave
> 

I'll get a new version sent.

David Jeffery

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
