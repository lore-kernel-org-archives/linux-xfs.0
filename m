Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51638 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752191AbeF1CR5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 27 Jun 2018 22:17:57 -0400
Subject: Re: [PATCH] mm: reject MAP_SHARED_VALIDATE without new flags
References: <60052659-7b37-cb69-bf9f-1683caa46219@redhat.com>
 <CA+55aFzeA7N3evSF2jKHu8JoTQuKDLCMKx7RiPhmym97-8HY7A@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <1e2ad827-6ff4-4b1e-c4d9-79ca4e432a6c@sandeen.net>
Date: Wed, 27 Jun 2018 21:17:55 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzeA7N3evSF2jKHu8JoTQuKDLCMKx7RiPhmym97-8HY7A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-ext4@vger.kernel.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, zhibli@redhat.com

On 6/27/18 9:10 PM, Linus Torvalds wrote:
> On Wed, Jun 27, 2018 at 6:45 PM Eric Sandeen <sandeen@redhat.com> wrote:
>>
>> Thus the invalid flag combination of (MAP_SHARED|MAP_PRIVATE) now
>> passes without error, which is a regression.
> 
> It's not a regression, it's just new behavior.
> 
> "regression" doesn't mean "things changed". It means "something broke".
> 
> What broke?

My commit log perhaps was not clear enough.

What broke is that mmap(MAP_SHARED|MAP_PRIVATE) now succeeds without error,
whereas before it rightly returned -EINVAL.

What behavior should a user expect from a successful mmap(MAP_SHARED|MAP_PRIVATE)?

-Eric

> Because if it's some manual page breakage, just fix the manual. That's
> what "new behavior" is all about.
> 
> There is nothing that says that "MAP_SHARED_VALIDATE" can't work with
> just the legacy flags.
> 
> Because I'd be worried about your patch breaking some actual new user
> of MAP_SHARED_VALIDATE.
> 
> Because it's actual *users* of behavior we care about, not some
> test-suite or manual pages.
> 
>               Linus
