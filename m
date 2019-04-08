Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49092 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726479AbfDHKmW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Apr 2019 06:42:22 -0400
Date: Mon, 8 Apr 2019 12:33:03 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [POC][PATCH] xfs: reduce ilock contention on buffered randrw
 workload
Message-ID: <20190408103303.GA18239@quack2.suse.cz>
References: <20190404165737.30889-1-amir73il@gmail.com>
 <20190404211730.GD26298@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190404211730.GD26298@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Amir Goldstein <amir73il@gmail.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.com>

On Fri 05-04-19 08:17:30, Dave Chinner wrote:
> FYI, I'm working on a range lock implementation that should both
> solve the performance issue and the reader starvation issue at the
> same time by allowing concurrent buffered reads and writes to
> different file ranges.

Are you aware of range locks Davidlohr has implemented [1]? It didn't get
merged because he had no in-tree user at the time (he was more aiming at
converting mmap_sem which is rather difficult). But the generic lock
implementation should be well usable.

Added Davidlohr to CC.

								Honza

[1] https://lkml.org/lkml/2017/3/7/22

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
