Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66A65C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Sep 2022 18:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234889AbiI2SBi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Sep 2022 14:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234827AbiI2SBh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2022 14:01:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FAA6CD1E8
        for <linux-xfs@vger.kernel.org>; Thu, 29 Sep 2022 11:01:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59B3562127
        for <linux-xfs@vger.kernel.org>; Thu, 29 Sep 2022 18:01:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8C0C433D7;
        Thu, 29 Sep 2022 18:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664474492;
        bh=p3+pKJHf9NAP+VXgXqk6GZzd+6qWx7goUQmZn09+K1A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WO5izVTiH2prFA6fbxlDbiXsW15cgelhXZdZ+SPKmnKaqNdxvDfA6Mdvo1xBYZlWp
         J2ZV9AoVBG5YcoKfohd+r3EILyeby2VkKO3gZazC+0fS4l6dQqTaPQn+ZsfG1JYBDE
         wbOzFf0J8RKbMV++IfJRAE0wJEwNFak3XEBnt/Ieeei2+AM6zzEkv//HmS60jGtgJY
         4CRWQQnOuyVduzujcia4f4fWE2rkYMaHHjiM2QJcqphdtehRSwSKBYfGEMxCBQDimc
         KEUAJP823on3Ju7KSMnrGzjr55DTFHvh1vFylDhiMchcGaX50oUz27plrkW4jlhedD
         nHoO4QRYGi9dw==
Date:   Thu, 29 Sep 2022 11:01:32 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Donald Douwsma <ddouwsma@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfsrestore: stobj_unpack_sessinfo cleanup
Message-ID: <YzXdfA9wqVopEVMV@magnolia>
References: <20220928055307.79341-1-ddouwsma@redhat.com>
 <20220928055307.79341-3-ddouwsma@redhat.com>
 <YzRm86tcCc2m+YeX@magnolia>
 <244f6cfb-41f1-ceea-2cc5-c44dcaa14515@redhat.com>
 <b3197f6d-a762-26d5-ca67-3a220fe21b9a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b3197f6d-a762-26d5-ca67-3a220fe21b9a@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 29, 2022 at 09:28:24AM +1000, Donald Douwsma wrote:
> 
> 
> On 29/09/2022 09:12, Donald Douwsma wrote:
> > 
> > 
> > On 29/09/2022 01:23, Darrick J. Wong wrote:
> > > On Wed, Sep 28, 2022 at 03:53:06PM +1000, Donald Douwsma wrote:
> > > > stobj_unpack_sessinfo should be the reverse of stobj_pack_sessinfo, make
> > > > this clearer with respect to the session header and streams processing.
> > > > 
> > > > signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
> > > > ---
> > > >   inventory/inv_stobj.c | 13 +++++++------
> > > >   1 file changed, 7 insertions(+), 6 deletions(-)
> > > > 
> > > > diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
> > > > index 5075ee4..521acff 100644
> > > > --- a/inventory/inv_stobj.c
> > > > +++ b/inventory/inv_stobj.c
> > > > @@ -1065,25 +1065,26 @@ stobj_unpack_sessinfo(
> > > >           return BOOL_FALSE;
> > > >       }
> > > > +    /* get the seshdr and then, the remainder of the session */
> > > >       xlate_invt_seshdr((invt_seshdr_t *)p, (invt_seshdr_t *)tmpbuf, 1);
> > > >       bcopy(tmpbuf, p, sizeof(invt_seshdr_t));
> > > > -
> > > > -    /* get the seshdr and then, the remainder of the session */
> > > >       s->seshdr = (invt_seshdr_t *)p;
> > > >       s->seshdr->sh_sess_off = -1;
> > > >       p += sizeof(invt_seshdr_t);
> > > > -
> > > >       xlate_invt_session((invt_session_t *)p, (invt_session_t
> > > > *)tmpbuf, 1);
> > > >       bcopy (tmpbuf, p, sizeof(invt_session_t));
> > > >       s->ses = (invt_session_t *)p;
> > > >       p += sizeof(invt_session_t);
> > > >       /* the array of all the streams belonging to this session */
> > > > -    xlate_invt_stream((invt_stream_t *)p, (invt_stream_t *)tmpbuf, 1);
> > > > -    bcopy(tmpbuf, p, sizeof(invt_stream_t));
> > > >       s->strms = (invt_stream_t *)p;
> > > > -    p += s->ses->s_cur_nstreams * sizeof(invt_stream_t);
> > > > +    for (i = 0; i < s->ses->s_cur_nstreams; i++) {
> > > > +        xlate_invt_stream((invt_stream_t *)p,
> > > 
> > > Nit: trailing whitespace                        here ^
> > 
> > nod
> > 
> > > 
> > > > +                  (invt_stream_t *)tmpbuf, 1);
> > > > +        bcopy(tmpbuf, p, sizeof(invt_stream_t));
> > > > +        p += sizeof(invt_stream_t);
> > > 
> > > Ok, so we translate p into tmpbuf, then bcopy tmpbuf back to p.  That
> > > part makes sense, but I am puzzled by what stobj_pack_sessinfo does:
> > > 
> > >     for (i = 0; i < ses->s_cur_nstreams; i++) {
> > >         xlate_invt_stream(strms, (invt_stream_t *)sesbuf, 1);
> > >         sesbuf += sizeof(invt_stream_t);
> > >     }
> > > 
> > > Why isn't that callsite xlate_invt_stream(&strms[i], ...); ?
> > 
> > Thanks! Yes, that's wrong, like the existing code it only worked/works
> > because there's only ever one stream. From the manpage "The third level
> > is media stream (currently only one  stream is supported)". Will fix.
> 
> Or should I just drop this clean-up? I think what I'm saying is right,
> but its a clean-up for a feature that cant be used. I doubt anyone is
> going to add multiple stream support now, whatever that was intended
> for.

I don't know.  On the one hand I could see an argument for at least
being able to restore multiple streams, but then the dump program has
been screwing that up for years and nobody noticed.  I can't tell from
the source code what shape the multistream support is in, so I guess you
have some research to do? <shrug>  I suppose you could see what happens
if you try to set up multiple streams, but I have no idea ... what that
means.

Sorry that's a nonanswer. :(

--D

> 
> > 
> > > 
> > > --D
> > > 
> > > > +    }
> > > >       /* all the media files */
> > > >       s->mfiles = (invt_mediafile_t *)p;
> > > > -- 
> > > > 2.31.1
> > > > 
> > > 
> 
