Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F11BACDB47E
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 21:14:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233339AbjJKVOt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 17:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbjJKVOs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 17:14:48 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C814E90
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 14:14:47 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1c894e4573bso2316035ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 14:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1697058887; x=1697663687; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ILo0Hd95UCZd7gN5hxIXJZ3nfYjHRWMcf+1//1jAsoI=;
        b=foZlIH3QF2kwev4LwPCy4Gs29pssL+0iSDmz/FbiJR8OzVqCEeuskywsTt7yN3Cgxr
         HIO9qY8xpesl6/29MfO2c33G3vknfclYR/WkM/9x26X3QV//IqV1nhKb1p82Q/T8L3go
         EhyaFnQXclV22aoSELdT/D/vLOQczyuloedYKsbBk/5KfBJpfPkZuzhXxt1UMC9BU/9l
         ai+p5St3ZJZUCrB/4YSPysJcxQ1ZLkUYz16fEbUbQiwjW/y2vRTsOoemf2nnRpTJ6Glj
         XZVk6UGNDFprk8NhlgEZnAlLCoFLjDZTynFb2+8qflVI5njJ8H/ujsq5eV3d9p7YJCgy
         txeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697058887; x=1697663687;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ILo0Hd95UCZd7gN5hxIXJZ3nfYjHRWMcf+1//1jAsoI=;
        b=SKT/XOY9B0GNQBIJR7AZRV9KzYekynL0EZ+jHk+/sc+S9YzswrVmNGLU6s4WxwRy3Z
         7oABD6UV10AZTyOlpDduMEGmcHMfJfJMva6zsNXn9tfwfejluB52KqRcn8PyeIPTc1ac
         yYKdWfxkOwmi/3nWgTewW+K0hLK9XA4Hm6kYCzbcNcyhrVktGqACWhFfYPe+wDjm6Ccl
         81q//474IHmFgKiqaJimUjXvTTrOIk2oFTP9NO8zb08yh6GfHRnm1NODPA/H4DmlbS4f
         ctxjBLRqvUi389OkDPx50zEXVYrXCesFsgJKukw7l5Vl1904nmfK0fCldFsqT9FuUStl
         AKrA==
X-Gm-Message-State: AOJu0Yz/G4nm1cGT0iqKPBT9q96IqTwzuEdwMhsur2tskOwQt6uo1AoS
        yQT7dlxsR3Xl0bHfLTsSkPm3Vg==
X-Google-Smtp-Source: AGHT+IFmqrpLwX2Jo01vg0g0k1NUlOlY/w5mGwBHRITAucCYQoba/lV5+NbHg6+dWadK3+un07Qb0g==
X-Received: by 2002:a17:902:c40a:b0:1c7:5a63:43bb with SMTP id k10-20020a170902c40a00b001c75a6343bbmr28062810plk.8.1697058887284;
        Wed, 11 Oct 2023 14:14:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id e11-20020a170902ed8b00b001c9b29b9bd4sm308212plj.38.2023.10.11.14.14.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 14:14:46 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qqgXU-00CZ0m-0z;
        Thu, 12 Oct 2023 08:14:44 +1100
Date:   Thu, 12 Oct 2023 08:14:44 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, cheng.lin130@zte.com.cn,
        linux-xfs@vger.kernel.org, jiang.yong5@zte.com.cn,
        wang.liang82@zte.com.cn, liu.dong3@zte.com.cn
Subject: Re: [PATCH] xfs: pin inodes that would otherwise overflow link count
Message-ID: <ZScQRPEzGALKuSpk@dread.disaster.area>
References: <20231011203350.GY21298@frogsfrogsfrogs>
 <ZScOxEP5V/fQNDW8@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZScOxEP5V/fQNDW8@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2023 at 08:08:20AM +1100, Dave Chinner wrote:
> On Wed, Oct 11, 2023 at 01:33:50PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The VFS inc_nlink function does not explicitly check for integer
> > overflows in the i_nlink field.  Instead, it checks the link count
> > against s_max_links in the vfs_{link,create,rename} functions.  XFS
> > sets the maximum link count to 2.1 billion, so integer overflows should
> > not be a problem.
> > 
> > However.  It's possible that online repair could find that a file has
> > more than four billion links, particularly if the link count got
> 
> I don't think we should be attempting to fix that online - if we've
> really found an inode with 4 billion links then something else has
> gone wrong during repair because we shouldn't get there in the first
> place.
> 
> IOWs, we should be preventing a link count overflow at the time 
> that the link count is being added and returning -EMLINK errors to
> that operation. This prevents overflow, and so if repair does find
> more than 2.1 billion links to the inode, there's clearly something
> else very wrong (either in repair or a bug in the filesystem that
> has leaked many, many link counts).
> 
> huh.
> 
> We set sb->s_max_links = XFS_MAXLINKS, but nowhere does the VFS
> enforce that, nor does any XFS code. The lack of checking or
> enforcement of filesystem max link count anywhere is ... not ideal.

No, wait, I read the cscope output wrong. sb->s_max_links *is*
enforced at the VFS level, so we should never end up in a situation
with link count greater than XFS_MAXLINKS inside the XFS code in
normal operation. i.e. A count greater than that is an indication of
a software bug or corruption, so we should definitely be verifying
di_nlink is within the valid on-disk range regardless of anything
else....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
