Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from a9-46.smtp-out.amazonses.com ([54.240.9.46]:56642 "EHLO
        a9-46.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725958AbfCTAo0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Mar 2019 20:44:26 -0400
Date: Wed, 20 Mar 2019 00:44:25 +0000
From: Christopher Lameter <cl@linux.com>
Subject: Re: [RFC 2/2] mm, sl[aou]b: test whether kmalloc() alignment works
 as expected
In-Reply-To: <20190319211108.15495-3-vbabka@suse.cz>
Message-ID: <01000169988e707d-e6a091d6-b04f-4774-89b0-61f985885ac8-000000@email.amazonses.com>
References: <20190319211108.15495-1-vbabka@suse.cz> <20190319211108.15495-3-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Ming Lei <ming.lei@redhat.com>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <willy@infradead.org>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Michal Hocko <mhocko@kernel.org>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org

On Tue, 19 Mar 2019, Vlastimil Babka wrote:

> Quick and dirty init test that kmalloc() alignment works as expected for
> power-of-two sizes after the previous patch.

There is already an allocator testing function in mm/slub.c. Can you
generalize it or portions and put the into mm/slab_common.c?
