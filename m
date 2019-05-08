Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36314 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbfEHFbV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 May 2019 01:31:21 -0400
Date: Wed, 8 May 2019 01:31:18 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <1853101606.27182251.1557293478937.JavaMail.zimbra@redhat.com>
In-Reply-To: <CA+nGSuOgCAoS4MkbuSL2q5Gyi4jG2oyJqLu_sDgexm5fSBmPLQ@mail.gmail.com>
References: <20190426050039.17460-1-pagupta@redhat.com> <20190426050039.17460-5-pagupta@redhat.com> <CA+nGSuOgCAoS4MkbuSL2q5Gyi4jG2oyJqLu_sDgexm5fSBmPLQ@mail.gmail.com>
Subject: Re: [Qemu-devel] [PATCH v7 4/6] dax: check synchronous mapping is
 supported
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jakub =?utf-8?Q?Staro=C5=84?= <jstaron@google.com>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org, qemu-devel@nongnu.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, jack@suse.cz, mst@redhat.com, jasowang@redhat.com, david@fromorbit.com, lcapitulino@redhat.com, adilger kernel <adilger.kernel@dilger.ca>, zwisler@kernel.org, aarcange@redhat.com, dave jiang <dave.jiang@intel.com>, darrick wong <darrick.wong@oracle.com>, vishal l verma <vishal.l.verma@intel.com>, david@redhat.com, willy@infradead.org, hch@infradead.org, jmoyer@redhat.com, nilal@redhat.com, lenb@kernel.org, kilobyte@angband.pl, riel@surriel.com, yuval shaia <yuval.shaia@oracle.com>, stefanha@redhat.com, pbonzini@redhat.com, dan j williams <dan.j.williams@intel.com>, kwolf@redhat.com, tytso@mit.edu, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, cohuck@redhat.com, rjw@rjwysocki.net, imammedo@redhat.com, Stephen Barber <smbarber@google.com>


> 
> From: Pankaj Gupta <pagupta@redhat.com>
> Date: Thu, Apr 25, 2019 at 10:00 PM
> 
> > +static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
> > +                               struct dax_device *dax_dev)
> > +{
> > +       return !(vma->flags & VM_SYNC);
> > +}
> 
> Shouldn't it be rather `return !(vma->vm_flags & VM_SYNC);`? There is
> no field named `flags` in `struct vm_area_struct`.

Thanks for catching. Sorry! for this. 

Will correct in v8.

Thank you,
Pankaj 

> 
> Thank you,
> Jakub
> 
