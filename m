Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48904 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751016AbdAYQZf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jan 2017 11:25:35 -0500
Date: Wed, 25 Jan 2017 08:24:30 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] [RFC] xfs: work around unlikely() profiler glitch
Message-ID: <20170125162430.GN9134@birch.djwong.org>
References: <20170125140821.2677725-1-arnd@arndb.de>
 <20170125150929.GA19906@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170125150929.GA19906@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Nicolas Pitre <nico@linaro.org>, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@sandeen.net>

On Wed, Jan 25, 2017 at 07:09:29AM -0800, Christoph Hellwig wrote:
> On Wed, Jan 25, 2017 at 03:08:10PM +0100, Arnd Bergmann wrote:
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index d22f7930eb75..dca3ddd737d4 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -3629,7 +3629,7 @@ xfs_bmap_btalloc(
> >  		align = xfs_get_cowextsz_hint(ap->ip);
> >  	else if (xfs_alloc_is_userdata(ap->datatype))
> >  		align = xfs_get_extsz_hint(ap->ip);
> > -	if (unlikely(align)) {
> > +	if (unlikely_notrace(align)) {
> >  		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
> >  						align, 0, ap->eof, 0, ap->conv,
> >  						&ap->offset, &ap->length);
> 
> The unlikely calls on align in xfs_bmap_btalloc should simply be
> removed.  They aren't actually unlikely for many workloads.  I have
> a patch in my queue that I can expedite based on your report.

I was thinking exactly the same thing.  Since it breaks the build
somewhere, can you send a oneliner patch so I can roll it into the rc6
fixes?

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
