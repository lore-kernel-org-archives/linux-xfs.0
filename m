Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from a9-112.smtp-out.amazonses.com ([54.240.9.112]:37312 "EHLO
        a9-112.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725958AbfCTAnM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Mar 2019 20:43:12 -0400
Date: Wed, 20 Mar 2019 00:43:11 +0000
From: Christopher Lameter <cl@linux.com>
Subject: Re: [RFC 0/2] guarantee natural alignment for kmalloc()
In-Reply-To: <20190319211108.15495-1-vbabka@suse.cz>
Message-ID: <01000169988d4e34-b4178f68-c390-472b-b62f-a57a4f459a76-000000@email.amazonses.com>
References: <20190319211108.15495-1-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Ming Lei <ming.lei@redhat.com>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <willy@infradead.org>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Michal Hocko <mhocko@kernel.org>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org

On Tue, 19 Mar 2019, Vlastimil Babka wrote:

> The recent thread [1] inspired me to look into guaranteeing alignment for
> kmalloc() for power-of-two sizes. Turns out it's not difficult and in most
> configuration nothing really changes as it happens implicitly. More details in
> the first patch. If we agree we want to do this, I will see where to update
> documentation and perhaps if there are any workarounds in the tree that can be
> converted to plain kmalloc() afterwards.

This means that the alignments are no longer uniform for all kmalloc
caches and we get back to code making all sorts of assumptions about
kmalloc alignments.

Currently all kmalloc objects are aligned to KMALLOC_MIN_ALIGN. That will
no longer be the case and alignments will become inconsistent.

I think its valuable that alignment requirements need to be explicitly
requested.

Lets add an array of power of two aligned kmalloc caches if that is really
necessary. Add some GFP_XXX flag to kmalloc to make it ^2 aligned maybe?
