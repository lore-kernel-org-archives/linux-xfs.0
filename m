Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:37454 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753463AbeDIQve (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Apr 2018 12:51:34 -0400
Received: by mail-oi0-f52.google.com with SMTP id f63-v6so8292669oic.4
        for <linux-xfs@vger.kernel.org>; Mon, 09 Apr 2018 09:51:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180409164944.6u7i4wgbp6yihvin@quack2.suse.cz>
References: <152246892890.36038.18436540150980653229.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152246901060.36038.4487158506830998280.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180404094656.dssixqvvdcp5jff2@quack2.suse.cz> <CAPcyv4joRA=BrurYZ1kzXpMG=jnXik9+LdLqH9961jM5VnmU7w@mail.gmail.com>
 <20180409164944.6u7i4wgbp6yihvin@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 9 Apr 2018 09:51:33 -0700
Message-ID: <CAPcyv4gzJ4gcWgwOOmER1z7zsWR+X2zao-tMh8TjN9tx2kg_0g@mail.gmail.com>
Subject: Re: [PATCH v8 15/18] mm, fs, dax: handle layout changes to pinned dax mappings
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Jeff Moyer <jmoyer@redhat.com>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <mawilcox@microsoft.com>, Alexander Viro <viro@zeniv.linux.org.uk>, "Darrick J. Wong" <darrick.wong@oracle.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh.triplett@intel.com>

On Mon, Apr 9, 2018 at 9:49 AM, Jan Kara <jack@suse.cz> wrote:
> On Sat 07-04-18 12:38:24, Dan Williams wrote:
[..]
>> I wonder if this can be trivially solved by using srcu. I.e. we don't
>> need to wait for a global quiescent state, just a
>> get_user_pages_fast() quiescent state. ...or is that an abuse of the
>> srcu api?
>
> Well, I'd rather use the percpu rwsemaphore (linux/percpu-rwsem.h) than
> SRCU. It is a more-or-less standard locking mechanism rather than relying
> on implementation properties of SRCU which is a data structure protection
> method. And the overhead of percpu rwsemaphore for your use case should be
> about the same as that of SRCU.

I was just about to ask that. Yes, it seems they would share similar
properties and it would be better to use the explicit implementation
rather than a side effect of srcu.
