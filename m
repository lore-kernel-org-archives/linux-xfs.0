Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59990 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725864AbfDRG1D (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Apr 2019 02:27:03 -0400
Date: Thu, 18 Apr 2019 02:27:00 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <695036448.22376013.1555568820649.JavaMail.zimbra@redhat.com>
In-Reply-To: <x494l73z7th.fsf@segfault.boston.devel.redhat.com>
References: <20190410040826.24371-1-pagupta@redhat.com> <20190410040826.24371-2-pagupta@redhat.com> <CAPcyv4i1FjBzfcWtzeCvj-giHa9xaX0dMQ==q4LZC_L8VEqkHg@mail.gmail.com> <20190412083230.GA29850@quack2.suse.cz> <x494l73z7th.fsf@segfault.boston.devel.redhat.com>
Subject: Re: [Qemu-devel] [PATCH v5 1/6] libnvdimm: nd_region flush callback
 support
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Moyer <jmoyer@redhat.com>, Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>
Cc: cohuck@redhat.com, KVM list <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, david <david@fromorbit.com>, Qemu Developers <qemu-devel@nongnu.org>, virtualization@lists.linux-foundation.org, Andreas Dilger <adilger.kernel@dilger.ca>, Ross Zwisler <zwisler@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, Dave Jiang <dave.jiang@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Vishal L Verma <vishal.l.verma@intel.com>, David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Len Brown <lenb@kernel.org>, kilobyte@angband.pl, Rik van Riel <riel@surriel.com>, yuval shaia <yuval.shaia@oracle.com>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, lcapitulino@redhat.com, Kevin Wolf <kwolf@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Xiao Guangrong <xiaoguangrong.eric@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Igor Mammedov <imammedo@redhat.com>


Hello,

Thank you for the suggestions on this.

> 
> > On Thu 11-04-19 07:51:48, Dan Williams wrote:
> >> On Tue, Apr 9, 2019 at 9:09 PM Pankaj Gupta <pagupta@redhat.com> wrote:
> >> > +       } else {
> >> > +               if (nd_region->flush(nd_region))
> >> > +                       rc = -EIO;
> >> 
> >> Given the common case wants to be fast and synchronous I think we
> >> should try to avoid retpoline overhead by default. So something like
> >> this:
> >> 
> >> if (nd_region->flush == generic_nvdimm_flush)
> >>     rc = generic_nvdimm_flush(...);
> >
> > I'd either add a comment about avoiding retpoline overhead here or just
> > make ->flush == NULL mean generic_nvdimm_flush(). Just so that people don't
> > get confused by the code.
> 
> Isn't this premature optimization?  I really don't like adding things
> like this without some numbers to show it's worth it.

Can we add the optimization after this version is merged.

Best regards,
Pankaj 

> 
> -Jeff
> 
> 
