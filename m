Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48907 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750772AbdKUSyT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Nov 2017 13:54:19 -0500
Date: Tue, 21 Nov 2017 10:53:46 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] iomap: report collisions between directio and
 buffered writes to userspace
Message-ID: <20171121185346.GC2135@magnolia>
References: <20171117193925.GM5119@magnolia>
 <20171120161829.GA25991@bombadil.infradead.org>
 <20171120202606.GN5858@dastard>
 <20171120215100.GB8933@bombadil.infradead.org>
 <20171120222749.GO5858@dastard>
 <20171121172347.GA7640@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171121172347.GA7640@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>, Ilya Dryomov <idryomov@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Brian Foster <bfoster@redhat.com>, holger@applied-asynchrony.com, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>

On Tue, Nov 21, 2017 at 09:23:47AM -0800, Matthew Wilcox wrote:
> On Tue, Nov 21, 2017 at 09:27:49AM +1100, Dave Chinner wrote:
> > On Mon, Nov 20, 2017 at 01:51:00PM -0800, Matthew Wilcox wrote:
> > > If you want an example of it in use, I'm pretty happy with this patch
> > > that switches the brd driver entirely from the radix tree API to the
> > > xarray API:
> > > 
> > > http://git.infradead.org/users/willy/linux-dax.git/commitdiff/dbf96ae943e43563cbbaa26e21b656b6fe8f4b0f
> > 
> > Looks pretty neat, but I'll reserve judgement for when I see the
> > conversion of the XFS radix tree code....
> 
> Challenge accepted.  This was a good thing for me to do because I found
> some opportunities to improve the XArray API.
> 
> Changes since yesterday:
> 
>  - Added XA_NO_TAG
>  - Added 'max' parameters to xa_get_entries() and xa_get_tagged()
>  - Changed the order of the arguments of xa_get_entries() and xa_get_tagged()
>    to match the radix tree equivalents
> 
> You can see the patches on that (rebased) branch:
> 
> xfs: Convert mru cache to XArray
> xfs: Convert xfs dquot to XArray
> xfs: Convert pag_ici_root to XArray
> xfs: Convert m_perag_tree to XArray
> 
> or did you want me to send them by email?

Yes please.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
