Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56798 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbeLEOJ0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Dec 2018 09:09:26 -0500
Date: Wed, 5 Dec 2018 06:09:25 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/11] vfs: push copy_file_ranges -EXDEV checks down
Message-ID: <20181205140925.GA21109@infradead.org>
References: <20181203083416.28978-1-david@fromorbit.com>
 <20181203083416.28978-10-david@fromorbit.com>
 <20181204154347.GA6925@infradead.org>
 <20181204221847.GQ6311@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181204221847.GQ6311@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, olga.kornievskaia@gmail.com, linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

On Wed, Dec 05, 2018 at 09:18:47AM +1100, Dave Chinner wrote:
> I'll drop it if you want, but then I'll just have to come back after
> all the NFS code is merged and do yet more cleanup work.

IFF we want these NFS "features" we'll have to get it right before
merging the code.  But even with that I'd rather fix the glaring
issues you are fixing in your first patches as a priority before
adding more features.  In other words:  don't worry about NFS, lets
get the existing code right before worrying about the next round
of potential issues.
