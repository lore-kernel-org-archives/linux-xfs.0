Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25865C35E01
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:38:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F18D22084E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:38:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bw+2uxLd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgBYRia (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 12:38:30 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38078 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbgBYRia (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 12:38:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5Ar3Z0WIajKoNL1CpT2dYGeYN9m0S/d8jacuqqi8nhQ=; b=bw+2uxLdWX85c+o2CL945DKceV
        1KXevmZfDFECO23Rf5+O1+yRyjkPF10azXq6ptF7sa+PATWvTJffZxgcdeTXWPwubSfWWCgu7/NM4
        nWMs1Qf/H8KGbll6Z1Jl4u5qz25ougEs+faMqrIWKB+OBN9zt29ld+ZXX9XPi3/EyryFYtGfRHmvU
        BeXLjkBZtQkVs9V5hdv47DILwJf8/GvL/YrhBToSpxEwkFzaAtuIXJyfURsk2LxiV7DSiyz6HZhke
        SPYCV40mFoV/K7m9j653hfnrSNZS5CSHjUMdKeZ46H8Ee3uVRrZT7EA0bRJOEO6quF68MFW/DWxEs
        +DxmTn4w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6eA8-00016m-4P; Tue, 25 Feb 2020 17:38:28 +0000
Date:   Tue, 25 Feb 2020 09:38:28 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs_repair: check that metadata updates have been
 committed
Message-ID: <20200225173828.GC20570@infradead.org>
References: <158258942838.451075.5401001111357771398.stgit@magnolia>
 <158258946575.451075.126426300036283442.stgit@magnolia>
 <20200225150817.GC26938@bfoster>
 <20200225151426.GC6748@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225151426.GC6748@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 07:14:27AM -0800, Darrick J. Wong wrote:
> On Tue, Feb 25, 2020 at 10:08:17AM -0500, Brian Foster wrote:
> > On Mon, Feb 24, 2020 at 04:11:05PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Make sure that any metadata that we repaired or regenerated has been
> > > written to disk.  If that fails, exit with 1 to signal that there are
> > > still errors in the filesystem.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  repair/xfs_repair.c |    7 ++++++-
> > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > > 
> > > 
> > > diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> > > index eb1ce546..ccb13f4a 100644
> > > --- a/repair/xfs_repair.c
> > > +++ b/repair/xfs_repair.c
> > > @@ -703,6 +703,7 @@ main(int argc, char **argv)
> > >  	struct xfs_sb	psb;
> > >  	int		rval;
> > >  	struct xfs_ino_geometry	*igeo;
> > > +	int		error;
> > >  
> > >  	progname = basename(argv[0]);
> > >  	setlocale(LC_ALL, "");
> > > @@ -1104,7 +1105,11 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
> > >  	 */
> > >  	libxfs_bcache_flush();
> > >  	format_log_max_lsn(mp);
> > > -	libxfs_umount(mp);
> > > +
> > > +	/* Report failure if anything failed to get written to our fs. */
> > > +	error = -libxfs_umount(mp);
> > > +	if (error)
> > > +		exit(1);
> > 
> > I wonder a bit whether repair should really exit like this vs. report
> > the error as it does for most others, but I could go either way. I'll
> > defer to Eric:
> 
> I suppose I could do:
> 
> 	error = -libxfs_umount();
> 	if (error)
> 		do_error(_("fs unmount failed (err=%d), re-run repair!\n"),
> 				error);
> 
> Though then you'd end up with:
> 
> 	# xfs_repair /dev/fd0
> 	...
> 	Refusing to write corrupted metadata to the data device!
> 	fs unmount failed (err=117), re-run repair!
> 	# echo $?
> 	1
> 
> Which seems a little redundant.  But let's see what Eric thinks.

I think this message would be at last somewhat useful.
