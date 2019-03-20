Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40365 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727062AbfCTAxx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Mar 2019 20:53:53 -0400
Received: by mail-pg1-f194.google.com with SMTP id u9so421642pgo.7
        for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2019 17:53:53 -0700 (PDT)
Date: Tue, 19 Mar 2019 17:53:51 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
Subject: Re: [RFC 0/2] guarantee natural alignment for kmalloc()
In-Reply-To: <01000169988d4e34-b4178f68-c390-472b-b62f-a57a4f459a76-000000@email.amazonses.com>
Message-ID: <alpine.DEB.2.21.1903191751560.18028@chino.kir.corp.google.com>
References: <20190319211108.15495-1-vbabka@suse.cz> <01000169988d4e34-b4178f68-c390-472b-b62f-a57a4f459a76-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christopher Lameter <cl@linux.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Ming Lei <ming.lei@redhat.com>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <willy@infradead.org>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Michal Hocko <mhocko@kernel.org>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org

On Wed, 20 Mar 2019, Christopher Lameter wrote:

> > The recent thread [1] inspired me to look into guaranteeing alignment for
> > kmalloc() for power-of-two sizes. Turns out it's not difficult and in most
> > configuration nothing really changes as it happens implicitly. More details in
> > the first patch. If we agree we want to do this, I will see where to update
> > documentation and perhaps if there are any workarounds in the tree that can be
> > converted to plain kmalloc() afterwards.
> 
> This means that the alignments are no longer uniform for all kmalloc
> caches and we get back to code making all sorts of assumptions about
> kmalloc alignments.
> 
> Currently all kmalloc objects are aligned to KMALLOC_MIN_ALIGN. That will
> no longer be the case and alignments will become inconsistent.
> 
> I think its valuable that alignment requirements need to be explicitly
> requested.
> 
> Lets add an array of power of two aligned kmalloc caches if that is really
> necessary. Add some GFP_XXX flag to kmalloc to make it ^2 aligned maybe?
> 

No objection, but I think the GFP flags should remain what they are for: 
to Get Free Pages.  If we are to add additional flags to specify 
characteristics of slab objects, can we add a kmalloc_flags() variant that 
will take a new set of flags?  SLAB_OBJ_ALIGN_POW2?
