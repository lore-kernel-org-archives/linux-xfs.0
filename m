Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46848 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751974AbdCGBF1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 Mar 2017 20:05:27 -0500
Date: Tue, 7 Mar 2017 01:07:54 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: remove kmem_zalloc_greedy
Message-ID: <20170307000754.GA9959@lst.de>
References: <20170306184109.GC5280@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170306184109.GC5280@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, Michal Hocko <mhocko@kernel.org>, Christoph Hellwig <hch@lst.de>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Xiong Zhou <xzhou@redhat.com>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Dave Chinner <david@fromorbit.com>

I like killing it, but shouldn't we just try a normal kmem_zalloc?
At least for the fallback it's the right thing, and even for an
order 2 allocation it seems like a useful first try.
