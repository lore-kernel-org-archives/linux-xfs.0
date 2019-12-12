Return-Path: <SRS0=0MSb=2C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA529C43603
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 22:46:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD54D22527
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 22:46:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mQC0Xvzm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731007AbfLLWq0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Dec 2019 17:46:26 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51462 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730707AbfLLWq0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Dec 2019 17:46:26 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBCMiDQp080238;
        Thu, 12 Dec 2019 22:46:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=UpOYe5/eemoqvnNgJueQwccjL5Kfdfpw+LyjP29qFxc=;
 b=mQC0XvzmA7/DzwZ5r6rGx9g4oJcPMeqgoMN3lJQT2/xp4bVBDGDius9wZ/ZPuAOOYR5n
 XrtJ6JSx/DURw69VRIYEv33vC3X9gFTRA9CC4DyFP48Eh9ogQ0gQEG8S/iRjQHuAoe/W
 VcKJ9wl8S8UEzn7cJGvvWxWY/oMtRDRayO7DEU7waeaGTc+vXgwaYywFSbLVAh8oHV4w
 ao7Y6lsqraonu2BPSNUH3sP1nfN+OME46gg2E4BWYp5QgzwsUQChddiMMvCbuU65uzZE
 8WLPilCaJSja7yKAmiogJ2tK1aXNwowEd9sKUHlCvx0E3KhLOB7M6u6l62Sco1x5lmzz Xw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2wrw4njtxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 22:46:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBCMiKq3019999;
        Thu, 12 Dec 2019 22:46:21 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2wumw1yv7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 22:46:21 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBCMkJIX007684;
        Thu, 12 Dec 2019 22:46:19 GMT
Received: from localhost (/10.145.178.64)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Dec 2019 14:46:19 -0800
Date:   Thu, 12 Dec 2019 14:46:18 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, alex@zadara.com
Subject: Re: [PATCH 6/6] xfs_repair: check plausibility of root dir pointer
 before trashing it\
Message-ID: <20191212224618.GE99875@magnolia>
References: <157547906289.974712.8933333382010386076.stgit@magnolia>
 <157547910268.974712.78208912903649937.stgit@magnolia>
 <20191205143858.GF48368@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191205143858.GF48368@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9469 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912120174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9469 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912120174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 05, 2019 at 09:38:58AM -0500, Brian Foster wrote:
> On Wed, Dec 04, 2019 at 09:05:02AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > If sb_rootino doesn't point to where we think mkfs should have allocated
> > the root directory, check to see if the alleged root directory actually
> > looks like a root directory.  If so, we'll let it live because someone
> > could have changed sunit since formatting time, and that changes the
> > root directory inode estimate.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  repair/xfs_repair.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 45 insertions(+)
> > 
> > 
> > diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> > index abd568c9..b0407f4b 100644
> > --- a/repair/xfs_repair.c
> > +++ b/repair/xfs_repair.c
> > @@ -426,6 +426,37 @@ _("would reset superblock %s inode pointer to %"PRIu64"\n"),
> >  	*ino = expected_ino;
> >  }
> >  
> > +/* Does the root directory inode look like a plausible root directory? */
> > +static bool
> > +has_plausible_rootdir(
> > +	struct xfs_mount	*mp)
> > +{
> > +	struct xfs_inode	*ip;
> > +	xfs_ino_t		ino;
> > +	int			error;
> > +	bool			ret = false;
> > +
> > +	error = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &ip,
> > +			&xfs_default_ifork_ops);
> > +	if (error)
> > +		goto out;
> > +	if (!S_ISDIR(VFS_I(ip)->i_mode))
> > +		goto out_rele;
> > +
> > +	error = -libxfs_dir_lookup(NULL, ip, &xfs_name_dotdot, &ino, NULL);
> > +	if (error)
> > +		goto out_rele;
> > +
> > +	/* The root directory '..' entry points to the directory. */
> > +	if (ino == mp->m_sb.sb_rootino)
> > +		ret = true;
> > +
> > +out_rele:
> > +	libxfs_irele(ip);
> > +out:
> > +	return ret;
> > +}
> > +
> >  /*
> >   * Make sure that the first 3 inodes in the filesystem are the root directory,
> >   * the realtime bitmap, and the realtime summary, in that order.
> > @@ -436,6 +467,20 @@ calc_mkfs(
> >  {
> >  	xfs_ino_t		rootino = libxfs_ialloc_calc_rootino(mp, -1);
> >  
> > +	/*
> > +	 * If the root inode isn't where we think it is, check its plausibility
> > +	 * as a root directory.  It's possible that somebody changed sunit
> > +	 * since the filesystem was created, which can change the value of the
> > +	 * above computation.  Don't blow up the root directory if this is the
> > +	 * case.
> > +	 */
> > +	if (mp->m_sb.sb_rootino != rootino && has_plausible_rootdir(mp)) {
> > +		do_warn(
> > +_("sb root inode value %" PRIu64 " inconsistent with alignment (expected %"PRIu64")\n"),
> > +			mp->m_sb.sb_rootino, rootino);
> > +		rootino = mp->m_sb.sb_rootino;
> > +	}
> > +
> 
> A slightly unfortunate side effect of this is that there's seemingly no
> straightforward way for a user to "clear" this state/warning. We've
> solved the major problem by allowing repair to handle this condition,
> but AFAICT this warning will persist unless the stripe unit is changed
> back to its original value.

Heh, I apparently never replied to this. :(

> IOW, what if this problem exists simply because a user made a mistake
> and wants to undo it? It's probably easy enough for us to say "use
> whatever you did at mkfs time," but what if that's unknown or was set
> automatically? I feel like that is the type of thing that in practice
> could result in unnecessary bugs or error reports unless the tool can
> make a better suggestion to the end user. For example, could we check
> the geometry on secondary supers (if they exist) against the current
> rootino and use that as a secondary form of verification and/or suggest
> the user reset to that geometry (if desired)?

That sounds reasonable.

> OTOH, I guess we'd have to consider what happens if the filesystem was
> grown in that scenario too..  :/

I think it would be fine, so long as we're careful with the if-then
chain.  Specifically:

a. If we dislike the rootino that we compute with the ondisk sunit value,
and...

b. The thing sb_rootino points to actually does look like the root
directory, and...

c. One of the secondary supers has an sunit value that gives us a
rootino calculation that matches the sb_rootino that we just checked
out...

...then we'll propose correcting the primary sb_unit to the value we
found in (c).

> 
> (Actually on a quick test, it looks like growfs updates every super,
> even preexisting..).

I'll throw that onto the V3 series.

--D

> 
> Brian
> 
> >  	ensure_fixed_ino(&mp->m_sb.sb_rootino, rootino,
> >  			_("root"));
> >  	ensure_fixed_ino(&mp->m_sb.sb_rbmino, rootino + 1,
> > 
> 
