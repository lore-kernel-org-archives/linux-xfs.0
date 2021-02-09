Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04681C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 17:59:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C00C964EC4
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 17:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233204AbhBIR5O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 12:57:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:60916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232879AbhBIRrY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Feb 2021 12:47:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70AAA64E2F;
        Tue,  9 Feb 2021 17:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612892803;
        bh=AY91+AiyhR9+rAv4ZeuYOztQyVne23NId8HLV42jfxI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AU61t7hKCPsmbU/QeCCOKegBIB4xriX8ckOrYybRlDNc0mmBX1oaLyp/4dq0dfyld
         YZR0eSLMfb2D9P/ulluFUAv1c4zlQ+VlbM0CokUuIMfE4MhSiRJJba7O6fjXP/D/i5
         DIy/RHrBxosW4XVSnGz0O7IqsirlK/bZPFw78FGpdtD3as/EsMS2Ii7Z1NIjsKQ/AM
         OYmD1Z0b0xMqNGwxFNqoiMAFuN+4LQELXWwyi6535QJkhHZVMa6bHWEzIxDiQlSXgD
         CcoloDQ+gSkpbpoc9RdlSg6DSIDxmGtC2giCnNkaA4XvlJPyQ3KN4Sh//zu/Rm1Zgn
         nByMLrN8F41xA==
Date:   Tue, 9 Feb 2021 09:46:42 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/10] xfs_repair: clear quota CHKD flags on the incore
 superblock too
Message-ID: <20210209174642.GR7193@magnolia>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284383258.3057868.6167060787728229726.stgit@magnolia>
 <20210209172011.GC14273@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209172011.GC14273@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 09, 2021 at 12:20:11PM -0500, Brian Foster wrote:
> On Mon, Feb 08, 2021 at 08:10:32PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > At the end of a repair run, xfs_repair clears the superblock's quota
> > checked flags if it found mistakes in the quota accounting to force a
> > quotacheck at the next mount.  This is currently the last time repair
> > modifies the primary superblock, so it is sufficient to update the
> > ondisk buffer and not the incore mount structure.
> > 
> > However, we're about to introduce code to clear the needsrepair feature
> > at the very end of repair, after all metadata blocks have been written
> > to disk and all disk caches flush.  Since the convention everywhere else
> > in xfs is to update the incore superblock, call libxfs_sb_to_disk to
> > translate that into the ondisk buffer, and then write the buffer to
> > disk, switch the quota CHKD code to use this mechanism too.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  repair/xfs_repair.c |    7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> > 
> > 
> > diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> > index 9409f0d8..32755821 100644
> > --- a/repair/xfs_repair.c
> > +++ b/repair/xfs_repair.c
> > @@ -1108,10 +1108,9 @@ _("Warning:  project quota information would be cleared.\n"
> >  	if ((mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD) != quotacheck_results()) {
> >  		do_warn(_("Note - quota info will be regenerated on next "
> >  			"quota mount.\n"));
> > -		dsb->sb_qflags &= cpu_to_be16(~(XFS_UQUOTA_CHKD |
> > -						XFS_GQUOTA_CHKD |
> > -						XFS_PQUOTA_CHKD |
> > -						XFS_OQUOTA_CHKD));
> > +		mp->m_sb.sb_qflags &= ~(XFS_UQUOTA_CHKD | XFS_GQUOTA_CHKD |
> > +					XFS_PQUOTA_CHKD | XFS_OQUOTA_CHKD);
> > +		libxfs_sb_to_disk(sbp->b_addr, &mp->m_sb);
> 
> Nit: we can still use dsb here instead of open-coding the buffer
> address. Otherwise:

Or I could remove dsb entirely, since the xfs_mount's sb_unit/sb_width
should reflect the values copied from the backup super during phase 1
(aka before we actually libxfs_mount) when we set copied_sunit=1.

--D

> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  	}
> >  
> >  	if (copied_sunit) {
> > 
> 
