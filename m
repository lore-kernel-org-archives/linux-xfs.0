Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49785 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751593AbdEJMBV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 May 2017 08:01:21 -0400
Date: Wed, 10 May 2017 14:01:19 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] xfs: use uuid_be to implement the uuid_t type
Message-ID: <20170510120119.GA20271@lst.de>
References: <20170505075725.19597-1-hch@lst.de> <20170505075725.19597-3-hch@lst.de> <CAOQ4uxg=wLW9d195W_Ro71iNZEt8jVFyVwXysd-WnuDx7ELKDw@mail.gmail.com> <20170505084813.GA4805@lst.de> <1493977343.30052.23.camel@linux.intel.com> <20170505095617.GA6762@lst.de> <1493978788.30052.29.camel@linux.intel.com> <20170505101052.GB7095@lst.de> <CAOQ4uxh_gAUDiCY6yHcTiXRTBzKZv7R7PquAXRzztxRE0yb0wQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh_gAUDiCY6yHcTiXRTBzKZv7R7PquAXRzztxRE0yb0wQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, linux-xfs <linux-xfs@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, May 10, 2017 at 11:39:27AM +0300, Amir Goldstein wrote:
> To avoid stepping over each other toes, I propose the following work sequence:

I agree on the list, but I've started a tree that has a slightly different
sequence:

(1) renamed uuid_be to uuid_t and uuid_le to guid_t, but keep the old
    name for compat for now.
    Including these items from your list:
> - Create helper variants uuid_cmp()/uuid_gen()/uuid_to_bin()

(2): kill uuid_v1 by adding a union to uuid_t that has the v1 meaning
     (and maybe more in the future)

(3) > This patch set by Christoph:
> - re-define xfs's  uuid_t as uuid_be (this patch)
> - more xfs uuid cleanups


(4): > V3 of 'hoist xfs uuid helpers' by me:
> - hoist uuid_t typedef to uuid.h
> - hoist helpers uuid_equal()/uuid_copy() to uuid.h
> - create helper uuid_is_null()
> - convert xfs to use the new uuid_is_null()

(but now moved over the to plain uuid_t type)

(5) > Promote uuid_t to VFS and filesystems (I can do it):
> - Convert sb->s_uuid to uuid_t
> - Convert some sample fs (tmpfs, ext2, ext4, ..) to uuid_t
> - Use uuid_copy() and uuid_gen() where due

And the rest for latter

> Kill off uuid_be (I can do it):
> - Convery uuid_be users to uuid_t and uuid_ helpers
> - Kill off uuid_be and uuid_be_ helpers
> 
> Kill off generate_random_uuid (Christoph?):
> - Not sure what you're intentions are wrt to all users that use
>   this helper to initialize a char[16] var?

They really should be converted to either uuid_t or guid_t, or
just use prandom_bytes if they really aren't either a UUID or GUID

> Maybe repeat the uuid_be->uuid_t process with uuid_le->guid_t (Andy?):
> - I don't think any of the above interferes with your work to convert
> ACPI to uuid_le?
> - You can actually start this work in parallel to uuid_be->uuid_t, because
>   it will create trivial merge conflicts that we can easily sort out
> on the common
>   development branch

With my work I'm right now at item (5) of my list, I'll send it out
later this afternoon.
