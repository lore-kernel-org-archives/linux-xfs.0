Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43630 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727230AbeK1SiE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Nov 2018 13:38:04 -0500
Date: Tue, 27 Nov 2018 23:37:22 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH v1 0/7] Block/XFS: Support alternative mirror device
 retry
Message-ID: <20181128073722.GB7084@infradead.org>
References: <1543376991-5764-1-git-send-email-allison.henderson@oracle.com>
 <20181128053303.GL6311@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128053303.GL6311@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, bob.liu@oracle.com

On Wed, Nov 28, 2018 at 04:33:03PM +1100, Dave Chinner wrote:
> One thing that is going to make this more complex at the XFS layer
> is discontiguous buffers. They require multiple IOs (and therefore
> bios) and so we are going to need to ensure that all the bios use
> the same bi_rw_hint.

Well, in case of raid 1 the load balancing code might actually
map different bios to different initial legs.   What we really need
is to keep the 'index' or each bio.  One good way to archive that
is to just reuse the bio for the retry instead of allocating a new one.
