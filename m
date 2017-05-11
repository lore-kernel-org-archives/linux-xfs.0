Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53562 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755279AbdEKH72 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 May 2017 03:59:28 -0400
Date: Thu, 11 May 2017 09:59:26 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 03/16] uuid: rename uuid types
Message-ID: <20170511075926.GC19837@lst.de>
References: <20170510180214.16852-1-hch@lst.de> <20170510180214.16852-4-hch@lst.de> <CAOQ4uxjSpCgM=RK5jXkuY5HmseQT2EKh_huntvK2ADKBuNqi4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjSpCgM=RK5jXkuY5HmseQT2EKh_huntvK2ADKBuNqi4A@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel <linux-kernel@vger.kernel.org>

On Wed, May 10, 2017 at 10:15:51PM +0300, Amir Goldstein wrote:
> > +static inline int uuid_cmp(const uuid_t u1, const uuid_t u2)
> >  {
> > -       return memcmp(&u1, &u2, sizeof(uuid_be));
> > +       return memcmp(&u1, &u2, sizeof(uuid_t));
> >  }
> >
> 
> 
> I think we should use this opportunity to change these to (uuid_t *, uuid_t *)
> which is more in line with the rest of the helpers including the new helpers
> hoisted from xfs.

Or just kill them off - uuid/guid_equals is the better interface for all
existing users as far as I can tell.  My updated series already kills
off the be/uuid one, the le/guid one will need a bit more work, though.
