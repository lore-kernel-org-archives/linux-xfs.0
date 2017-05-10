Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33261 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751081AbdEJIj2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 May 2017 04:39:28 -0400
MIME-Version: 1.0
In-Reply-To: <20170505101052.GB7095@lst.de>
References: <20170505075725.19597-1-hch@lst.de> <20170505075725.19597-3-hch@lst.de>
 <CAOQ4uxg=wLW9d195W_Ro71iNZEt8jVFyVwXysd-WnuDx7ELKDw@mail.gmail.com>
 <20170505084813.GA4805@lst.de> <1493977343.30052.23.camel@linux.intel.com>
 <20170505095617.GA6762@lst.de> <1493978788.30052.29.camel@linux.intel.com> <20170505101052.GB7095@lst.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 10 May 2017 11:39:27 +0300
Message-ID: <CAOQ4uxh_gAUDiCY6yHcTiXRTBzKZv7R7PquAXRzztxRE0yb0wQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] xfs: use uuid_be to implement the uuid_t type
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, linux-xfs <linux-xfs@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

[ added CC linux-fsdevel ]

On Fri, May 5, 2017 at 1:10 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Fri, May 05, 2017 at 01:06:28PM +0300, Andy Shevchenko wrote:
>> On Fri, 2017-05-05 at 11:56 +0200, Christoph Hellwig wrote:
>> > On Fri, May 05, 2017 at 12:42:23PM +0300, Andy Shevchenko wrote:
>> > > Christoph, I can wait a bit and re-do my patch if we settle down
>> > > data
>> > > types and function name space.
>> >
>> > We should probably just work on a common branch.
>>
>> Works for me. Are you volunteering to provide a such?
>
> Sure, I can set one up in one of my infradead trees.

Christoph, Andy,

Our discussions now span so many threads and different CC lists
(ACPI uuid_le, hoist xfs uuid_t, tmpfs gen s_uuid, ubifs copy s_uuid, ...)
so I picked this relatively young and less overloaded thread.
Since converting filesystems and uuid_be seems to be first order of
business, I only added linux-fsdevel to CC. If you think that other lists
should be included at this point in the discussion, feel free to add them.
Let's try to stick to this thread going forward.

To avoid stepping over each other toes, I propose the following work sequence:

This patch set by Christoph:
- re-define xfs's  uuid_t as uuid_be (this patch)
- more xfs uuid cleanups

V3 of 'hoist xfs uuid helpers' by me:
- hoist uuid_t typedef to uuid.h
- hoist helpers uuid_equal()/uuid_copy() to uuid.h
- create helper uuid_is_null()
- convert xfs to use the new uuid_is_null()

Kill off uuid_be (I can do it):
- Create helper variants uuid_cmp()/uuid_gen()/uuid_to_bin()
- Convery uuid_be users to uuid_t and uuid_ helpers
- Kill off uuid_be and uuid_be_ helpers

Promote uuid_t to VFS and filesystems (I can do it):
- Convert sb->s_uuid to uuid_t
- Convert some sample fs (tmpfs, ext2, ext4, ..) to uuid_t
- Use uuid_copy() and uuid_gen() where due

Kill off generate_random_uuid (Christoph?):
- Not sure what you're intentions are wrt to all users that use
  this helper to initialize a char[16] var?

Maybe repeat the uuid_be->uuid_t process with uuid_le->guid_t (Andy?):
- I don't think any of the above interferes with your work to convert
ACPI to uuid_le?
- You can actually start this work in parallel to uuid_be->uuid_t, because
  it will create trivial merge conflicts that we can easily sort out
on the common
  development branch

Thoughts?

Amir.
