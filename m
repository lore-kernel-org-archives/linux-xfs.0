Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:12391 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751123AbdEJM6E (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 May 2017 08:58:04 -0400
Message-ID: <1494420895.16411.4.camel@linux.intel.com>
Subject: Re: [PATCH 2/3] xfs: use uuid_be to implement the uuid_t type
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Wed, 10 May 2017 15:54:55 +0300
In-Reply-To: <20170510120119.GA20271@lst.de>
References: <20170505075725.19597-1-hch@lst.de>
         <20170505075725.19597-3-hch@lst.de>
         <CAOQ4uxg=wLW9d195W_Ro71iNZEt8jVFyVwXysd-WnuDx7ELKDw@mail.gmail.com>
         <20170505084813.GA4805@lst.de> <1493977343.30052.23.camel@linux.intel.com>
         <20170505095617.GA6762@lst.de> <1493978788.30052.29.camel@linux.intel.com>
         <20170505101052.GB7095@lst.de>
         <CAOQ4uxh_gAUDiCY6yHcTiXRTBzKZv7R7PquAXRzztxRE0yb0wQ@mail.gmail.com>
         <20170510120119.GA20271@lst.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, 2017-05-10 at 14:01 +0200, Christoph Hellwig wrote:
> On Wed, May 10, 2017 at 11:39:27AM +0300, Amir Goldstein wrote:
> > To avoid stepping over each other toes, I propose the following work
> > sequence:
> 
> I agree on the list, but I've started a tree that has a slightly
> different
> sequence:
> 
> (1) renamed uuid_be to uuid_t and uuid_le to guid_t, but keep the old
>     name for compat for now.
>     Including these items from your list:
> > - Create helper variants uuid_cmp()/uuid_gen()/uuid_to_bin()
> 
> (2): kill uuid_v1 by adding a union to uuid_t that has the v1 meaning
>      (and maybe more in the future)
> 
> (3) > This patch set by Christoph:
> > - re-define xfs's  uuid_t as uuid_be (this patch)
> > - more xfs uuid cleanups
> 
> 
> (4): > V3 of 'hoist xfs uuid helpers' by me:
> > - hoist uuid_t typedef to uuid.h
> > - hoist helpers uuid_equal()/uuid_copy() to uuid.h
> > - create helper uuid_is_null()
> > - convert xfs to use the new uuid_is_null()
> 
> (but now moved over the to plain uuid_t type)
> 
> (5) > Promote uuid_t to VFS and filesystems (I can do it):
> > - Convert sb->s_uuid to uuid_t
> > - Convert some sample fs (tmpfs, ext2, ext4, ..) to uuid_t
> > - Use uuid_copy() and uuid_gen() where due
> 
> And the rest for latter
> 
> > Kill off uuid_be (I can do it):
> > - Convery uuid_be users to uuid_t and uuid_ helpers
> > - Kill off uuid_be and uuid_be_ helpers
> > 
> > Kill off generate_random_uuid (Christoph?):
> > - Not sure what you're intentions are wrt to all users that use
> >   this helper to initialize a char[16] var?
> 
> They really should be converted to either uuid_t or guid_t, or
> just use prandom_bytes if they really aren't either a UUID or GUID
> 
> > Maybe repeat the uuid_be->uuid_t process with uuid_le->guid_t
> > (Andy?):
> > - I don't think any of the above interferes with your work to
> > convert
> > ACPI to uuid_le?
> > - You can actually start this work in parallel to uuid_be->uuid_t,
> > because
> >   it will create trivial merge conflicts that we can easily sort out
> > on the common
> >   development branch
> 
> With my work I'm right now at item (5) of my list, I'll send it out
> later this afternoon.


I'm fine with above and it looks like I could rebase my current work
whenever (1) has been done.

Looking forward to repository with changes I can rebase on top of.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
