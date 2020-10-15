Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A66A0C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 01:49:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46A5C22255
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 01:49:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=aol.com header.i=@aol.com header.b="OsH2kyFQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732367AbgJOBt1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Oct 2020 21:49:27 -0400
Received: from sonic314-20.consmr.mail.gq1.yahoo.com ([98.137.69.83]:45910
        "EHLO sonic314-20.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728240AbgJOBt0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Oct 2020 21:49:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1602726565; bh=i/HIKPCNmJWKV8/+uiy5ef1LjyGXF7G6fu1xupl5gsg=; h=Date:From:To:Cc:Subject:References:In-Reply-To:From:Subject; b=OsH2kyFQuf2lgQ7wcbRzBHla+rhx46ROyDhEiIZa8ThRgQ3yof9+9y2bmNPSGU3NajMwPsio0CqwXa86Zl+CV9V0Q+osCz4248098ixR54GzypcpsK16QiomDs9vqIIAnFaxxCjhT0u+ORDpNLo/cLWU4wntTk148ImbuPYW+mq6hhL3qeMnZENAp8TKIE0Z+e5deGaXP/oFgQarw+iyY7Rl6XkkF2CyiaeCPNpt1KhyMNCU0SqqccAs2/N+5UqjmuXlQPXziq0L3Ssjf2Clfev+RKCXKoR+6JCWjUZILH6EtapbTCAhfWBiNVTbc11RLPCF7Ak8KjHtxpmtRD1fKA==
X-YMail-OSG: zuwEqtgVM1mXeX6BD2jAedXAKWobcDD43GX9sRSJjZfLFkMAk2_wI_0c0lxyGcB
 utTq46DzxhHpOQqCumwfuyu4lRLgaL8Rn5PKFVauQgb9Hoq9UIkVfK3_Jt0j4Fm_e4aNhUywjnyH
 wCbNQYyOicpE6MpyNeWM11yXeetEKbRb1BbFW8vUpb7Xkv8k75m_oTY2y01qLVmkOs4Zog86jMdd
 j6P4agCDxMmYHC8dsN7ovjzV53M81a1.L7lLgl3oIedXxVBAoFaxCdAXQPBMGH1.y6RDJyFRpnuN
 7c1fnIaaSBHV1choyZp.JesBZGvKyciPYQihD0RwJN5rhlrXw4rjvHNUpxCJkqrrbTd6DcBKsGhg
 WZYxra3K47Qosk1EO3_yCyKhB4sczLZEtmq7uoreYLq33lgS9pmfq.Y3kzupgFqkvzmMRSz7dfF9
 4J6mq5c3mEHA4H3YHyJKHtq_TK6N_P7pmbQQX7028zOvA4hr76TU0P26cIrJUNeuLG49S9i_RzAt
 gz1TForEVTMhqSdkMnMuRFwXk81lLiF1tU6ieh1meBC7_5HW3I4lcvnk3drF2jgIAORydL.eGYDx
 nNXyh8uhYvZvXS9TDZuV7n1RXU4seztx243CCAEl3IaM4JmcgXoz8ha.rL5R_QuBS6EcA_gBsNfp
 OMu4yuX7_kexvlQ6X3RkET0Qp7QWWHIZQLLiMnepFhOKuODeXUAYzneCpJ.LtFduXQ2kxx7G57UT
 kFxhoNpIRh1k7xlhbG2k3HOdXlYBJZPXQZrXadcwBRFdEnrrxl1MD6JVhYWZVZHht6_545madTMg
 NnjTu3WuKJg6ulQQCqd3bTFggMeQ94sVhxRqjiU5jIJLM2cVuW5ZgQZQ4io4b7xjdmh5qy5POycp
 kggOcPohQzKdGfl5gRPym9vjxTYkCz74eLIngmfs_QB0SbavO0zpVBazmxMYg99OerFtETqi1_ot
 82q4TWVVjjanfFDst4Nju.cBlZgkETrLTbz2a079Lpqc7196267UMFUkaSLCEBSAwF79oGtLFglt
 pp2QQciKf3Y5oFnQ8wuqPWas7m2qko_JkW1qZCWUh.jVoJTag1e0oTNe5.38roR2Upb4f401MYUq
 pRZWIKK3CQDVZ_q4b6.CFNmGM9TvD83s_5Rsmic2xbBzyUTFbMmu1XdonbuBDJBM0DKZyK4gg__R
 BXreDOOizp_1TJxxI_YX3lW4Quo4.hMmHeYuMMI7YEdezr2txrVM_EoiI0ohaUb4YoJytAoMKkc2
 wYhbV9bGZchNbqbWqlvoZkhDjhHioPl_0E0jR_nO2n25KIYvNHrtNqvT7zrqkgUGBzuwb13Z2WkB
 t5TJqEQoeRUCb2y5b9xU2vWo.QS_jTbqvJ4TIb5gzXuomIO1YA0i8wps1MPiBbEc6Ire5hACgbzu
 MfSWT29a8CLboh1tcCggdjcdO9hZjz5K9vYA.B_NQt.Ajvq4BC.yJSf920fbL.pt3DregVzps1et
 BHH5c3yYuhf1GpjPjLvwHRUTUvU2HAq5x7Qyu5ESl9aMro5yYN5Ur1pg6V4mRiFLiEGPvfNxCzP3
 .n4FiprC47g--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.gq1.yahoo.com with HTTP; Thu, 15 Oct 2020 01:49:25 +0000
Received: by smtp402.mail.ir2.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID c4d5986aaeee1a3b8ae4ce5b3fe65deb;
          Thu, 15 Oct 2020 01:49:22 +0000 (UTC)
Date:   Thu, 15 Oct 2020 09:49:15 +0800
From:   Gao Xiang <hsiangkao@aol.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Gao Xiang <hsiangkao@redhat.com>
Subject: Re: [RFC PATCH] xfs: support shrinking unused space in the last AG
Message-ID: <20201015014908.GC7037@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <20201014005809.6619-1-hsiangkao.ref@aol.com>
 <20201014005809.6619-1-hsiangkao@aol.com>
 <20201014170139.GC1109375@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014170139.GC1109375@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mailer: WebService/1.1.16845 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol Apache-HttpAsyncClient/4.1.4 (Java/11.0.7)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Brian,

On Wed, Oct 14, 2020 at 01:01:39PM -0400, Brian Foster wrote:
> On Wed, Oct 14, 2020 at 08:58:09AM +0800, Gao Xiang wrote:
> > From: Gao Xiang <hsiangkao@redhat.com>
> > 
> > At the first step of shrinking, this attempts to enable shrinking
> > unused space in the last allocation group by fixing up freespace
> > btree, agi, agf and adjusting super block.
> > 
> > This can be all done in one transaction for now, so I think no
> > additional protection is needed.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> > 
> > Honestly, I've got headache about shrinking entire AGs
> > since the codebase doesn't expect agcount can be decreased
> > suddenly, I got some ideas from people but the modification
> > seems all over the codebase, I will keep on this at least
> > to learn more about XFS internals.
> > 
> > It might be worth sending out shrinking the last AG first
> > since users might need to shrink a little unused space
> > occasionally, yet I'm not quite sure the log space reservation
> > calculation in this patch and other details are correct.
> > I've done some manual test and it seems work. Yeah, as a
> > formal patch it needs more test to be done but I'd like
> > to hear more ideas about this first since I'm not quite
> > familiar with XFS for now and this topic involves a lot
> > new XFS-specific implementation details.
> > 
> > Kindly point out all strange places and what I'm missing
> > so I can revise it. It would be of great help for me to
> > learn more about XFS. At least just as a record on this
> > topic for further discussion.
> > 
> 
> Interesting... this seems fundamentally sane when narrowing the scope
> down to tail AG shrinking. Does xfs_repair flag any issues in the simple
> tail AG shrink case?

Yeah, I ran xfs_repair together as well, For smaller sizes, it seems
all fine, but I did observe some failure when much larger values
passed in, so as a formal patch, it really needs to be solved later.

Anyway, this patch tries to show if the overall direction is acceptable
for further development / upstream. And I could get some more
suggestion from it..

> 
> Some random initial thoughts..
> 

...

> > +int
> > +xfs_alloc_vextent_shrink(
> > +	struct xfs_trans	*tp,
> > +	struct xfs_buf		*agbp,
> > +	xfs_agblock_t		agbno,
> > +	xfs_extlen_t		len)
> > +{
> > +	struct xfs_mount	*mp = tp->t_mountp;
> > +	xfs_agnumber_t		agno = agbp->b_pag->pag_agno;
> > +	struct xfs_alloc_arg	args = {
> > +		.tp = tp,
> > +		.mp = mp,
> > +		.type = XFS_ALLOCTYPE_THIS_BNO,
> > +		.agbp = agbp,
> > +		.agno = agno,
> > +		.agbno = agbno,
> > +		.fsbno = XFS_AGB_TO_FSB(mp, agno, agbno),
> > +		.minlen = len,
> > +		.maxlen = len,
> > +		.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE,
> > +		.resv = XFS_AG_RESV_NONE,
> > +		.prod = 1,
> > +		.alignment = 1,
> > +		.pag = agbp->b_pag
> > +	};
> > +	int			error;
> > +
> > +	error = xfs_alloc_ag_vextent_exact(&args);
> > +	if (error || args.agbno == NULLAGBLOCK)
> > +		return -EBUSY;
> 
> I think it's generally better to call into the top-level allocator API
> (xfs_alloc_vextent()) because it will handle internal allocator business
> like fixing up the AGFL and whatnot. Then you probably don't have to
> specify as much in the args structure as well. The allocation mode
> you've specified (THIS_BNO) will fall into the exact allocation codepath
> and should enforce the semantics we need here (i.e. grant the exact
> allocation or fail).

Actually, I did in the same way (use xfs_alloc_vextent()) in my previous
hack version
https://git.kernel.org/pub/scm/linux/kernel/git/xiang/linux.git/commit/?id=65d87d223a4d984441453659f1baeca560f07de4

yet Dave pointed out in private agfl fix could dirty the transaction
and if the later allocation fails, it would be unsafe to cancel
the dirty transaction. So as far as my current XFS knowledge, I think
that makes sense so I introduce a separate helper
xfs_alloc_vextent_shrink()...

I tend to avoid bury all shrinking specfic logic too deep in the large
xfs_alloc_vextent() logic by using another new bool or something
since it's rather complicated for now.

Intoduce a new helper would make this process more straight-forward
and bug less in the future IMO... Just my own current thought about
this...

> 
> I also wonder if we'll eventually have to be more intelligent here in
> scenarios where ag metadata (i.e., free space root blocks, etc.) or the
> agfl holds blocks in a range we're asked to shrink. I think those are
> scenarios where such an allocation request would fail even though the
> blocks are internal or technically free. Have you explored such
> scenarios so far? I know we're trying to be opportunistic here, but if
> the AG (or subset) is otherwise empty it seems a bit random to fail.
> Hmm, maybe scrub/repair could help to reinit/defrag such an AG if we
> could otherwise determine that blocks beyond a certain range are unused
> externally.

Yeah, currently I don't tend to defrag or fix agfl in the process but rather
on shrinking unused space (not in AGFL) and make the kernel side simplier,
since I think for the long term we could have 2 options by some combination
with the userspace prog:
 - lock the AG, defrag / move the AG, shrinking, unlock the AG;
 - defrag / move the AG, shrinking, retry.

> > +

...

> >  	new = nb;	/* use new as a temporary here */
> >  	nb_mod = do_div(new, mp->m_sb.sb_agblocks);
> > @@ -56,10 +58,18 @@ xfs_growfs_data_private(
> >  	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
> >  		nagcount--;
> >  		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
> > -		if (nb < mp->m_sb.sb_dblocks)
> > +		if (!nagcount)
> >  			return -EINVAL;
> >  	}
> 
> We probably need to rethink the bit of logic above this check for
> shrinking. It looks like the current code checks for the minimum
> supported AG size and if not satisfied, reduces the size the grow to the
> next smaller AG count. That would actually increase the size of the
> shrink from what the user requested, so we'd probably want to do the
> opposite and reduce the size of the requested shrink. For now it
> probably doesn't matter much since we fail to shrink the agcount.
> 
> That said, if I'm following the growfs behavior correctly it might be
> worth considering analogous behavior for shrink. E.g., if the user asks
> to trim 10GB off the last AG but only the last 4GB are free, then shrink
> the fs by 4GB and report the new size to the user.

I thought about this topic as well, yeah, anyway, I think it needs
some clearer documented words about the behavior (round down or round
up). My original idea is to unify them. But yeah, increase the size
of the shrink might cause unexpected fail.

> 
> > -	new = nb - mp->m_sb.sb_dblocks;
> > +
> > +	if (nb > mp->m_sb.sb_dblocks) {
> > +		new = nb - mp->m_sb.sb_dblocks;
> > +		extend = true;
> > +	} else {
> > +		new = mp->m_sb.sb_dblocks - nb;
> > +		extend = false;
> > +	}
> > +
> 
> s/new/delta (or something along those lines) might be more readable if
> we go this route.

In my previous random version, I once renamed it to bdelta, but I found
the modification is large, I might need to clean up growfs naming first.

> 
> >  	oagcount = mp->m_sb.sb_agcount;
> >  
> >  	/* allocate the new per-ag structures */
> > @@ -67,10 +77,14 @@ xfs_growfs_data_private(
> >  		error = xfs_initialize_perag(mp, nagcount, &nagimax);
> >  		if (error)
> >  			return error;
> > +	} else if (nagcount != oagcount) {
> > +		/* TODO: shrinking a whole AG hasn't yet implemented */
> > +		return -EINVAL;
> >  	}
> >  
> >  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
> > -			XFS_GROWFS_SPACE_RES(mp), 0, XFS_TRANS_RESERVE, &tp);
> > +			(extend ? 0 : new) + XFS_GROWFS_SPACE_RES(mp), 0,
> > +			XFS_TRANS_RESERVE, &tp);
> >  	if (error)
> >  		return error;
> >  
> > @@ -103,15 +117,22 @@ xfs_growfs_data_private(
> >  			goto out_trans_cancel;
> >  		}
> >  	}
> > -	error = xfs_buf_delwri_submit(&id.buffer_list);
> > -	if (error)
> > -		goto out_trans_cancel;
> > +
> > +	if (!list_empty(&id.buffer_list)) {
> > +		error = xfs_buf_delwri_submit(&id.buffer_list);
> > +		if (error)
> > +			goto out_trans_cancel;
> > +	}
> 
> The list check seems somewhat superfluous since we won't do anything
> with an empty list anyways. Presumably it would be incorrect to ever
> init a new AG on shrink so it might be cleaner to eventually refactor
> this bit of logic out into a helper that we only call on extend since
> this is a new AG initialization mechanism.

Yeah, actually my previous hack version
https://git.kernel.org/pub/scm/linux/kernel/git/xiang/linux.git/commit/?id=65d87d223a4d984441453659f1baeca560f07de4

did like this, but in this version I'd like to avoid touching unrelated
topic as much as possible.

xfs_buf_delwri_submit() is not no-op for empty lists. Anyway, I will
use 2 independent logic for entire extend / shrink seperately.

Thanks for your suggestion!

Thanks,
Gao Xiang

> 
> Brian

