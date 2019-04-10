Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57448 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729450AbfDJIie (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Apr 2019 04:38:34 -0400
Date: Wed, 10 Apr 2019 04:38:33 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <1336073020.20708683.1554885513376.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190410082804.GG1426@quack2.suse.cz>
References: <20190410040826.24371-1-pagupta@redhat.com> <20190410040826.24371-4-pagupta@redhat.com> <20190410082804.GG1426@quack2.suse.cz>
Subject: Re: [PATCH v5 3/6] libnvdimm: add dax_dev sync flag
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org, qemu-devel@nongnu.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, dan j williams <dan.j.williams@intel.com>, zwisler@kernel.org, vishal l verma <vishal.l.verma@intel.com>, dave jiang <dave.jiang@intel.com>, mst@redhat.com, jasowang@redhat.com, willy@infradead.org, rjw@rjwysocki.net, hch@infradead.org, lenb@kernel.org, tytso@mit.edu, adilger kernel <adilger.kernel@dilger.ca>, darrick wong <darrick.wong@oracle.com>, lcapitulino@redhat.com, kwolf@redhat.com, imammedo@redhat.com, jmoyer@redhat.com, nilal@redhat.com, riel@surriel.com, stefanha@redhat.com, aarcange@redhat.com, david@redhat.com, david@fromorbit.com, cohuck@redhat.com, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, pbonzini@redhat.com, kilobyte@angband.pl, yuval shaia <yuval.shaia@oracle.com>


> 
> On Wed 10-04-19 09:38:23, Pankaj Gupta wrote:
> > @@ -64,6 +65,10 @@ static inline bool dax_write_cache_enabled(struct
> > dax_device *dax_dev)
> >  {
> >  	return false;
> >  }
> > +static inline bool dax_synchronous(struct dax_device *dax_dev)
> > +{
> > +	return true;
> > +}
> 
> Is there a need to define dax_synchronous() for !CONFIG_DAX? Because that
> property of dax device is pretty much undefined and I don't see anything
> needing to call it for !CONFIG_DAX...

You are right. Will remove this.

Thanks for the review.

Best regards,
Pankaj

> 
> 								Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
> 
