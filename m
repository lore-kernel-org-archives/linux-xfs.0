Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54543 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755210AbdEKMHV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 May 2017 08:07:21 -0400
Date: Thu, 11 May 2017 14:07:18 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 05/16] uuid: add the v1 layout to uuid_t
Message-ID: <20170511120718.GA27480@lst.de>
References: <20170510180214.16852-1-hch@lst.de> <20170510180214.16852-6-hch@lst.de> <1494502838.6967.4.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1494502838.6967.4.camel@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

On Thu, May 11, 2017 at 02:40:38PM +0300, Andy Shevchenko wrote:
> On Wed, 2017-05-10 at 20:02 +0200, Christoph Hellwig wrote:
> > Turn the content of uuid_t into a union and add the fields for the v1
> > interpretation to it.
> 
> In the branch it has fix for UUID() wrt union change, but there missed
> similar for GUID().

Actually UUID needed this because uuid_t has a unіon inside, GUID
should not need it because it doesn't.

> While here, can we indent \ to be the same as of the rest lines in
> macro(s) ?

Sure.
