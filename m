Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:44766 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751875AbeDMWDw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Apr 2018 18:03:52 -0400
Received: by mail-oi0-f68.google.com with SMTP id j143-v6so9682458oih.11
        for <linux-xfs@vger.kernel.org>; Fri, 13 Apr 2018 15:03:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4gzJ4gcWgwOOmER1z7zsWR+X2zao-tMh8TjN9tx2kg_0g@mail.gmail.com>
References: <152246892890.36038.18436540150980653229.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152246901060.36038.4487158506830998280.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180404094656.dssixqvvdcp5jff2@quack2.suse.cz> <CAPcyv4joRA=BrurYZ1kzXpMG=jnXik9+LdLqH9961jM5VnmU7w@mail.gmail.com>
 <20180409164944.6u7i4wgbp6yihvin@quack2.suse.cz> <CAPcyv4gzJ4gcWgwOOmER1z7zsWR+X2zao-tMh8TjN9tx2kg_0g@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 13 Apr 2018 15:03:51 -0700
Message-ID: <CAPcyv4h3RPdohsPyiB=GxE8iQCjRRen=knDd=Em5BMy1MYpRvA@mail.gmail.com>
Subject: Re: [PATCH v8 15/18] mm, fs, dax: handle layout changes to pinned dax mappings
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Jeff Moyer <jmoyer@redhat.com>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <mawilcox@microsoft.com>, Alexander Viro <viro@zeniv.linux.org.uk>, "Darrick J. Wong" <darrick.wong@oracle.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh.triplett@intel.com>

On Mon, Apr 9, 2018 at 9:51 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Mon, Apr 9, 2018 at 9:49 AM, Jan Kara <jack@suse.cz> wrote:
>> On Sat 07-04-18 12:38:24, Dan Williams wrote:
> [..]
>>> I wonder if this can be trivially solved by using srcu. I.e. we don't
>>> need to wait for a global quiescent state, just a
>>> get_user_pages_fast() quiescent state. ...or is that an abuse of the
>>> srcu api?
>>
>> Well, I'd rather use the percpu rwsemaphore (linux/percpu-rwsem.h) than
>> SRCU. It is a more-or-less standard locking mechanism rather than relying
>> on implementation properties of SRCU which is a data structure protection
>> method. And the overhead of percpu rwsemaphore for your use case should be
>> about the same as that of SRCU.
>
> I was just about to ask that. Yes, it seems they would share similar
> properties and it would be better to use the explicit implementation
> rather than a side effect of srcu.

...unfortunately:

 BUG: sleeping function called from invalid context at
./include/linux/percpu-rwsem.h:34
 [..]
 Call Trace:
  dump_stack+0x85/0xcb
  ___might_sleep+0x15b/0x240
  dax_layout_lock+0x18/0x80
  get_user_pages_fast+0xf8/0x140

...and thinking about it more srcu is a better fit. We don't need the
100% exclusion provided by an rwsem we only need the guarantee that
all cpus that might have been running get_user_pages_fast() have
finished it at least once.

In my tests synchronize_srcu is a bit slower than unpatched for the
trivial 100 truncate test, but certainly not the 200x latency you were
seeing with syncrhonize_rcu.

Elapsed time:
0.006149178 unpatched
0.009426360 srcu
