Return-Path: <SRS0=Vfs/=DQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B2D4C433E7
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 00:49:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F025622257
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 00:49:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729681AbgJIAtk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 20:49:40 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45389 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725979AbgJIAtk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Oct 2020 20:49:40 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id C05865C014F;
        Thu,  8 Oct 2020 20:49:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 08 Oct 2020 20:49:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        PSjqJctJMLnzaTxvwnvbPHf/AHrbYXUQoD78m9Zvg7s=; b=MQmhzRYOSmn02r5l
        9AL9LOON2SLYd/H5p/xUKbRhc8wgcdUR06xoGoQHQY71VQ6w0aTln6bgOWxs1u0/
        S8JvsqNMZ9colsHb2OX/Z7DrV6z3FmwhDQS5HFMydQQ8k+4Pryxmw9DGmVXLWirE
        IGnnjNNSWgO2bYco/H3DFo/At4SActJDgC173tB2pxws32zgBW1Pjag93JX8MQKH
        k3RBNoDK8euLhYEiDxmavLCZn7nW5Kj6TrQBcEtOBiCUPG7mcC9z8kCSQpEUn6l9
        u/LsInzs/XDFr4vtcEg7yYyeRP2hez/Q6Z7Mq2Lr5UrDOKKXouTRnv6x/kkOIizb
        1Yx1sA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=PSjqJctJMLnzaTxvwnvbPHf/AHrbYXUQoD78m9Zvg
        7s=; b=oqWGFly3z0oIMMYmOfWVz+09MJRTCQX5934oDjdbzlbNHV1uwY/z8/72a
        brizYQTnUqPtnEZ6a1+Ea2h9ftNX0x/bQPEcV3T/Hg+iu3CcZ/p344sGFKDXb/Wr
        6/0eCPNvUwDFuFJRTgVcqpWokuwmNCv0X0Gh32Yw9C88sLrPwSbZ+fVJbflikze5
        KRUgBKSL2pENyqz8rX+9dEFbN6SWKlKMmSozW9NDVz+NRTe0SM0/NRXAjrK2G62X
        Jeq0dZ2lQA4PSe++rmBmajuMcCZCdd+5hxkmUCQm1sBX/bVhOjVN3RbUY8QAx6SI
        k+hcbyk7IacuK41Z+NPLXZljc+GCg==
X-ME-Sender: <xms:orN_X-z7WFKLDgRc22UYtvUlk4Qy5ratLrHvEd_cI92qJTer1sqUmQ>
    <xme:orN_X6Rnvy9Cg-9mWIiKS_0mmcwKraq5P0muIPQMA4kH5Z_p_2JXR5fvVlKpsHCdz
    M25e7wcOTfb>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrhedtgdeflecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecuggftrfgrthhtvghrnhepfe
    efteetvdeguddvveefveeftedtffduudehueeihfeuvefgveehffeludeggfejnecukfhp
    pedutdeirdeiledrvddvhedrudefkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgrfidrnhgvth
X-ME-Proxy: <xmx:orN_XwXRLAYEScKZubkdOmrN2d3DqOEmbU6SMc10GU6QDCplNo7CNw>
    <xmx:orN_X0jpXjAR4YUmSGaPsOm3hRXfxftBV7u9g-y-f63Vw7OmaDN1-Q>
    <xmx:orN_XwDIo5jErnF_sLxvvRarWhamWlOwFMdY5XPuYmpDDDhocPpOqA>
    <xmx:orN_XzN4XGt9IKXwpGACL3nGCqqkVfIHctP0IgEbN062Rul2YVFM9g>
Received: from mickey.themaw.net (106-69-225-138.dyn.iinet.net.au [106.69.225.138])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4F350328005A;
        Thu,  8 Oct 2020 20:49:37 -0400 (EDT)
Message-ID: <478810599529de17d3d3fe2962171ba16580547c.camel@themaw.net>
Subject: Re: [PATCH] xfsprogs: ignore autofs mount table entries
From:   Ian Kent <raven@themaw.net>
To:     Eric Sandeen <sandeen@sandeen.net>, xfs <linux-xfs@vger.kernel.org>
Date:   Fri, 09 Oct 2020 08:49:32 +0800
In-Reply-To: <c3e211d0-48d7-c26f-b64d-b730fe997c4b@sandeen.net>
References: <160212194125.16851.17467120219710843339.stgit@mickey.themaw.net>
         <c3e211d0-48d7-c26f-b64d-b730fe997c4b@sandeen.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2020-10-08 at 15:03 -0500, Eric Sandeen wrote:
> On 10/7/20 8:52 PM, Ian Kent wrote:
> > Some of the xfsprogs utilities read the mount table via.
> > getmntent(3).
> > 
> > The mount table may contain (almost always these days since
> > /etc/mtab is
> > symlinked to /proc/self/mounts) autofs mount entries. During
> > processing
> > of the mount table entries statfs(2) can be called on mount point
> > paths
> > which will trigger an automount if those entries are direct or
> > offset
> > autofs mount triggers (indirect autofs mounts aren't affected).
> > 
> > This can be a problem when there are a lot of autofs direct or
> > offset
> > mounts because real mounts will be triggered when statfs(2) is
> > called.
> > This can be particularly bad if the triggered mounts are NFS mounts
> > and
> > the server is unavailable leading to lengthy boot times or worse.
> > 
> > Simply ignoring autofs mount entries during getmentent(3)
> > traversals
> > avoids the statfs() call that triggers these mounts. If there are
> > automounted mounts (real mounts) at the time of reading the mount
> > table
> > these will still be seen in the list so they will be included if
> > that
> > actually matters to the reader.
> > 
> > Recent glibc getmntent(3) can ignore autofs mounts but that
> > requires the
> > autofs user to configure autofs to use the "ignore" pseudo mount
> > option
> > for autofs mounts. But this isn't yet the autofs default (to
> > prevent
> > unexpected side effects) so that can't be used.
> > 
> > The autofs direct and offset automount triggers are pseudo file
> > system
> > mounts and are more or less useless in terms on file system
> > information
> > so excluding them doesn't sacrifice useful file system information
> > either.
> > 
> > Consequently excluding autofs mounts shouldn't have any adverse
> > side
> > effects.
> 
> (usually this'd go below the "---")
> 
> > Changes since v1:
> > - drop hunk from fsr/xfs_fsr.c.
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > ---
> >  libfrog/linux.c |    2 ++
> >  libfrog/paths.c |    2 ++
> >  2 files changed, 4 insertions(+)
> > 
> > diff --git a/libfrog/linux.c b/libfrog/linux.c
> > index 40a839d1..a45d99ab 100644
> > --- a/libfrog/linux.c
> > +++ b/libfrog/linux.c
> > @@ -73,6 +73,8 @@ platform_check_mount(char *name, char *block,
> > struct stat *s, int flags)
> >  	 * servers.  So first, a simple check: does the "dev" start
> > with "/" ?
> >  	 */
> >  	while ((mnt = getmntent(f)) != NULL) {
> > +		if (!strcmp(mnt->mnt_type, "autofs"))
> > +			continue;
> 
> I may change the order of this test and the next, just so it
> continues to
> align with the comment above.  Shouldn't make any difference, right?

Yep, no difference to resolving the problem.

The only reason for it to be first is cases where there's say, 40 or
50 mounts and a thousand or more autofs direct mounts. Then every
test you do before skipping the autofs entry adds a thousand or more
tests to the traversal.

Ian
> 
> Otherwise:
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> >  		if (mnt->mnt_fsname[0] != '/')
> >  			continue;
> >  		if (stat(mnt->mnt_dir, &mst) < 0)
> > diff --git a/libfrog/paths.c b/libfrog/paths.c
> > index 32737223..d6793764 100644
> > --- a/libfrog/paths.c
> > +++ b/libfrog/paths.c
> > @@ -389,6 +389,8 @@ fs_table_initialise_mounts(
> >  			return errno;
> >  
> >  	while ((mnt = getmntent(mtp)) != NULL) {
> > +		if (!strcmp(mnt->mnt_type, "autofs"))
> > +			continue;
> >  		if (!realpath(mnt->mnt_dir, rmnt_dir))
> >  			continue;
> >  		if (!realpath(mnt->mnt_fsname, rmnt_fsname))
> > 
> > 

