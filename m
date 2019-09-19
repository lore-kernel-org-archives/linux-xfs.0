Return-Path: <SRS0=IJtx=XO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDFAEC3A5A6
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 15:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B963821924
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 15:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389597AbfISPBf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Sep 2019 11:01:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34252 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388350AbfISPBe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Sep 2019 11:01:34 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AF0603C919;
        Thu, 19 Sep 2019 15:01:34 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 52C3B60BF1;
        Thu, 19 Sep 2019 15:01:34 +0000 (UTC)
Date:   Thu, 19 Sep 2019 11:01:32 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 05/11] xfs: refactor cntbt lastblock scan best extent
 logic into helper
Message-ID: <20190919150132.GD35460@bfoster>
References: <20190916121635.43148-1-bfoster@redhat.com>
 <20190916121635.43148-6-bfoster@redhat.com>
 <20190918190341.GT2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918190341.GT2229799@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Thu, 19 Sep 2019 15:01:34 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 18, 2019 at 12:03:41PM -0700, Darrick J. Wong wrote:
> On Mon, Sep 16, 2019 at 08:16:29AM -0400, Brian Foster wrote:
> > The cntbt lastblock scan checks the size, alignment, locality, etc.
> > of each free extent in the block and compares it with the current
> > best candidate. This logic will be reused by the upcoming optimized
> > cntbt algorithm, so refactor it into a separate helper.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c | 113 +++++++++++++++++++++++++++++---------
> >  fs/xfs/xfs_trace.h        |  25 +++++++++
> >  2 files changed, 111 insertions(+), 27 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index ee46989ab723..2fa7bb6a00a8 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -791,6 +791,89 @@ xfs_alloc_cur_close(
> >  	acur->cnt = acur->bnolt = acur->bnogt = NULL;
> >  }
> >  
> > +/*
> > + * Check an extent for allocation and track the best available candidate in the
> > + * allocation structure. The cursor is deactivated if it has entered an out of
> > + * range state based on allocation arguments. Optionally return the extent
> > + * extent geometry and allocation status if requested by the caller.
> > + */
> > +static int
> > +xfs_alloc_cur_check(
> > +	struct xfs_alloc_arg		*args,
> > +	struct xfs_alloc_cur		*acur,
> > +	struct xfs_btree_cur		*cur,
> > +	int				*new)
> > +{
> > +	int			error, i;
> 
> Inconsistent indentation here.
> 

Fixed.

> > +	xfs_agblock_t		bno, bnoa, bnew;
> > +	xfs_extlen_t		len, lena, diff = -1;
> > +	bool			busy;
> > +	unsigned		busy_gen = 0;
> > +	bool			deactivate = false;
> > +
> > +	*new = 0;
> > +
...
> > +}
> > +
> >  /*
> >   * Deal with the case where only small freespaces remain. Either return the
> >   * contents of the last freespace record, or allocate space from the freelist if
...
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index eaae275ed430..b12fad3e45cb 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -1663,6 +1663,31 @@ DEFINE_ALLOC_EVENT(xfs_alloc_vextent_noagbp);
> >  DEFINE_ALLOC_EVENT(xfs_alloc_vextent_loopfailed);
> >  DEFINE_ALLOC_EVENT(xfs_alloc_vextent_allfailed);
> >  
> > +TRACE_EVENT(xfs_alloc_cur_check,
> > +	TP_PROTO(struct xfs_mount *mp, xfs_btnum_t btnum, xfs_agblock_t bno,
> > +		 xfs_extlen_t len, xfs_extlen_t diff, bool new),
> > +	TP_ARGS(mp, btnum, bno, len, diff, new),
> > +	TP_STRUCT__entry(
> > +		__field(dev_t, dev)
> > +		__field(xfs_btnum_t, btnum)
> > +		__field(xfs_agblock_t, bno)
> > +		__field(xfs_extlen_t, len)
> > +		__field(xfs_extlen_t, diff)
> > +		__field(bool, new)
> > +	),
> > +	TP_fast_assign(
> > +		__entry->dev = mp->m_super->s_dev;
> > +		__entry->btnum = btnum;
> > +		__entry->bno = bno;
> > +		__entry->len = len;
> > +		__entry->diff = diff;
> > +		__entry->new = new;
> > +	),
> > +	TP_printk("dev %d:%d btnum %d bno 0x%x len 0x%x diff 0x%x new %d",
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->btnum,
> 
> Perhaps:
> 
> 	__print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
> 
> instead of dumping the raw btnum value?
> 

Good point, fixed.

Brian

> Other than those two things, this looks like a pretty straightforward
> hoisting.
> 
> --D
> 
> > +		  __entry->bno, __entry->len, __entry->diff, __entry->new)
> > +)
> > +
> >  DECLARE_EVENT_CLASS(xfs_da_class,
> >  	TP_PROTO(struct xfs_da_args *args),
> >  	TP_ARGS(args),
> > -- 
> > 2.20.1
> > 
