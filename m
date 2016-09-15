Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53378 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752154AbcIOFNT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Sep 2016 01:13:19 -0400
Date: Thu, 15 Sep 2016 07:13:14 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/12] dax: provide an iomap based fault handler
Message-ID: <20160915051314.GE6188@lst.de>
References: <1473847291-18913-1-git-send-email-hch@lst.de> <1473847291-18913-7-git-send-email-hch@lst.de> <20160914172717.GB30852@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160914172717.GB30852@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org

On Wed, Sep 14, 2016 at 11:27:17AM -0600, Ross Zwisler wrote:
> > +	case IOMAP_UNWRITTEN:
> > +	case IOMAP_HOLE:
> > +		if (!(vmf->flags & FAULT_FLAG_WRITE))
> > +			return dax_load_hole(mapping, entry, vmf);
> > +		/*FALLTHU*/
> 
> 		  FALLTHRU

Ooops, yes.

> 
> > +	default:
> > +		WARN_ON_ONCE(1);
> > +		error = -EIO;
> > +		break;
> 
> No need to break here.

Not really needed, but definitively more future-proof..
