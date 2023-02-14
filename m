Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58851C61DA4
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Feb 2023 22:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbjBNW0J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Feb 2023 17:26:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjBNW0I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2023 17:26:08 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E940212B6
        for <linux-xfs@vger.kernel.org>; Tue, 14 Feb 2023 14:26:07 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so251668pjq.0
        for <linux-xfs@vger.kernel.org>; Tue, 14 Feb 2023 14:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fT7g2wL7HeV8NqtQRuy1JY99lFDtyRbvhw2bdDBnmAI=;
        b=gW6KmkNlIgZJoiwmNpG0y+C/I6D/5bISMwX1SFAraxy5u/aFz4QpTQuRyhB94AfYLi
         12iy3B7xCfHN0bX3pIRSSfT0oilJV8guoHtEH1C2t2EuWkFw/LvUfdIAWQ/6gLGGCY8M
         ts65yKOJGj8QQ/G5OfxDI08OcP0dbFGULaCLIEQO4XofdBaYHz3KiEHs7YgurFdf6gr1
         e2Y2jPCz2euUi8d4529Bjh5Df84JXEs8cKvDbGl6DrLXJJVlC9/FZBqhISe8nFk8XHlK
         PS70FiUpMsRD4pe5mfMaR+j/CcdxbWK/h4AenD23Nm4H3hzoSQSXI9XJJ5uZ+Pc7DHkG
         TifA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fT7g2wL7HeV8NqtQRuy1JY99lFDtyRbvhw2bdDBnmAI=;
        b=bxeb8sCjuBe+4Xs6H61Vz53eE94tZoTVXB+hVlGjhEyn/dxr/VrAsjdpgd7nE70DSd
         vKqV5C4vyIf8f+Ikq851DLBdLG/hrBdLZXpcvnZey0MufXMGS3Bgfhyfm/go1BUolCfX
         BWOF/wY3r5aD1GJCGeDnjuUfNeGb63KyAp0cQe9VjnrTn3oFTN7+Kl+EaRowd2bypNEN
         xRNF9aSiNcAbqBhT1S7G0WIGhw37ZpNhHB+Iurh3N1Q7LdF/Znt+L2g+Ea/g+g+k21ZB
         qiW2BNnrgLUMmOsFGW+wYYjZry/+SC4PcfxNel3BHFd8K7gmEBSOJKAxyYoOOxxPOGOF
         yKjA==
X-Gm-Message-State: AO0yUKUUyrtG4yRD5Z1DJv7+iknm7+mDQ4KF5rPEDErJUOXc9C3tJ5/a
        p0/EW1DXd6AfEMKwUpLESZioXQ==
X-Google-Smtp-Source: AK7set+HXmZ2Qs+OPPZJDAvMHg6Pzqm7TNsETvrujLhZQJE7EA+2IuUtOXkophoef2keb87fgYg/zg==
X-Received: by 2002:a05:6a20:4405:b0:bd:a50:e274 with SMTP id ce5-20020a056a20440500b000bd0a50e274mr4771918pzb.28.1676413566915;
        Tue, 14 Feb 2023 14:26:06 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id f24-20020aa78b18000000b0058e1b55391esm10507929pfd.178.2023.02.14.14.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 14:26:06 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pS3kQ-00FN52-Gb; Wed, 15 Feb 2023 09:26:02 +1100
Date:   Wed, 15 Feb 2023 09:26:02 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: failed delalloc conversion results in bad
 extent lists
Message-ID: <20230214222602.GN360264@dread.disaster.area>
References: <20230214055114.4141947-1-david@fromorbit.com>
 <20230214055114.4141947-3-david@fromorbit.com>
 <Y+tCn8owdne7Cbfg@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+tCn8owdne7Cbfg@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 14, 2023 at 12:13:19AM -0800, Christoph Hellwig wrote:
> On Tue, Feb 14, 2023 at 04:51:13PM +1100, Dave Chinner wrote:
> > index 958e4bb2e51e..fb718a5825d5 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -4553,8 +4553,12 @@ xfs_bmapi_convert_delalloc(
> >  		 * should only happen for the COW fork, where another thread
> >  		 * might have moved the extent to the data fork in the meantime.
> >  		 */
> > -		WARN_ON_ONCE(whichfork != XFS_COW_FORK);
> > -		error = -EAGAIN;
> > +		if (whichfork != XFS_COW_FORK) {
> > +			xfs_bmap_mark_sick(ip, whichfork);
> > +			error = -EFSCORRUPTED;
> > +		} else {
> > +			error = -EAGAIN;
> > +		}
> 
> The comment above should probably be expanded a bit on what this means
> for a non-cow fork extent and how we'll handle it later.
> 
> > +	if (error) {
> > +		if ((error == -EFSCORRUPTED) || (error == -EFSBADCRC))
> 
> Nit: no need for the inner braces.
> 
> >  
> > +		/*
> > +		 * If the inode is sick, then it might have delalloc extents
> > +		 * within EOF that we were unable to convert. We have to punch
> > +		 * them out here to release the reservation as there is no
> > +		 * longer any data to write back into the delalloc range now.
> > +		 */
> > +		if (!xfs_inode_is_healthy(ip))
> > +			xfs_bmap_punch_delalloc_range(ip, 0,
> > +						i_size_read(VFS_I(ip)));
> 
> Is i_size_read the right check here?  The delalloc extent could extend
> past i_size if i_size is not block aligned.  Can't we just simply pass
> (xfs_off_t)-1 here?

Probably, we just killed all the delalloc blocks beyond eof via
xfs_free_eofblocks() in the line above this, so I didn't seem
necessary to try to punch blocks beyond EOF for this case. Easy
enough to do to be safe, just need a comment update to go with
it....

Cheers,

Dave.
> 
> 

-- 
Dave Chinner
david@fromorbit.com
