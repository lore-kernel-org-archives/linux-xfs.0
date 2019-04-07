Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35997 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbfDGIAf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 7 Apr 2019 04:00:35 -0400
Date: Sun, 7 Apr 2019 10:00:20 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC 0/2] guarantee natural alignment for kmalloc()
Message-ID: <20190407080020.GA9949@lst.de>
References: <20190319211108.15495-1-vbabka@suse.cz> <01000169988d4e34-b4178f68-c390-472b-b62f-a57a4f459a76-000000@email.amazonses.com> <5d7fee9c-1a80-6ac9-ac1d-b1ce05ed27a8@suse.cz> <010001699c5563f8-36c6909f-ed43-4839-82da-b5f9f21594b8-000000@email.amazonses.com> <4d2a55dc-b29f-1309-0a8e-83b057e186e6@suse.cz> <01000169a68852ed-d621a35c-af0c-4759-a8a3-e97e7dfc17a5-000000@email.amazonses.com> <2b129aec-f9a5-7ab8-ca4a-0a325621d111@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b129aec-f9a5-7ab8-ca4a-0a325621d111@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christopher Lameter <cl@linux.com>, linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Ming Lei <ming.lei@redhat.com>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <willy@infradead.org>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Michal Hocko <mhocko@kernel.org>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org

On Fri, Apr 05, 2019 at 07:11:17PM +0200, Vlastimil Babka wrote:
> On 3/22/19 6:52 PM, Christopher Lameter wrote:
> > On Thu, 21 Mar 2019, Vlastimil Babka wrote:
> > 
> >> That however doesn't work well for the xfs/IO case where block sizes are
> >> not known in advance:
> >>
> >> https://lore.kernel.org/linux-fsdevel/20190225040904.5557-1-ming.lei@redhat.com/T/#ec3a292c358d05a6b29cc4a9ce3ae6b2faf31a23f
> > 
> > I thought we agreed to use custom slab caches for that?
> 
> Hm maybe I missed something but my impression was that xfs/IO folks would have
> to create lots of them for various sizes not known in advance, and that it
> wasn't practical and would welcome if kmalloc just guaranteed the alignment.
> But so far they haven't chimed in here in this thread, so I guess I'm wrong.

Yes, in XFS we might have quite a few.  Never mind all the other
block level consumers that might have similar reasonable expectations
but haven't triggered the problematic drivers yet.
