Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:43314 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758629AbdJMPoh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Oct 2017 11:44:37 -0400
Received: by mail-oi0-f49.google.com with SMTP id c77so14940498oig.0
        for <linux-xfs@vger.kernel.org>; Fri, 13 Oct 2017 08:44:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171013071203.GA9105@infradead.org>
References: <20171011200603.27442-1-jack@suse.cz> <20171011200603.27442-2-jack@suse.cz>
 <20171013071203.GA9105@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 13 Oct 2017 08:44:36 -0700
Message-ID: <CAPcyv4hYuL-wOu7oBt5P=pj8rSnwudNEzRdqswaOhMN0QvN1yg@mail.gmail.com>
Subject: Re: [PATCH 01/19] mm: introduce MAP_SHARED_VALIDATE, a mechanism to
 safely define new mmap flags
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-xfs@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Ted Tso <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Fri, Oct 13, 2017 at 12:12 AM, Christoph Hellwig <hch@infradead.org> wrote:
> So did we settle on the new mmap_validate vs adding a new argument
> to ->mmap for real now?  I have to say I'd much prefer passing an
> additional argument instead, but if higher powers rule that out
> this version is ok.

MAP_DIRECT also needs the fd now, so it would be two arguments. Before
you say "that's bogus" I want to understand what the alternative looks
like for notifying userspace that its get_user_pages() registration
lease is being invalidated.

>
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index 13dab191a23e..5aee97d64cae 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -1701,6 +1701,8 @@ struct file_operations {
>>       long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
>>       long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
>>       int (*mmap) (struct file *, struct vm_area_struct *);
>> +     int (*mmap_validate) (struct file *, struct vm_area_struct *,
>> +                     unsigned long);
>
> Can we make this return a bool for ok vs not ok?  That way we only
> need to have the error code discussion in one place instead of every
> file system.

How does userspace figure out what went wrong if we lose the ability
to return different failure reasons from the ops owner? Maybe an enum
to cut down the possible error codes to 'flag not supported', 'flag
supported but failed to setup the mapping', and 'success'.
