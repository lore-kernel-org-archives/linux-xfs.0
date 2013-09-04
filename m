Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DDEB87F53
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 15:05:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BF879304067
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 13:05:49 -0700 (PDT)
Received: from mail-vc0-f179.google.com (mail-vc0-f179.google.com
	[209.85.220.179]) by cuda.sgi.com with ESMTP id
	ruidMCnibPwSDcAw (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 13:05:48 -0700 (PDT)
Received: by mail-vc0-f179.google.com with SMTP id ht10so500509vcb.38
	for <xfs@oss.sgi.com>; Wed, 04 Sep 2013 13:05:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130904192048.GM3996@quack.suse.cz>
References: <cover.1377193658.git.luto@amacapital.net>
	<e1620c8e4909a65e270c8e9590e307c22fd96a44.1377193658.git.luto@amacapital.net>
	<20130904145740.GE3996@quack.suse.cz>
	<CALCETrUA653bw3C=XP=Es9UApqsKsDG-UAzuZ=qS1RA1LeoKYw@mail.gmail.com>
	<20130904192048.GM3996@quack.suse.cz>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 4 Sep 2013 13:05:27 -0700
Message-ID: <CALCETrXLtLbgQH-eXm7AvxyRYa2jxZ=3jR=CfvAY+drGC_O4nA@mail.gmail.com>
Subject: Re: [PATCH v4 3/7] mm: Allow filesystems to defer cmtime updates
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
To: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>, Dave Hansen <dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Tim Chen <tim.c.chen@linux.intel.com>

On Wed, Sep 4, 2013 at 12:20 PM, Jan Kara <jack@suse.cz> wrote:
> On Wed 04-09-13 10:54:50, Andy Lutomirski wrote:
>> >> @@ -1970,6 +1988,39 @@ int write_one_page(struct page *page, int wait)
>> >>  }
>> >>  EXPORT_SYMBOL(write_one_page);
>> >>
>> >> +void mapping_flush_cmtime(struct address_space *mapping)
>> >> +{
>> >> +     if (mapping_test_clear_cmtime(mapping) &&
>> >> +         mapping->a_ops->update_cmtime_deferred)
>> >> +             mapping->a_ops->update_cmtime_deferred(mapping);
>> >> +}
>> >> +EXPORT_SYMBOL(mapping_flush_cmtime);
>> >   Hum, is there a reason for update_cmtime_deferred() operation? I can
>> > hardly imagine anyone will want to do anything else than what
>> > inode_update_time_writable() does so why bother? You mention tmpfs & co.
>> > don't fit into your scheme well with which I agree so let's just keep
>> > file_update_time() in their page_mkwrite() operation. But I don't see a
>> > real need for avoiding the deferred cmtime logic...
>>
>> I think there might be odd corner cases.  For example, mmap a tmpfs
>> file, write it, and unmap it.  Then, an hour later, maybe the system
>   If you unmap it then that will handle the update. But if you won't unmap,
> you'd get spurious updates of timestamps which would be strange.
>
>> will be under memory pressure and page out the file.  This could
>> trigger a surprising time update.  (I'm not sure this can actually
>> happen on tmpfs, but maybe it would on some other filesystem.)
>>
>> Does this actually matter?  A flag to turn the feature on or off would
>> do the trick, but I don't think there's precedent for sticking a flag
>> in a_ops.
>   Flag in a_ops is ugly. But you can have a flag in 'struct
> filesystem_type' which would be reasonable.

OK, will do.

>
>> >> +void mapping_flush_cmtime_nowb(struct address_space *mapping)
>> >> +{
>> >> +     /*
>> >> +      * We get called from munmap and msync.  Both calls can race
>> >> +      * with fs freezing.  If the fs is frozen after
>> >> +      * mapping_test_clear_cmtime but before the time update, then
>> >> +      * sync_filesystem will miss the cmtime update (because we
>> >> +      * just cleared it) and we don't be able to write (because the
>> >> +      * fs is frozen).  On the other hand, we can't just return if
>> >> +      * we're in the SB_FREEZE_PAGEFAULT state because our caller
>> >> +      * expects the timestamp to be synchronously updated.  So we
>> >> +      * get write access without blocking, at the SB_FREEZE_FS
>> >> +      * level.  If the fs is already fully frozen, then we already
>> >> +      * know we have nothing to do.
>> >> +      */
>> >> +
>> >> +     if (!mapping_test_cmtime(mapping))
>> >> +             return;  /* Optimization: nothing to do. */
>> >> +
>> >> +     if (__sb_start_write(mapping->host->i_sb, SB_FREEZE_FS, false)) {
>> >> +             mapping_flush_cmtime(mapping);
>> >> +             __sb_end_write(mapping->host->i_sb, SB_FREEZE_FS);
>> >> +     }
>> >> +}
>> >   This is wrong because SB_FREEZE_FS level is targetted for filesystem
>> > internal use. Also it is racy. mapping_flush_cmtime() ends up calling
>> > mark_inode_dirty() and filesystems such as ext4 or xfs will start a
>> > transaction to store inode in the journal. This gets freeze protection at
>> > SB_FREEZE_FS level again. If freeze_super() sets s_writers.frozen to
>> > SB_FREEZE_FS before this second protection, things will deadlock.
>>
>> Whoops -- I assumed that it was safe to recursively take freeze
>> protection at the same level.
>>
>> I'm worried about the following race:
>>
>> Thread 1 (in munmap):
>> Check AS_CMTIME set
>> sb_start_pagefault
>>
>> Thread 2 (freezing the fs):
>> frozen = SB_FREEZE_PAGEFAULT;
>> sync_filesystem()
>>
>> Thread 1 is now stuck.  It doesn't need to be, because sync_filesystem
>> will flush out the cmtime write.  But there doesn't seem to be a clean
>> mechanism to wait for the freeze to finish.
>   OK, I see. Frankly, I'd rather live with msync() and munmap() blocking
> while filesystem is frozen than trying to outsmart the freezing logic...
> If someone comes up with a usecase where it causes trouble, we can always
> improve the logic with some clever tricks.

I'll at least check that it's a shared writable mapping before doing
the flush to avoid blocking on other types of munmap.

--Andy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
