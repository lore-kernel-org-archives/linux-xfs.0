Return-Path: <SRS0=RTOF=DJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FE76C4727E
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 02:55:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA943206CA
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 02:55:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387485AbgJBCz5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Oct 2020 22:55:57 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53687 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727780AbgJBCz5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Oct 2020 22:55:57 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 5F5125C00BE;
        Thu,  1 Oct 2020 22:55:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 01 Oct 2020 22:55:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        pF0lPxYWJ5a1YaqNzAEoXw+s9xm9l4GovIVM6mp+SvQ=; b=Lm4DUPQCXZ4E4wUu
        R8OTKTgSBHWvGu4GV/CC59xhX0kz2Un4PouX+WCJbjqNpc1HNG/F3hvzoy9qbQbH
        D5wgpSSaRdMsm89LcRupwhJyzafhumR17VRZ+ffjzSsepzrgRgdTQnYjd8hH3qI9
        mQZJes14dteiGnjVqKklRf3cS9viMHe2b6D4CQziSCaxyVaGFfkR9waSXK90YRo+
        jZuw3GskAnqYHwUkjFM/m/crmxZXsE59abbXdlnSbQpjnr2bukyKC3+D2vUiM8ln
        nZf/mtmNkTyzCh9kOzd8Ghr6lJOKJql0XTKfAju+2iQ+mzxUiDYq+CNgmsB/q+e6
        GJfRzg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=pF0lPxYWJ5a1YaqNzAEoXw+s9xm9l4GovIVM6mp+S
        vQ=; b=mDy2VGNmuMZdDMOgJsOTECyuRH9rKfG1BJeIMdVgb2AdcymN6GZE0nuQT
        +Y81x9GX2+5xjO9/A1Pqem9TvUXzVbR2rkMRv37r5iOjbNDlYk5CFIQ6WwpIMMpd
        plbHFs7K3/Fex43TYtbvfCocN77+D/XC+QX05W8V0PXHhBf8iVLq5ClEtxrmfWvC
        2ScIyMK2h36/8tPIkeQjn2asM+PwHqfu9C4hIz7IZRjXZSYNJnICHWtcKOaL25K/
        5X67hkdvAzRD4l7bpbeXwAULWxDIidey1YFgY1SSfQ1PfsfyVRKuLkk1xFmkQFSE
        /IpcC4pV29LUCMjXwxhk2zkbJhWLw==
X-ME-Sender: <xms:vJZ2X5n4Ed5x9jzkrZvJ_E--vnYEhGmKQWDww_9zqg8wBVDObUa2oQ>
    <xme:vJZ2X01rAtZF7a1kmy0Q7iX2ssYfqxkTd-gFUS3a9kEKU_HFkHc1P8hIeDgrDAGxh
    XsrHGI3vJ3q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrfeehgdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecuggftrfgrthhtvghrnhepfe
    efteetvdeguddvveefveeftedtffduudehueeihfeuvefgveehffeludeggfejnecukfhp
    pedutdeirdeiledrvdefledrvdehfeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgrfidrnhgvth
X-ME-Proxy: <xmx:vJZ2X_o1y_NDJo4rfVhgytgQdrno4urVTzYfV5Jwowdve3_Gnv70iA>
    <xmx:vJZ2X5kDYDNygOeU-W-PzKKg2ga92Orc4xoIVqJ0E3J4cKAUsXF1CQ>
    <xmx:vJZ2X33CbF6A6H0zZytI54HCjW8l5vMlCTtfm4H86mv5wJ0GZuifaQ>
    <xmx:vJZ2X8ja2dvM8fG0thYzVcbBDz2QV0pY6gu8AsUf4vmDQoYwKhjNcA>
Received: from mickey.themaw.net (106-69-239-253.dyn.iinet.net.au [106.69.239.253])
        by mail.messagingengine.com (Postfix) with ESMTPA id 53370328005E;
        Thu,  1 Oct 2020 22:55:54 -0400 (EDT)
Message-ID: <ecd3089cb216798851d61678c85286553962a4bb.camel@themaw.net>
Subject: Re: [PATCH] xfsprogs: ignore autofs mount table entries
From:   Ian Kent <raven@themaw.net>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>
Date:   Fri, 02 Oct 2020 10:55:49 +0800
In-Reply-To: <20201001151942.GP49547@magnolia>
References: <160151439137.66595.8436234885474855194.stgit@mickey.themaw.net>
         <20201001151942.GP49547@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2020-10-01 at 08:19 -0700, Darrick J. Wong wrote:
> On Thu, Oct 01, 2020 at 09:06:31AM +0800, Ian Kent wrote:
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
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > ---
> >  fsr/xfs_fsr.c   |    3 +++
> >  libfrog/linux.c |    2 ++
> >  libfrog/paths.c |    2 ++
> >  3 files changed, 7 insertions(+)
> > 
> > diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> > index 77a10a1d..466ad9e4 100644
> > --- a/fsr/xfs_fsr.c
> > +++ b/fsr/xfs_fsr.c
> > @@ -323,6 +323,9 @@ initallfs(char *mtab)
> >  	while ((mnt = platform_mntent_next(&cursor)) != NULL) {
> >  		int rw = 0;
> >  
> > +		if (!strcmp(mnt->mnt_type, "autofs"))
> > +			continue;
> 
> Hmm...  the libfrog changes look decent, but it strikes me as a
> little
> odd that we don't just make platform_mntent_next filter that out?

Perhaps, but is that a better idea?

Putting special case checks in the body of the loop stands out to
a reader but buried away in platform_mntent_next() it could easily
be missed by implicit assumptions about what platform_mntent_next()
should do.

As Eric pointed out there's an explicit check for an xfs fs right
below this in the body of the loop and even that wasn't enough to
get my attention ... but hey, more haste less speed ... ;)

Ian

> 
> (Or I guess refactor fsr to use the fs table...)
> 
> OTOH "Not _another_ herring^Wrefactor!"
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D
> 
> > +
> >  		if (strcmp(mnt->mnt_type, MNTTYPE_XFS ) != 0 ||
> >  		    stat(mnt->mnt_fsname, &sb) == -1 ||
> >  		    !S_ISBLK(sb.st_mode))
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
> > +			^continue;
> >  		if (!realpath(mnt->mnt_dir, rmnt_dir))
> >  			continue;
> >  		if (!realpath(mnt->mnt_fsname, rmnt_fsname))
> > 
> > 

