Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46587 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751313AbeEJGgo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 10 May 2018 02:36:44 -0400
Date: Thu, 10 May 2018 08:40:21 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/33] fs: factor out a __generic_write_end helper
Message-ID: <20180510064021.GB11422@lst.de>
References: <20180509074830.16196-1-hch@lst.de> <20180509074830.16196-3-hch@lst.de> <20180509151556.GB1313@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180509151556.GB1313@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

On Wed, May 09, 2018 at 08:15:56AM -0700, Matthew Wilcox wrote:
> On Wed, May 09, 2018 at 09:47:59AM +0200, Christoph Hellwig wrote:
> >  }
> >  EXPORT_SYMBOL(generic_write_end);
> >  
> > +
> >  /*
> 
> Spurious?

Yes.
