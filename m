Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B545C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Nov 2023 20:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjKJUkw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Nov 2023 15:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346380AbjKJUku (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Nov 2023 15:40:50 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E4918B
        for <linux-xfs@vger.kernel.org>; Fri, 10 Nov 2023 12:40:47 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-6b87c1edfd5so2164988b3a.1
        for <linux-xfs@vger.kernel.org>; Fri, 10 Nov 2023 12:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1699648847; x=1700253647; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tWCqM16I96nRm7cAjclexHKEqGdeaB/kpb/asorFgQo=;
        b=vnyglFT82uwstx5iVYnisBeNqV2+uuM8r6GOWHU9mNadAZEi0/YB/tfqqJn5J65zNV
         TAB3D0Yh9UL2p1dlf1Xx7tRavTEojTCamX+f1XGvhdRuS1+QriCr0682r78foyUgF9aA
         Zrm/Wl3CNGaC+cFZrWAbruqlSiphlv5eI+kfjRk0yqhbsm09Lar0+Ifvp9K3bXS/YyEG
         2uOpWhtCQknEUmWPnVV8rDaFILE68LRxhKxf8er9ZFPNATnXHnc23YM8/3ZvZ+UbDshf
         8B3UqFurI4TC84Ms4EwVEAVV5EBgrtUotZaSG1zGUPeWhLcoVYcYH868VH+tSXWPOayX
         pj7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699648847; x=1700253647;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tWCqM16I96nRm7cAjclexHKEqGdeaB/kpb/asorFgQo=;
        b=azqXs/UP1nrhbuR0mn6Oqx2Le4aPu2sW6FYYydTxcJnmM6UIU2kcypqYcNAApHOQbr
         JZXpDHuyPc+6jTjX+jWbkrpiCY88OMAjC+AjNiSETUpRhNNNUCBHY7M7VGjBiDdDlUsr
         XYP9x1zKYC0AFdkpACGKtbgPutFbAxqymBydXak/IpJWLMOdQSiqzBMSGwSPHzkFAf1u
         t8e56bVdyMgqyv/Io7S/cmzFA1LsHfVpTYNdArPNYlMKL2HTs8Ry7q/eEho8A9mGx//x
         ieX8jH65OmMPxY1cswpMdODeMZkgBOjz4h6PpH60cWvenUsxHRHXJ2vaeQIoXwNH26PF
         LFhw==
X-Gm-Message-State: AOJu0YzpTGK2/g/bjd3HReQbnu98I2wJJzuqorvm+gGDild0n5O0DM9+
        IreMMFacwYkG/WEZd5DfYZmnQ3WHhwbJlBHtMZg=
X-Google-Smtp-Source: AGHT+IFsz58hqEkInAw4NVH6iAAukYdFbUq7n749RahZhsVdZGGWE4Cg2q2jh1CKC+AaC99JQrI4FA==
X-Received: by 2002:a05:6a00:2149:b0:68e:3eb6:d45 with SMTP id o9-20020a056a00214900b0068e3eb60d45mr83927pfk.30.1699648846769;
        Fri, 10 Nov 2023 12:40:46 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id u25-20020aa78399000000b006bdb0f011e2sm117909pfm.123.2023.11.10.12.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Nov 2023 12:40:46 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1r1YJ1-00Au1T-3A;
        Sat, 11 Nov 2023 07:40:43 +1100
Date:   Sat, 11 Nov 2023 07:40:43 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, zlang@redhat.com
Subject: Re: [PATCH 1/2] xfs: inode recovery does not validate the recovered
 inode
Message-ID: <ZU6VSymhrhgJUS8o@dread.disaster.area>
References: <20231110044500.718022-1-david@fromorbit.com>
 <20231110044500.718022-2-david@fromorbit.com>
 <20231110192752.GJ1205143@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231110192752.GJ1205143@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 10, 2023 at 11:27:52AM -0800, Darrick J. Wong wrote:
> On Fri, Nov 10, 2023 at 03:33:13PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Discovered when trying to track down a weird recovery corruption
> > issue that wasn't detected at recovery time.
> > 
> > The specific corruption was a zero extent count field when big
> > extent counts are in use, and it turns out the dinode verifier
> > doesn't detect that specific corruption case, either. So fix it too.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_inode_buf.c   |  3 +++
> >  fs/xfs/xfs_inode_item_recover.c | 14 +++++++++++++-
> >  2 files changed, 16 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> > index a35781577cad..0f970a0b3382 100644
> > --- a/fs/xfs/libxfs/xfs_inode_buf.c
> > +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> > @@ -508,6 +508,9 @@ xfs_dinode_verify(
> >  	if (mode && nextents + naextents > nblocks)
> >  		return __this_address;
> >  
> > +	if (nextents + naextents == 0 && nblocks != 0)
> > +		return __this_address;
> > +
> >  	if (S_ISDIR(mode) && nextents > mp->m_dir_geo->max_extents)
> >  		return __this_address;
> >  
> > diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> > index 6b09e2bf2d74..f4c31c2b60d5 100644
> > --- a/fs/xfs/xfs_inode_item_recover.c
> > +++ b/fs/xfs/xfs_inode_item_recover.c
> > @@ -286,6 +286,7 @@ xlog_recover_inode_commit_pass2(
> >  	struct xfs_log_dinode		*ldip;
> >  	uint				isize;
> >  	int				need_free = 0;
> > +	xfs_failaddr_t			fa;
> >  
> >  	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
> >  		in_f = item->ri_buf[0].i_addr;
> > @@ -529,8 +530,19 @@ xlog_recover_inode_commit_pass2(
> >  	    (dip->di_mode != 0))
> >  		error = xfs_recover_inode_owner_change(mp, dip, in_f,
> >  						       buffer_list);
> > -	/* re-generate the checksum. */
> > +	/* re-generate the checksum and validate the recovered inode. */
> >  	xfs_dinode_calc_crc(log->l_mp, dip);
> > +	fa = xfs_dinode_verify(log->l_mp, in_f->ilf_ino, dip);
> > +	if (fa) {
> 
> Does xlog_recover_dquot_commit_pass2 need to call xfs_dquot_verify as
> well?

Maybe - I haven't looked closely at that, and it depends what the
dquot buffer verifier does. If it's similar to the inode cluster
buffer verifier (i.e. only checks for dquots, doesn't verify the
dquots) then it should do the same thing. I don't have time to do
this right now because I'm OOO for the next week, so maybe you could
check this and send a patch for it?

> This patch looks good though,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
