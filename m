Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41338 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726627AbfCSVL3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Mar 2019 17:11:29 -0400
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [RFC 0/2] guarantee natural alignment for kmalloc()
Date: Tue, 19 Mar 2019 22:11:06 +0100
Message-Id: <20190319211108.15495-1-vbabka@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-mm@kvack.org
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Ming Lei <ming.lei@redhat.com>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <willy@infradead.org>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Michal Hocko <mhocko@kernel.org>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>

The recent thread [1] inspired me to look into guaranteeing alignment for
kmalloc() for power-of-two sizes. Turns out it's not difficult and in most
configuration nothing really changes as it happens implicitly. More details in
the first patch. If we agree we want to do this, I will see where to update
documentation and perhaps if there are any workarounds in the tree that can be
converted to plain kmalloc() afterwards.

The second patch is quick and dirty selftest for the alignment. Suggestions
welcome whether and how to include this kind of selftest that has to be
in-kernel.

[1] https://lore.kernel.org/linux-fsdevel/20190225040904.5557-1-ming.lei@redhat.com/T/#u

Vlastimil Babka (2):
  mm, sl[aou]b: guarantee natural alignment for kmalloc(power-of-two)
  mm, sl[aou]b: test whether kmalloc() alignment works as expected

 mm/slab_common.c | 30 +++++++++++++++++++++++++++++-
 mm/slob.c        | 42 +++++++++++++++++++++++++++++++-----------
 2 files changed, 60 insertions(+), 12 deletions(-)

-- 
2.21.0
