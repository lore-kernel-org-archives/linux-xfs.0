Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:47925 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751205AbdJMAXC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2017 20:23:02 -0400
Received: by mail-oi0-f41.google.com with SMTP id h200so11228672oib.4
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 17:23:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171012134209.GE29293@quack2.suse.cz>
References: <20171011200603.27442-1-jack@suse.cz> <20171011200603.27442-18-jack@suse.cz>
 <CAPcyv4gZw0QCG08Qs8dP8TMhgXo0_KcVq-33uhaG8QuwxXT=Wg@mail.gmail.com> <20171012134209.GE29293@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 12 Oct 2017 17:23:01 -0700
Message-ID: <CAPcyv4gpJV7m5wAtqivykmAM0VKNZxyLh3e9rZcGpQg1v_EN=g@mail.gmail.com>
Subject: Re: [PATCH 17/19] ext4: Add support for MAP_SYNC flag
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Ted Tso <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Thu, Oct 12, 2017 at 6:42 AM, Jan Kara <jack@suse.cz> wrote:
> On Wed 11-10-17 15:11:21, Dan Williams wrote:
>> On Wed, Oct 11, 2017 at 1:06 PM, Jan Kara <jack@suse.cz> wrote:
>> > Now when everything is prepared, add support in ext4 to accept MAP_SYNC
>> > as an mmap(2) flag.
>> >
>> > Signed-off-by: Jan Kara <jack@suse.cz>
>> > ---
>> >  fs/ext4/file.c | 20 ++++++++++++++++++++
>> >  1 file changed, 20 insertions(+)
>> >
>> > diff --git a/fs/ext4/file.c b/fs/ext4/file.c
>> > index 61a8788168f3..f013cda84b3d 100644
>> > --- a/fs/ext4/file.c
>> > +++ b/fs/ext4/file.c
>> > @@ -364,6 +364,25 @@ static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
>> >         return 0;
>> >  }
>> >
>> > +#define EXT4_SUPPORTED_MAP_FLAGS (LEGACY_MAP_MASK | MAP_SYNC)
>> > +
>> > +static int ext4_file_mmap_validate(struct file *file,
>> > +                                  struct vm_area_struct *vma,
>> > +                                  unsigned long map_flags)
>> > +{
>> > +       if (map_flags & ~EXT4_SUPPORTED_MAP_FLAGS)
>> > +               return -EOPNOTSUPP;
>> > +
>> > +       /*
>> > +        * We don't support synchronous mappings for non-DAX files. At least
>> > +        * until someone comes with a sensible use case.
>> > +        */
>> > +       if (!IS_DAX(file_inode(file)) && (map_flags & MAP_SYNC))
>> > +               return -EOPNOTSUPP;
>>
>> Perhaps EPERM instead to differentiate the unsupported flags case?
>> There's precedent for mmap returning EPERM for reasons other than
>> incompatible PROT flags.
>
> Hum, I could make it EINVAL. EPERM looks just too bogus to me.

EINVAL is indistinguishable from a kernel that does not support
MAP_SHARED_VALIDATE...
