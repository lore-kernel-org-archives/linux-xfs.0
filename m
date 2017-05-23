Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52744 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752231AbdEWIuE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 May 2017 04:50:04 -0400
Date: Tue, 23 May 2017 10:49:56 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/23] afs: switch to use uuid_t and uuid_gen
Message-ID: <20170523084956.GB20121@lst.de>
References: <20170518062705.25902-1-hch@lst.de> <20170518062705.25902-11-hch@lst.de> <1495478957.6967.69.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1495478957.6967.69.camel@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

On Mon, May 22, 2017 at 09:49:17PM +0300, Andy Shevchenko wrote:
> >  	struct afs_call *call = container_of(work, struct afs_call,
> > work);
> > -	struct uuid_v1 *r = call->request;
> > +	uuid_t *r = call->request;
> >  
> >  	struct {
> >  		__be32	match;
> > 
> 
> Just to double check that this doesn't create a union aliasing.

What do you mean with that?
