Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mailsec108.isp.belgacom.be ([195.238.20.104]:65100 "EHLO
        mailsec108.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752221AbdAaFSU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jan 2017 00:18:20 -0500
Date: Tue, 31 Jan 2017 06:18:18 +0100 (CET)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
Message-ID: <744935684.16248.1485839898758.open-xchange@webmail.nmp.proximus.be>
In-Reply-To: <20170131003033.GD9134@birch.djwong.org>
References: <20170130184844.19290-1-fabf@skynet.be> <20170131003033.GD9134@birch.djwong.org>
Subject: Re: [PATCH 14/14] xfs: use atomic_dec_not_zero()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org



> On 31 January 2017 at 01:30 "Darrick J. Wong" <darrick.wong@oracle.com> wrote:
>
>
> On Mon, Jan 30, 2017 at 07:48:44PM +0100, Fabian Frederick wrote:
> > instead of atomic_add_unless(value, -1, 0)
> >
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> > ---
> >  fs/xfs/xfs_buf.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index ac3b4db..51b2167 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -1684,7 +1684,7 @@ xfs_buftarg_isolate(
> >      * zero. If the value is already zero, we need to reclaim the
> >      * buffer, otherwise it gets another trip through the LRU.
> >      */
> > -   if (!atomic_add_unless(&bp->b_lru_ref, -1, 0)) {
> > +   if (!atomic_dec_not_zero(&bp->b_lru_ref)) {
>
> Hard to tell if this is correct, since there's no atomic_dec_not_zero
> defined in any of my kernel trees' include/ headers and I haven't seen a
> patch adding such a symbol appear on this list.  Did you hoist the
> lib/fault-inject.c definition or something?
>
> --D
Hi Darrick,

    Exactly. See patch 1 from
https://marc.info/?l=linux-kernel&m=148580166032209&w=2
at https://marc.info/?l=linux-kernel&m=148580166032208&w=2

Regards,
Fabian
>
> >             spin_unlock(&bp->b_lock);
> >             return LRU_ROTATE;
> >     }
> > --
> > 2.9.3
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
