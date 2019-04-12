Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46064 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726714AbfDLNMi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Apr 2019 09:12:38 -0400
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v5 1/6] libnvdimm: nd_region flush callback support
References: <20190410040826.24371-1-pagupta@redhat.com>
        <20190410040826.24371-2-pagupta@redhat.com>
        <CAPcyv4i1FjBzfcWtzeCvj-giHa9xaX0dMQ==q4LZC_L8VEqkHg@mail.gmail.com>
        <20190412083230.GA29850@quack2.suse.cz>
Date: Fri, 12 Apr 2019 09:12:10 -0400
In-Reply-To: <20190412083230.GA29850@quack2.suse.cz> (Jan Kara's message of
        "Fri, 12 Apr 2019 10:32:30 +0200")
Message-ID: <x494l73z7th.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>, Pankaj Gupta <pagupta@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, virtualization@lists.linux-foundation.org, KVM list <kvm@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Qemu Developers <qemu-devel@nongnu.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Ross Zwisler <zwisler@kernel.org>, Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Matthew Wilcox <willy@infradead.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Christoph Hellwig <hch@infradead.org>, Len Brown <lenb@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "Darrick J. Wong" <darrick.wong@oracle.com>, lcapitulino@redhat.com, Kevin Wolf <kwolf@redhat.com>, Igor Mammedov <imammedo@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>, Rik van Riel <riel@surriel.com>, Stefan Hajnoczi <stefanha@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, David Hildenbrand <david@redhat.com>, david <david@fromorbit.com>, cohuck@redhat.com, Xiao Guangrong <xiaoguangrong.eric@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, kilobyte@angband.pl, yuval.shaia@oracle.com

Jan Kara <jack@suse.cz> writes:

> On Thu 11-04-19 07:51:48, Dan Williams wrote:
>> On Tue, Apr 9, 2019 at 9:09 PM Pankaj Gupta <pagupta@redhat.com> wrote:
>> > +       } else {
>> > +               if (nd_region->flush(nd_region))
>> > +                       rc = -EIO;
>> 
>> Given the common case wants to be fast and synchronous I think we
>> should try to avoid retpoline overhead by default. So something like
>> this:
>> 
>> if (nd_region->flush == generic_nvdimm_flush)
>>     rc = generic_nvdimm_flush(...);
>
> I'd either add a comment about avoiding retpoline overhead here or just
> make ->flush == NULL mean generic_nvdimm_flush(). Just so that people don't
> get confused by the code.

Isn't this premature optimization?  I really don't like adding things
like this without some numbers to show it's worth it.

-Jeff
