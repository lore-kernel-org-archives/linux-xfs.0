Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4A82C004D4
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Jan 2023 20:34:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjASUeP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Jan 2023 15:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjASUeN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jan 2023 15:34:13 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB0F9AAB0
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jan 2023 12:34:09 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id m3-20020a17090a414300b00229ef93c5b0so2201118pjg.2
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jan 2023 12:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TgVk+HF1nZXXdVq0MFC3wEV5yFf1OJk+HWwX0qOkAPI=;
        b=RR1Z3NzBQb/5VKE6/c7dwenYE/fCVzu6wXnbh265naX1ARc58o8v/3p407YW3O3siZ
         qI/UFNvBO7WCe/bRZhJh3/khwzeNaLQ6SMSdUequBprP3wceHXEmZUyotKSFQn7Ezyan
         O7vu0ki6RpGrUtzENOjE+Vj98gfinzP5MEV2VtebauJYmJxm75uppfvNrkBnC7JzXDxa
         /9U/MHwHgferecsf4XdKcplIeTk1E2t9ah4bQnWUPmSz5RiG90Q0LWQs7+RDh8be3Cov
         8FF7mXPGg9fHRdIgQvreWXi28VkllksP3VSa+8PCu1C2TsAqDSeUE3qVHNuQzjlW0ecb
         5Cvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TgVk+HF1nZXXdVq0MFC3wEV5yFf1OJk+HWwX0qOkAPI=;
        b=FaMRu0E/+OJwWYEpcic/EiR15zY1/8iQF51/oEYWL6nTF8a3YVa8tZhyi0YzEpEVeP
         9BVGkj3H/1T/g5M44TZ8x/90rlTBiK87QktZTEKu+w5OTnaJt5byBZ65RDQ/CgXE8mTs
         BgKUn/MDawS9eOWBxnM42W28f/eD5sEiYyE5aMn7tPc+j51r5hHYFRa0lR+Qwl5Bb6cy
         PCxIX9CYpQ638v0Ov/1XhpHcnLlm+OtLLAwxhH9wTIQ9/XSqoRhVtuxyTUd5j+PfqOur
         cPL7uzDBfk/6M3aWj157H3p6B5qB2AMx4a2A/R0nUREhccU2XRtdb3VKrEX5GxZzprcI
         USIw==
X-Gm-Message-State: AFqh2kq8SkH7MeMj18UWpeSAfI8Jda17MrnfishyTO42DF9Us9tstrev
        3eL54724c7UDz/MRd1VuKJnVDg==
X-Google-Smtp-Source: AMrXdXsdzGshbUdK220YxPmnvJZdZKPaM9/lg5eqF7XWs4n7Rn0/RYRQrzeGFkdSsdMYm/d2JtPQ2Q==
X-Received: by 2002:a17:90a:7043:b0:21d:6327:ab6 with SMTP id f61-20020a17090a704300b0021d63270ab6mr12309206pjk.1.1674160448895;
        Thu, 19 Jan 2023 12:34:08 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id 4-20020a17090a08c400b00218f7c1a7d4sm35433pjn.56.2023.01.19.12.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 12:34:08 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pIbbo-0054vk-MZ; Fri, 20 Jan 2023 07:34:04 +1100
Date:   Fri, 20 Jan 2023 07:34:04 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: recheck appropriateness of map_shared lock
Message-ID: <20230119203404.GL360264@dread.disaster.area>
References: <Y8ib6ls32e/pJezE@magnolia>
 <20230119051411.GJ360264@dread.disaster.area>
 <Y8mOZvGlkmkjUSvv@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8mOZvGlkmkjUSvv@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 19, 2023 at 10:39:34AM -0800, Christoph Hellwig wrote:
> On Thu, Jan 19, 2023 at 04:14:11PM +1100, Dave Chinner wrote:
> > If we hit this race condition, re-reading the extent list from disk
> > isn't going to fix the corruption, so I don't see much point in
> > papering over the problem just by changing the locking and failing
> > to read in the extent list again and returning -EFSCORRUPTED to the
> > operation.
> 
> Yep.
> 
> > So.... shouldn't we mark the inode as sick when we detect the extent
> > list corruption issue? i.e. before destroying the iext tree, calling
> > xfs_inode_mark_sick(XFS_SICK_INO_BMBTD) (or BMBTA, depending on the
> > fork being read) so that there is a record of the BMBT being
> > corrupt?
> 
> Yes.
> 
> > That would mean that this path simply becomes:
> > 
> > 	if (ip->i_sick & XFS_SICK_INO_BMBTD) {
> > 		xfs_iunlock(ip, lock_mode);
> > 		return -EFSCORRUPTED;
> > 	}
> 
> This path being xfs_ilock_{data,attr}_map_shared?  These don't
> return an error.

I was thinking we just change the function parameters to take a "int
*lockmode" parameter and return an error state similar to
what we do in the IO path with the xfs_ilock_iocb() wrapper.

> But if we make sure xfs_need_iread_extents
> returns true for XFS_SICK_INO_BMBTD, xfs_iread_extents can
> return -EFSCORRUPTED.

I don't think that solves the race condition because
xfs_need_iread_extents() is run unlocked. Just like it can race with
filling the extent list and then removing it again while we wait on
the ILOCK, it can return true before XFS_SICK_INO_BMBTD is set and
then when we get the lock we find XFS_SICK_INO_BMBTD is set and
extent list is empty...

Hence I think the check for extent list corruption has to be done
after we gain the inode lock so we wait correctly for the result of
the racing extent loading before proceeding.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
