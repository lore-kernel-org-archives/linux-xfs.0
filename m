Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E54FDC4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Nov 2023 21:47:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjKBVrK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Nov 2023 17:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjKBVrJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Nov 2023 17:47:09 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA6918C
        for <linux-xfs@vger.kernel.org>; Thu,  2 Nov 2023 14:47:07 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 98e67ed59e1d1-280137f1a1bso1312011a91.1
        for <linux-xfs@vger.kernel.org>; Thu, 02 Nov 2023 14:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1698961626; x=1699566426; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ux/uQy4XxXsV3Ii3hbDJzbYfbA13OqRj3f23Guj+kpc=;
        b=dh6DFVxTtcGedRbOl/44qlNW+Bg43Cjt1WwLbxzjLPxAOOkZsaJpsBvurHTWIEhUgR
         62yFrqldmDTjLB+fYnxz9DVrdDLjbKMj0R9rvyZjWVpcTv8xw03f+KXeqti0mx40K4CZ
         W0Eg3paj2Iz3RSXni7RFfT+wGWAC61yZO7QBB+vILhE+GFgBhGp1/620yuzvuSrR7dXn
         GQCrkAqxE7szcmapZyr7vmFQsBnwyQdbBAofVh/WVZySzUxbA5or6RXqcMSCWWeej2cm
         xD8S7wZySsEEaSS5a2SNIKibjCq4EUX+M99c3ZK8Dy1WvFRU3QKqy/ZuuVtseN6ooaI5
         mk1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698961626; x=1699566426;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ux/uQy4XxXsV3Ii3hbDJzbYfbA13OqRj3f23Guj+kpc=;
        b=qcc4kJ9TmirHWN6qnYY6XfyoSD7cs3g24psqdWMePn1lmchOPr51fWc70bNlgmfXge
         aL2IVBXr5SkDviGhYvqkbnbxBotKA5ThbO/CuqMSN1a5S2gsPKQ7qJbFqTie/95+53qj
         eShoeiVJv0gKNAIaTPqdh4o1OTZCq7EYL6Dm0KjCNmh1FO9KsSdQSpOu98/hWHS7XvhK
         XfXBjlHhO/hZvAJiZRVPvQowKCiM8bPc7PivHgQys/wEoDju7Uw2YP98f983wcvjtr2F
         lavD6agp6Fd/r//U+Z/6E8So3ANe5EvJXzPyr1cNWDKS8WQxLLdKOzULDGpZ4RiiPeAs
         2Qtw==
X-Gm-Message-State: AOJu0YzfM5iK8cdTxV0DqBq+TZsoOXTuQBV3Dal2+mHtTs6zNQB+ivdH
        Cg4/Ra5uHv4mg7VRjjyV4s2ToQ==
X-Google-Smtp-Source: AGHT+IH9h6fSDDz86oGwrKF11yIcFqab+Ly+9UfJBbmyoqeLxQV65LtuLujk/BsUF9NKidQ7w7yjQA==
X-Received: by 2002:a17:90b:1189:b0:27d:3ecb:3cbb with SMTP id gk9-20020a17090b118900b0027d3ecb3cbbmr17484676pjb.37.1698961626601;
        Thu, 02 Nov 2023 14:47:06 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id k20-20020a170902ba9400b001c9c97beb9csm177566pls.71.2023.11.02.14.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 14:47:06 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qyfWp-007Osh-1M;
        Fri, 03 Nov 2023 08:47:03 +1100
Date:   Fri, 3 Nov 2023 08:47:03 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Alexander Puchmayr <alexander.puchmayr@linznet.at>,
        linux-xfs@vger.kernel.org
Subject: Re: xfsdump does not support reflink copied files properly
Message-ID: <ZUQY1/DjREXQbgDb@dread.disaster.area>
References: <2644025.VLH7GnMWUR@zeus>
 <20231102163953.GF1205143@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231102163953.GF1205143@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 02, 2023 at 09:39:53AM -0700, Darrick J. Wong wrote:
> On Thu, Nov 02, 2023 at 01:42:54PM +0100, Alexander Puchmayr wrote:
> > Hi there,
> > 
> > I just encountered a problem when trying to use xfsdump on a filesystem with 
> > lots of reflink copied vm disk images, yielding a dump file much larger than 
> > expected and which I also was unable to restore from (target disk full). I 
> > created a gentoo bug item under https://bugs.gentoo.org/916704 and I got 
> > advised to report it here as well.
> > 
> > Copy from the bug report:
> > 
> > sys-fs/xfsdump-3.1.12 seems to copy reflink copied files as ordinary files, 
> > resulting in a way too big dump file. Restoring from such a dump yields likely 
> > a out-of-diskspace condition. 
> 
> Correct, xfsdump (and tar, and rsync...) does not know how to preserve
> the sharing factor of a particular space extent.  All of those tools
> walk the inodes on a filesystem, open them, and read() out the data.
> 
> Although there are ways to find out which file(s) own a piece of disk
> space, each of those tools would most likely require a thorough redesign
> to the dump file format to allow pointing to shared blocks elsewhere in
> the dump file.

I don't think that is the case. Like XFS, xfsdump encodes user data
it backs up in extent records, and it has different types of
extents. It currently understands "data" and "hole" extents as
returned by XFS_IOC_GETBMAPX, so we could extend that to encode
"shared" extents that point to an offset and length in a different
inode.

Yes, this means during the scan we have to record all shared extents
with their underlying block number, then after the scan we need to
resolve that to the single copy we are going to keep ias a normal
data extent in the dump (i.e. the first to be restored) Then we
convert all the others to the new shared extent type that points at
the {ino, off, len} that contains the actual data in the dump.

Now all restore needs to do is run FICLONERANGE when it comes across
a shared extent - it's got all the info it needs in the dump to
recreated the shared extent. We can use restore side ordering to
guarantee that the data we need to clone is already on disk (e.g.
delay extent clones until after all the normal data has been
restored) so that all the shared extents we restore end up with the
correct data in them.

Yes, this means we need to bump the dump format version number to
support shared extents, but overall it's not a major revision of the
format or major surgery to the code base.  It doesn't require kernel
or even XFS expertise to implement - it's all userspace stuff and
fairly straight forward - it just requires time, resources and
commitment.

> Regardless, nobody's submitted code to do any of those things.  Patches
> welcome.

Yup, that is the biggest issue - there's always more things to do
that we have people to do them.

> > It may be used as a denial-of-service tool which can be used by an ordinary 
> 
> Please do not file a  ^^^^^^^^^^^^^^^^^ CVE for this.

/me sighs

-Dave.
-- 
Dave Chinner
david@fromorbit.com
