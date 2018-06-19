Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:33613 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937651AbeFSLIO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jun 2018 07:08:14 -0400
Received: by mail-it0-f66.google.com with SMTP id k17-v6so14407859ita.0
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jun 2018 04:08:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5a1e303b-e96e-7faf-1bcd-36d63a237514@redhat.com>
References: <20180614120457.28285-1-hch@lst.de> <CAHc6FU4nQ562SxepV1=dqcuuuPBWOTXr4sAiY_5H-Z7uOaTNng@mail.gmail.com>
 <20180615080326.GB19525@lst.de> <5a1e303b-e96e-7faf-1bcd-36d63a237514@redhat.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Tue, 19 Jun 2018 13:08:12 +0200
Message-ID: <CAHc6FU79WMraW95k-p_2x8GF_dtmDBST50D=3joYAua2KBtOqw@mail.gmail.com>
Subject: Re: [Cluster-devel] iomap preparations for GFS2 v2
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, cluster-devel <cluster-devel@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>, linux-ext4 <linux-ext4@vger.kernel.org>

On 15 June 2018 at 10:31, Steven Whitehouse <swhiteho@redhat.com> wrote:
> Hi,
>
> On 15/06/18 09:03, Christoph Hellwig wrote:
>>
>> On Thu, Jun 14, 2018 at 03:04:38PM +0200, Andreas Gruenbacher wrote:
>>>
>>> I saw that you've pushed this onto the gfs2-iomap branch in your xfs
>>> repository. I've rebased the gfs2 iomap-write branch onto that;
>>> there's a trivial patch for adding a private pointer to struct iomap
>>> at the head of that branch that would sense to move to the shared
>>> branch as well now.
>>
>> Please send that patch out ASAP.
>>
>>> The next step would probably be to start using iomap_readpage /
>>> iomap_readpages in gfs2 for block size == page size. This requires
>>> adding inline data support to iomap_readpage which is trivial, but
>>> because of gfs2's reliance on buffer heads, that alone isn't enough.
>>
>> Is it?  At least for block size == page size we will only call
>> readpage on a pristine, newly allocated page.  So buffer heads won't
>> be in the game at that point, and the iomap buffered write code will
>> just allocate them for you once we start a write operation, or take
>> a page fault that makes the page writable.

What I'm seeing in the readpage address space operation is pages which
are not PageUptodate(), with a page-size buffer head that is
buffer_uptodate(). The filesystem doesn't bother keeping the page
flags in sync with the buffer head flags, nothing unusual. When
iomap_readpage is called on such a page, it will replace the current
contents with what's on disk, losing the changes in memory. So we
cannot just call iomap_readpages, we need to check the buffer head
flags as well. Or, since the old code is still needed for page size !=
block size anyway, we can fall back to that for pages that have
buffers for now.

> Yes, for block size == page size, it should not be an issue to drop the use
> of buffer heads on reads in GFS2. I was fairly sure that we already did that
> in ->readpages() anyway, but it is a while since I looked at the code and my
> memory may be playing tricks on me,

I've pushed what I have so far here in case you want to have a look:

  https://git.kernel.org/pub/scm/linux/kernel/git/gfs2/linux-gfs2.git/log/?h=iomap-readpage

There's one remaining failure in xfstest generic/299 that I'm still
looking into.

Thanks,
Andreas
