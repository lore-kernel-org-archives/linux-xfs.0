Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FEA0C433B4
	for <linux-xfs@archiver.kernel.org>; Fri, 14 May 2021 18:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CC0161283
	for <linux-xfs@archiver.kernel.org>; Fri, 14 May 2021 18:51:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbhENSxI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 May 2021 14:53:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45165 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230411AbhENSxI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 May 2021 14:53:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621018315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U37+3pQ09F6UOenURKLgLtYqtJqT1SQpQHXKxk2HUhY=;
        b=VyGP0t6ryWxfir3Uv9goYKvmfQIaTjd0X0rP4UhapKchNXbOtlkhPcFeg4ZtHoyNZKb1q5
        +83cNmrRXr7cTjEdB+Oy8sekm9+KyA7d8XkJVIPvuDRdo74pfdhHfwhMVU7SA1e3Nd6HSy
        D37rFQRd+w40hWIxm/KVE+506otIDVg=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-jkijZwzbPL2LfSeVPg3qZw-1; Fri, 14 May 2021 14:51:53 -0400
X-MC-Unique: jkijZwzbPL2LfSeVPg3qZw-1
Received: by mail-qk1-f197.google.com with SMTP id b3-20020a05620a0cc3b02902e9d5ca06f2so22549508qkj.19
        for <linux-xfs@vger.kernel.org>; Fri, 14 May 2021 11:51:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U37+3pQ09F6UOenURKLgLtYqtJqT1SQpQHXKxk2HUhY=;
        b=BBcoHT9ZMQhcuz0J8scCxTvq7q+hC5PwT3BN0SfxHi4MYh34GbsG5eCKD5R6DJFfs1
         AD6kT+wDgAJm3KU2sdGyzsy27wzqLp+MeP5nRCpYxcQ7Y9Kdou2nyGypbCT8xPevyNqO
         9pXk+COMYbx8ERaT3aF85A3i1E543nZVFRKnVkfpxvoBi3rVGOIqLw8GIgscqQBro6X/
         sQsEMqKUNNVJsfAcEru4MUwGLeQPFXhHeGaONMKES3MomOkA1pvbLGC7lxKaz1po/8oO
         9p+SZTZpxRzlj/sIVazPA2ahdbxtxgYMpzf3tbNmeyZjNh7F9PZ6lgDOEWAKr3N/WIdH
         zeHw==
X-Gm-Message-State: AOAM532PGPAeHnA6qiEXqUIUcAxP9dWKouHyphGHxaqeQIym32z/I9ln
        2GyubgxSmhWIMNyVJCmESPFQlG5bBPcgHJSn68PfhQmi7AFwluM+fY21x2lu9ri+CDSdN9swEzG
        ExdBSNvOjByuZKBm0K90j
X-Received: by 2002:a05:622a:40d:: with SMTP id n13mr44984724qtx.59.1621018312664;
        Fri, 14 May 2021 11:51:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz2xZxgjC58359ORejWKR0eUaV9impQNi2THrydub2rqqmc8j103N5uYZbeDAqNGVMkc+wvMw==
X-Received: by 2002:a05:622a:40d:: with SMTP id n13mr44984712qtx.59.1621018312469;
        Fri, 14 May 2021 11:51:52 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id x18sm5255100qkx.118.2021.05.14.11.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 11:51:52 -0700 (PDT)
Date:   Fri, 14 May 2021 14:51:50 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: validate extsz hints against rt extent size
 when rtinherit is set
Message-ID: <YJ7GxqPURmuPiIbE@bfoster>
References: <162086770193.3685783.14418051698714099173.stgit@magnolia>
 <162086771885.3685783.16422648250546171771.stgit@magnolia>
 <YJ5vS+o3BydK1DrP@bfoster>
 <20210514182253.GN9675@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210514182253.GN9675@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 14, 2021 at 11:22:53AM -0700, Darrick J. Wong wrote:
> On Fri, May 14, 2021 at 08:38:35AM -0400, Brian Foster wrote:
> > On Wed, May 12, 2021 at 06:01:58PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > The RTINHERIT bit can be set on a directory so that newly created
> > > regular files will have the REALTIME bit set to store their data on the
> > > realtime volume.  If an extent size hint (and EXTSZINHERIT) are set on
> > > the directory, the hint will also be copied into the new file.
> > > 
> > > As pointed out in previous patches, for realtime files we require the
> > > extent size hint be an integer multiple of the realtime extent, but we
> > > don't perform the same validation on a directory with both RTINHERIT and
> > > EXTSZINHERIT set, even though the only use-case of that combination is
> > > to propagate extent size hints into new realtime files.  This leads to
> > > inode corruption errors when the bad values are propagated.
> > > 
> > > Strengthen the validation routine to avoid this situation and fix the
> > > open-coded unit conversion while we're at it.  Note that this is
> > > technically a breaking change to the ondisk format, but the risk should
> > > be minimal because (a) most vendors disable realtime, (b) letting
> > > unaligned hints propagate to new files would immediately crash the
> > > filesystem, and (c) xfs_repair flags such filesystems as corrupt, so
> > > anyone with such a configuration is broken already anyway.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > 
> > Ok, so this looks more like a proper fix, but does this turn an existing
> > directory with (rtinherit && extszinherit) and a badly aligned extsz
> > hint into a read validation error?
> 
> Hmm, you're right.  This fix needs to be more targeted in its nature.
> For non-rt filesystems, the rtinherit bit being set on a directory is
> benign because we won't set the realtime bit on new files, so there's no
> need to introduce a new verifier error that will fail existing
> filesystems.
> 
> We /do/ need to trap the misconfiguration for filesystems with an rt
> volume because those filesystems will fail if the propagation happens.
> 
> I think the solution here is to change the verifier check here to
> prevent the spread of bad extent size hints:
> 
> 	if (rt_flag || (xfs_sb_version_hasrealtime(&mp->m_sb) &&
> 			rtinherit_flag && inherit_flag))
> 		blocksize_bytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
> 	else
> 		blocksize_bytes = mp->m_sb.sb_blocksize;
> 
> ...and add a check to xfs_ioctl_setattr_check_extsize to prevent
> sysadmins from misconfiguring directories in the first place.
> 

It definitely makes sense to prevent this misconfiguration going
forward, but I'm a little confused on the intended behavior for
filesystems where this is already present (and not benign). ISTM the
previous patch is intended to allow the filesystem to continue running
with the added behavior that we restrict further propagation of
preexisting misconfigured extent size hints, but would this patch
trigger a verifier failure on read of such a misconfigured directory
inode..?

Brian

> --D
> 
> > Brian
> > 
> > >  fs/xfs/libxfs/xfs_inode_buf.c |    7 ++++---
> > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> > > index 5c9a7440d9e4..25261dd73290 100644
> > > --- a/fs/xfs/libxfs/xfs_inode_buf.c
> > > +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> > > @@ -569,19 +569,20 @@ xfs_inode_validate_extsize(
> > >  	uint16_t			mode,
> > >  	uint16_t			flags)
> > >  {
> > > -	bool				rt_flag;
> > > +	bool				rt_flag, rtinherit_flag;
> > >  	bool				hint_flag;
> > >  	bool				inherit_flag;
> > >  	uint32_t			extsize_bytes;
> > >  	uint32_t			blocksize_bytes;
> > >  
> > >  	rt_flag = (flags & XFS_DIFLAG_REALTIME);
> > > +	rtinherit_flag = (flags & XFS_DIFLAG_RTINHERIT);
> > >  	hint_flag = (flags & XFS_DIFLAG_EXTSIZE);
> > >  	inherit_flag = (flags & XFS_DIFLAG_EXTSZINHERIT);
> > >  	extsize_bytes = XFS_FSB_TO_B(mp, extsize);
> > >  
> > > -	if (rt_flag)
> > > -		blocksize_bytes = mp->m_sb.sb_rextsize << mp->m_sb.sb_blocklog;
> > > +	if (rt_flag || (rtinherit_flag && inherit_flag))
> > > +		blocksize_bytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
> > >  	else
> > >  		blocksize_bytes = mp->m_sb.sb_blocksize;
> > >  
> > > 
> > 
> 

