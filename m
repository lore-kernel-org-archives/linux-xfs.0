Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 98CA129E16
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 22:28:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 77C2A304064
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 20:28:50 -0700 (PDT)
Received: from mail-vb0-f52.google.com (mail-vb0-f52.google.com
	[209.85.212.52]) by cuda.sgi.com with ESMTP id 6aoutMG41jXTBULC
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 19 Aug 2013 20:28:41 -0700 (PDT)
Received: by mail-vb0-f52.google.com with SMTP id f12so3626058vbg.39
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 20:28:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130820023615.GE6023@dastard>
References: <cover.1376679411.git.luto@amacapital.net>
	<ec267e95fd21891986373c7af1c72b4c8b507332.1376679411.git.luto@amacapital.net>
	<20130820023615.GE6023@dastard>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 19 Aug 2013 20:28:20 -0700
Message-ID: <CALCETrV-Toj-NGpmWnmoUbCwrMUXOSbjQdYsSVuTiH+2dEgPTQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] mm: Notify filesystems when it's time to apply a
	deferred cmtime update
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
Cc: Jan Kara <jack@suse.cz>, Dave Hansen <dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Tim Chen <tim.c.chen@linux.intel.com>

On Mon, Aug 19, 2013 at 7:36 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Aug 16, 2013 at 04:22:10PM -0700, Andy Lutomirski wrote:
>> Filesystems that defer cmtime updates should update cmtime when any
>> of these events happen after a write via a mapping:
>>
>>  - The mapping is written back to disk.  This happens from all kinds
>>    of places, all of which eventually call ->writepages.
>>
>>  - munmap is called or the mapping is removed when the process exits
>>
>>  - msync(MS_ASYNC) is called.  Linux currently does nothing for
>>    msync(MS_ASYNC), but POSIX says that cmtime should be updated some
>>    time between an mmaped write and the subsequent msync call.
>>    MS_SYNC calls ->writepages, but MS_ASYNC needs special handling.
>>
>> Filesystmes that defer cmtime updates should flush them on munmap or
>> exit.  Finding out that this happened through vm_ops is messy, so
>> add a new address space op for this.
>>
>> It's not strictly necessary to call ->flush_cmtime after ->writepages,
>> but it simplifies the fs code.  As an optional optimization,
>> filesystems can call mapping_test_clear_cmtime themselves in
>> ->writepages (as long as they're careful to scan all the pages first
>> -- the cmtime bit may not be set when ->writepages is entered).
>
> .flush_cmtime is effectively a duplicate method.  We already have
> .update_time to notify filesystems that they need to update the
> timestamp in the inode transactionally.

.update_time is used for the atime update as well, and it relies on
the core code to update the in-memory timestamp first.  I used that
approach in v2, but it was (correctly, I think) pointed out that this
was a layering violation and that core code shouldn't be mucking with
the timestamps directly during writeback.

There was a recent effort to move most of the file_update_calls from
the core into .page_mkwrite, and I don't think anyone wants to undo
that.

>
> Indeed:
>
>> +     /*
>> +      * Userspace expects certain system calls to update cmtime if
>> +      * a file has been recently written using a shared vma.  In
>> +      * cases where cmtime may need to be updated but writepages is
>> +      * not called, this is called instead.  (Implementations
>> +      * should call mapping_test_clear_cmtime.)
>> +      */
>> +     void (*flush_cmtime)(struct address_space *);
>
> You say it can be implemented in the ->writepage(s) method, and all
> filesystems provide ->writepage(s) in some form. Therefore I would
> have thought it be best to simply require filesystems to check that
> mapping flag during those methods and update the inode directly when
> that is set?

The problem with only doing it in ->writepages is that calling
writepages from munmap and exit would probably hurt performance for no
particular gain.  So I need some kind of callback to say "update the
time, but don't write data."  The AS_CMTIME bit will still be set when
the ptes are removed.

I could require ->writepages *and* ->flush_cmtime to handle the time
update, but that would complicate non-transactional filesystems.
Those filesystems should just flush cmtime at the end of writepages.

>
> Indeed, the way you've set up the infrastructure, we'll have to
> rewrite the cmtime update code to enable writepages to update this
> within some other transaction. Perhaps you should just implement it
> that way first?

This is already possible although not IMO necessary for correctness.
All that ext4 would need to do is to add something like:

if (mapping_test_clear_cmtime(mapping)) {
  update times within current transaction
}

somewhere inside the transaction in writepages.  There would probably
be room for some kind of generic helper to do everything in
inode_update_time_writable except for the actual mark_inode_dirty
part, but this still seems nasty from a locking perspective, and I'd
rather leave that optimization to an ext4 developer who wants to do
it.

I could simplify this a bit by moving the mapping_test_clear_cmtime
part from .flush_cmtime to its callers.

--Andy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
