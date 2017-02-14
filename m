Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55942 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752758AbdBNM4I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Feb 2017 07:56:08 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E416461D28
        for <linux-xfs@vger.kernel.org>; Tue, 14 Feb 2017 12:56:08 +0000 (UTC)
Date: Tue, 14 Feb 2017 07:56:08 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/4] xfs: split indlen reservations fairly when under
 reserved
Message-ID: <20170214125607.GA3223@bfoster.bfoster>
References: <1486668893-44633-1-git-send-email-bfoster@redhat.com>
 <1486668893-44633-5-git-send-email-bfoster@redhat.com>
 <20170214081244.GM24562@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170214081244.GM24562@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Feb 14, 2017 at 04:12:44PM +0800, Eryu Guan wrote:
> On Thu, Feb 09, 2017 at 02:34:53PM -0500, Brian Foster wrote:
> > Certain workoads that punch holes into speculative preallocation can
> > cause delalloc indirect reservation splits when the delalloc extent is
> > split in two. If further splits occur, an already short-handed extent
> > can be split into two in a manner that leaves zero indirect blocks for
> > one of the two new extents. This occurs because the shortage is large
> > enough that the xfs_bmap_split_indlen() algorithm completely drains the
> > requested indlen of one of the extents before it honors the existing
> > reservation.
> > 
> > This ultimately results in a warning from xfs_bmap_del_extent(). This
> > has been observed during file copies of large, sparse files using 'cp
> > --sparse=always.'
> > 
> > To avoid this problem, update xfs_bmap_split_indlen() to explicitly
> > apply the reservation shortage fairly between both extents. This smooths
> > out the overall indlen shortage and defers the situation where we end up
> > with a delalloc extent with zero indlen reservation to extreme
> > circumstances.
> > 
> > Reported-by: Patrick Dung <mpatdung@gmail.com>
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c | 61 ++++++++++++++++++++++++++++++++++--------------
> >  1 file changed, 43 insertions(+), 18 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 49edea4..e27b9ee 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -4790,6 +4790,7 @@ xfs_bmap_split_indlen(
> >  	xfs_filblks_t			len2 = *indlen2;
> >  	xfs_filblks_t			nres = len1 + len2; /* new total res. */
> >  	xfs_filblks_t			stolen = 0;
> > +	xfs_filblks_t			resfactor;
> >  
> >  	trace_printk("%d: ores %llu len1 %llu len2 %llu\n", __LINE__, ores, len1, len2);
> 
> Is this line a leftover from debug code? Patch doesn't apply with this
> line on top of 4.10-rc8 kernel.
> 

Oops.. looks like I forgot to pull that stuff out of my branch. I'll
post a new set with it removed.

Brian

> Thanks,
> Eryu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
