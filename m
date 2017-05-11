Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:34112 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754486AbdEKLiU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 May 2017 07:38:20 -0400
Message-ID: <1494502687.6967.2.camel@linux.intel.com>
Subject: Re: [PATCH 03/16] uuid: rename uuid types
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Thu, 11 May 2017 14:38:07 +0300
In-Reply-To: <2612.1494440436@warthog.procyon.org.uk>
References: <20170510180214.16852-4-hch@lst.de>
         <20170510180214.16852-1-hch@lst.de>
         <2612.1494440436@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

On Wed, 2017-05-10 at 19:20 +0100, David Howells wrote:
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > -#define NULL_UUID_LE						
> > 	\
> > -	UUID_LE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,
> > 	\
> > -		0x00, 0x00, 0x00, 0x00)
> > +#define NULL_GUID							
> > \
> > +	GUID(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	
> > \
> > +	     0x00, 0x00, 0x00, 0x00)
> >  
> > -#define NULL_UUID_BE						
> > 	\
> > -	UUID_BE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,
> > 	\
> > -		0x00, 0x00, 0x00, 0x00)
> > +#define NULL_UUID							
> > \
> > +	UUID(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	
> > \
> > +	     0x00, 0x00, 0x00, 0x00)
> 
> These are UAPI and ought not to be renamed.
> 

Good point. I see in the branch it's already fixed.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
