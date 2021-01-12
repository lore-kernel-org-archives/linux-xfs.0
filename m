Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 642D9C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 01:22:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31B2D22EBF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 01:22:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbhALBWt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 20:22:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:52824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729308AbhALBWt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jan 2021 20:22:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A741E22DFB;
        Tue, 12 Jan 2021 01:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610414528;
        bh=nEwJqx89tUfo3ZJejhF6+cLt/1XFKCct6Iclk3D71VY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rA8drLW0FcRB4rOFCJUS5MaTDjPtkEDi0PCd3JUfVvKFRN+hGa6H3OOKm10XISgF6
         dHSkGE07rCCPWo5BbXxbfmATNiEX1OFtYwfYNSGsvImGI11aP9jgmLrsQVhHsPwKrJ
         Tolm/mIjL0tAttI0ja6u9GsUo0CdjGtajXqGJE5Du5ytnnUwhrWK8GgmcFhVLClQJy
         2WrdKgld+YR6jeXEMdDbkjwqB9HU8nxbCvy42+lafcgrO9L2aeynIoNmi8m3cvjU1I
         WnQtBcX+TQUkYmWSapwkKByKpVGAidgcwKMiJT4TWKNALGyZwAdl6gqsLnMCcPUzbD
         KwQ9YkAr6xDDA==
Date:   Mon, 11 Jan 2021 17:22:08 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     sandeen@sandeen.net, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] misc: fix valgrind complaints
Message-ID: <20210112012208.GH1164246@magnolia>
References: <161017371478.1142776.6610535704942901172.stgit@magnolia>
 <161017372088.1142776.17470250928392025583.stgit@magnolia>
 <871rerpp9o.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871rerpp9o.fsf@garuda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 07:08:27PM +0530, Chandan Babu R wrote:
> 
> On 09 Jan 2021 at 11:58, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> >
> > Zero the memory that we pass to the kernel via ioctls so that we never
> > pass userspace heap/stack garbage around.  This silences valgrind
> > complaints about uninitialized padding areas.
> >
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  libhandle/handle.c |    7 ++++++-
> >  scrub/inodes.c     |    1 +
> >  scrub/spacemap.c   |    2 +-
> >  3 files changed, 8 insertions(+), 2 deletions(-)
> >
> >
> > diff --git a/libhandle/handle.c b/libhandle/handle.c
> > index 5c1686b3..a6b35b09 100644
> > --- a/libhandle/handle.c
> > +++ b/libhandle/handle.c
> > @@ -235,9 +235,12 @@ obj_to_handle(
> >  {
> >  	char		hbuf [MAXHANSIZ];
> >  	int		ret;
> > -	uint32_t	handlen;
> > +	uint32_t	handlen = 0;
> >  	xfs_fsop_handlereq_t hreq;
> >
> > +	memset(&hreq, 0, sizeof(hreq));
> > +	memset(hbuf, 0, MAXHANSIZ);
> > +
> >  	if (opcode == XFS_IOC_FD_TO_HANDLE) {
> >  		hreq.fd      = obj.fd;
> >  		hreq.path    = NULL;
> > @@ -280,6 +283,7 @@ open_by_fshandle(
> >  	if ((fsfd = handle_to_fsfd(fshanp, &path)) < 0)
> >  		return -1;
> >
> > +	memset(&hreq, 0, sizeof(hreq));
> >  	hreq.fd       = 0;
> >  	hreq.path     = NULL;
> >  	hreq.oflags   = rw | O_LARGEFILE;
> > @@ -387,6 +391,7 @@ attr_list_by_handle(
> >  	if ((fd = handle_to_fsfd(hanp, &path)) < 0)
> >  		return -1;
> >
> > +	memset(&alhreq, 0, sizeof(alhreq));
> >  	alhreq.hreq.fd       = 0;
> >  	alhreq.hreq.path     = NULL;
> >  	alhreq.hreq.oflags   = O_LARGEFILE;
> > diff --git a/scrub/inodes.c b/scrub/inodes.c
> > index 4550db83..f2bce16f 100644
> > --- a/scrub/inodes.c
> > +++ b/scrub/inodes.c
> > @@ -129,6 +129,7 @@ scan_ag_inodes(
> >  				minor(ctx->fsinfo.fs_datadev),
> >  				agno);
> >
> > +	memset(&handle, 0, sizeof(handle));
> >  	memcpy(&handle.ha_fsid, ctx->fshandle, sizeof(handle.ha_fsid));
> >  	handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
> >  			sizeof(handle.ha_fid.fid_len);
> > diff --git a/scrub/spacemap.c b/scrub/spacemap.c
> > index 9653916d..9362710e 100644
> > --- a/scrub/spacemap.c
> > +++ b/scrub/spacemap.c
> > @@ -47,7 +47,7 @@ scrub_iterate_fsmap(
> >  	int			i;
> >  	int			error;
> >
> > -	head = malloc(fsmap_sizeof(FSMAP_NR));
> > +	head = calloc(1, fsmap_sizeof(FSMAP_NR));
> >  	if (!head)
> >  		return errno;
> >
> 
> Minor nit: The "memset(head, 0, sizeof(*head))" statement following the above
> call to calloc() can now be removed.

FIxed, thanks.

--D

> --
> chandan
