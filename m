Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:36843 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1763155AbdEWNLp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 May 2017 09:11:45 -0400
Message-ID: <1495545099.6967.81.camel@linux.intel.com>
Subject: Re: [PATCH 10/23] afs: switch to use uuid_t and uuid_gen
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Tue, 23 May 2017 16:11:39 +0300
In-Reply-To: <20170523084956.GB20121@lst.de>
References: <20170518062705.25902-1-hch@lst.de>
         <20170518062705.25902-11-hch@lst.de>
         <1495478957.6967.69.camel@linux.intel.com> <20170523084956.GB20121@lst.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

On Tue, 2017-05-23 at 10:49 +0200, Christoph Hellwig wrote:
> On Mon, May 22, 2017 at 09:49:17PM +0300, Andy Shevchenko wrote:
> > >  	struct afs_call *call = container_of(work, struct
> > > afs_call,
> > > work);
> > > -	struct uuid_v1 *r = call->request;
> > > +	uuid_t *r = call->request;
> > >  
> > >  	struct {
> > >  		__be32	match;
> > > 
> > 
> > Just to double check that this doesn't create a union aliasing.
> 
> What do you mean with that?

Since we introduced a union it's possible that we might access the
member which wasn't last modified one. So, my comment is to give an
attention on such possibility and avoid if there is an aliasing
happened.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
