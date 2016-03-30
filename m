Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4FC117CA1
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 13:59:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0786D8F8059
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 11:59:45 -0700 (PDT)
Received: from mail-qg0-f45.google.com (mail-qg0-f45.google.com
	[209.85.192.45]) by cuda.sgi.com with ESMTP id eGBehdSTX0N8iF40
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 30 Mar 2016 11:59:40 -0700 (PDT)
Received: by mail-qg0-f45.google.com with SMTP id y89so47452578qge.2
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 11:59:40 -0700 (PDT)
Subject: Re: fallocate mode flag for "unshare blocks"?
References: <20160302155007.GB7125@infradead.org>
	<20160330182755.GC2236@birch.djwong.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56FC21DE.7090308@gmail.com>
Date: Wed, 30 Mar 2016 14:58:38 -0400
MIME-Version: 1.0
In-Reply-To: <20160330182755.GC2236@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-api@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

On 2016-03-30 14:27, Darrick J. Wong wrote:
> Hi all,
>
> Christoph and I have been working on adding reflink and CoW support to
> XFS recently.  Since the purpose of (mode 0) fallocate is to make sure
> that future file writes cannot ENOSPC, I extended the XFS fallocate
> handler to unshare any shared blocks via the copy on write mechanism I
> built for it.  However, Christoph shared the following concerns with
> me about that interpretation:
>
>> I know that I suggested unsharing blocks on fallocate, but it turns out
>> this is causing problems.  Applications expect falloc to be a fast
>> metadata operation, and copying a potentially large number of blocks
>> is against that expextation.  This is especially bad for the NFS
>> server, which should not be blocked for a long time in a synchronous
>> operation.
>>
>> I think we'll have to remove the unshare and just fail the fallocate
>> for a reflinked region for now.  I still think it makes sense to expose
>> an unshare operation, and we probably should make that another
>> fallocate mode.
>
> With that in mind, how do you all think we ought to resolve this?
> Should we add a new fallocate mode flag that means "unshare the shared
> blocks"?  Obviously, this unshare flag cannot be used in conjunction
> with hole punching, zero range, insert range, or collapse range.  This
> breaks the expectation that writing to a file after fallocate won't
> ENOSPC.
>
> Or is it ok that fallocate could block, potentially for a long time as
> we stream cows through the page cache (or however unshare works
> internally)?  Those same programs might not be expecting fallocate to
> take a long time.
Nothing that I can find in the man-pages or API documentation for 
Linux's fallocate explicitly says that it will be fast.  There are bits 
that say it should be efficient, but that is not itself well defined 
(given context, I would assume it to mean that it doesn't use as much 
I/O as writing out that many bytes of zero data, not necessarily that it 
will return quickly).  We may have done a lot to make it fast, but that 
doesn't mean by any measure that we guarantee it anywhere (at least, we 
don't guarantee it anywhere I can find).
>
> Can we do better than either solution?  It occurs to me that XFS does
> unshare by reading the file data into the pagecache, marking the pages
> dirty, and flushing the dirty pages; performance could be improved by
> skipping the flush at the end.  We won't ENOSPC, because the XFS
> delalloc system is careful enough to check that there are enough free
> blocks to handle both the allocation and the metadata updates.  The
> only gap in this scheme that I can see is if we fallocate, crash, and
> upon restart the program then tries to write without retrying the
> fallocate.  Can we trade some performance for the added requirement
> that we must fallocate -> write -> fsync, and retry the trio if we
> crash before the fsync returns?  I think that's already an implicit
> requirement, so we might be ok here.
Most of the software I've seen that doesn't use fallocate like this is 
either doing odd things otherwise, or is just making sure it has space 
for temporary files, so I think it is probably safe to require this.
>
> Opinions?  I rather like the last option, though I've only just
> thought of it and have not had time to examine it thoroughly, and it's
> specific to XFS. :)
Personally I'm indifferent about how we handle it, as long as it still 
maintains the normal semantics, and it works for reflinked ranges 
(seemingly arbitrary failures for a range in a file should be handled 
properly by an application, but that doesn't mean we shouldn't try to 
reduce their occurrence).

I would like to comment that it would be nice to have an fallocate 
option to force a range to become unshared, but I personally feel we 
should have that alongside the regular functionality, not in-place of it.

It's probably also worth noting that reflinks technically break 
expectations WRT FALLOC_FL_PUNCH_HOLE already.  Most apps I see that use 
PUNCH_HOLE seem to expect it to free space, which won't happen if the 
range is reflinked elsewhere.  There is of course nothing that says that 
it will free space, but that doesn't change user expectations.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
