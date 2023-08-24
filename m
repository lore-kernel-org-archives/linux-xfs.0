Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F980C3DA6F
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Aug 2023 23:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243995AbjHXXGd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244054AbjHXXGa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2023 19:06:30 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749BB1FD3
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 16:06:21 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id 46e09a7af769-6bd3317144fso300902a34.1
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 16:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1692918381; x=1693523181;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eNbaus67NK+zwGGpU1OQ13+AZWMogBzh2lgxE9DpQNI=;
        b=vu1SIqBnd/8lh5I0VzutUuTOU1KFDrbVXI42qRAmSDugOIAyw47v4NSiTcyUbjXQrT
         xNfwJGtC50aFGoM83P3SZ468ME5MsHZJ4Rz4EeJqzPfbIzCc8l7wDoaaAuNJY1BBeh6N
         yc83ey420/RPxrg5bAdbbzklrm6KZU1qsl7YbDqAq+m3+BvlCtAZF6A8zl7z7eLhqnpt
         zvxG9c0LJiWS2XKOyjN00kuf4q3CjEIfoi2LZrC7EP7cwXotHox1bZEGTer9CVGEjmtE
         4sNX6wQ9giIMUKp9tezbV7FvxnvF/eJTCs1CG+IYNNxpaZL/2dHWm8JZun5rI40/aogG
         3ZSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692918381; x=1693523181;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eNbaus67NK+zwGGpU1OQ13+AZWMogBzh2lgxE9DpQNI=;
        b=AmTVDATjyW+AYRHKxIU/3ky4kjsmaxoRFG8cFpXaj53uSIOlOaucQLJvp8BjYgmDuY
         sOKfPq/Gr8ErBiDZB+ecO6BRVXmKVUBICZWNQAsTXzSjxhSzYEpZag9dj4ImSp7tFWoN
         NXFM5hbmlcwh/zDfgBOfGUi4VFIAHDuv+UAea8J7Prw3YEml9jnxSHT3naXiUagJnaVX
         Yupux17gQAxXCUvXLoqqnrxs8nITyeN3M2l1rZI1oz8dADdXOva9211LgALf+ENiED60
         Jomb49Bh2OzGgdndJBDsaXreVRQhYQtrS1+mhxqrHXuLApopDWPE1NZcIeuUo/9IE37E
         h9IA==
X-Gm-Message-State: AOJu0YwsfEVP7ikBeKPjhPjGG4i0RxXlAjxwFes3K2nPpeaCOXPbwwEq
        JRxqpvZpNrDVjAGI2YAPV0xepQ==
X-Google-Smtp-Source: AGHT+IFuCd1IFhBJSjX+OmaMYaqaO0qxWLD9iIUTxQwcvKOTOwc4BOpRQfguQEn1f8A95C46XqzsZg==
X-Received: by 2002:a05:6870:41d2:b0:1b7:2d92:58d6 with SMTP id z18-20020a05687041d200b001b72d9258d6mr1278884oac.32.1692918380797;
        Thu, 24 Aug 2023 16:06:20 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id jf15-20020a170903268f00b001bb3beb2bc6sm201670plb.65.2023.08.24.16.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 16:06:20 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qZJP8-0065PY-0W;
        Fri, 25 Aug 2023 09:06:18 +1000
Date:   Fri, 25 Aug 2023 09:06:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 28/29] xfs: Convert to bdev_open_by_path()
Message-ID: <ZOfiakPoFC5w3FYg@dread.disaster.area>
References: <20230818123232.2269-1-jack@suse.cz>
 <20230823104857.11437-28-jack@suse.cz>
 <ZOaEHrkx1xS9bgk9@dread.disaster.area>
 <20230824102837.credhh3fsco6vf7p@quack3>
 <20230824202910.wkzkvx6hbgdz6wuh@quack3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230824202910.wkzkvx6hbgdz6wuh@quack3>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 24, 2023 at 10:29:10PM +0200, Jan Kara wrote:
> On Thu 24-08-23 12:28:37, Jan Kara wrote:
> > On Thu 24-08-23 08:11:42, Dave Chinner wrote:
> > > On Wed, Aug 23, 2023 at 12:48:39PM +0200, Jan Kara wrote:
> > > > Convert xfs to use bdev_open_by_path() and pass the handle around.
> > > ....
> > > 
> > > > @@ -426,15 +427,15 @@ xfs_shutdown_devices(
> > > >  	 * race, everyone loses.
> > > >  	 */
> > > >  	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp) {
> > > > -		blkdev_issue_flush(mp->m_logdev_targp->bt_bdev);
> > > > -		invalidate_bdev(mp->m_logdev_targp->bt_bdev);
> > > > +		blkdev_issue_flush(mp->m_logdev_targp->bt_bdev_handle->bdev);
> > > > +		invalidate_bdev(mp->m_logdev_targp->bt_bdev_handle->bdev);
> > > >  	}
> > > >  	if (mp->m_rtdev_targp) {
> > > > -		blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev);
> > > > -		invalidate_bdev(mp->m_rtdev_targp->bt_bdev);
> > > > +		blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev_handle->bdev);
> > > > +		invalidate_bdev(mp->m_rtdev_targp->bt_bdev_handle->bdev);
> > > >  	}
> > > > -	blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
> > > > -	invalidate_bdev(mp->m_ddev_targp->bt_bdev);
> > > > +	blkdev_issue_flush(mp->m_ddev_targp->bt_bdev_handle->bdev);
> > > > +	invalidate_bdev(mp->m_ddev_targp->bt_bdev_handle->bdev);
> > > >  }
> > > 
> > > Why do these need to be converted to run through bt_bdev_handle?  If
> > > the buftarg is present and we've assigned targp->bt_bdev_handle
> > > during the call to xfs_alloc_buftarg(), then we've assigned
> > > targp->bt_bdev from the handle at the same time, yes?
> > 
> > Good point, these conversions are pointless now so I've removed them. They
> > are leftover from a previous version based on a kernel where xfs was
> > dropping bdev references in a different place. Thanks for noticing.
> 
> FWIW attached is a new version of the patch I have currently in my tree.

Looks OK.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
