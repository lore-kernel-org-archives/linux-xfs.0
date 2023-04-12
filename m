Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B4C8C77B6C
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 21:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbjDLVkl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 17:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjDLVkk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2023 17:40:40 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF8F16199
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 14:40:37 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id y11-20020a17090a600b00b0024693e96b58so11981964pji.1
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 14:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1681335637;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xBpJwbs5xEvZ+7lDRUS10lVwXpWMvg3Y1fTxkKpQfyk=;
        b=mkbD8hIsPrfrZjq/EBQP8M1zVtAzmhlHbK3PonI0VyuLV0JLvhmh9rqgdBNzMCG2cU
         cx4YcHbamVXvL+IWJa4JAc809XL3el068XmruLBYkDn+sVDcdJjyodJzAtCC3MJPFxUJ
         eg84Vs360DlGk358mKixpRf5b0UPaAsYHAN14RJtqugZY0GT+149HV1VAUjjJaOn/Unz
         HPk8bs7cyo+fAsBB+/ph8fJhXi517FuDEVnKbO04Y+HSk4A2eqShlVeENZ7BzcvZAHln
         1b4gDEQl6+ATbxynWMPF9QGPfGZNBJIjQNsrsFwW2mnqn6RGkz2EkwYgjDJJ0QVhFmKz
         kJ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681335637;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xBpJwbs5xEvZ+7lDRUS10lVwXpWMvg3Y1fTxkKpQfyk=;
        b=PYDIM2SMqRGQnFpLloD4pgXz/k6tAPwBQJkTtIP7FyVG2UDBsc+ppxoNb8uoBw/6p8
         /Hl7uQL7Ac9VKbtXl83Yl8ZoKllvn7ifZtZrv+zDnqkyHYQj5uNwRTlmny54vtNTUMmX
         8AogeRn3NgwMmzaOyyK6GfEvjYeQnuAv3yKwxd43sC6uohhkadWq+8coJkFbYJ5+D/Km
         XejB2gwkjTYWJo4tvSXVPrKI27Ek1MbJ9iVAY+TpqDgJX8DLS1w51IphuWkyCGHLrI2F
         lUKTaVWVLWokII/enI5sTzY2goarLcsM8KL0LT1J7MXqCbGjZRVkxmiyAwk2wyZhxED9
         +FJw==
X-Gm-Message-State: AAQBX9dXeOcVvWpzPGEfpIxc61X2KYF6hmrZbNtKDlqhp4L/FzxUu8hD
        vZGHqiqOjacLT9F65dFV/Ddcmrpl50PuYFTOITuYMQ==
X-Google-Smtp-Source: AKy350ZG54sskJr9+6Rk/bF4beh6phNArrzS+JCoxuIwZqm52kmnV6T7Xj87swvz8GiDFQrmhmNBGw==
X-Received: by 2002:a17:90a:4607:b0:23f:3539:d326 with SMTP id w7-20020a17090a460700b0023f3539d326mr24986614pjg.0.1681335637192;
        Wed, 12 Apr 2023 14:40:37 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id q24-20020a170902b11800b0019e8915b1b5sm54560plr.105.2023.04.12.14.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 14:40:36 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pmiCg-002e8F-2u; Thu, 13 Apr 2023 07:40:34 +1000
Date:   Thu, 13 Apr 2023 07:40:34 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: verify buffer contents when we skip log replay
Message-ID: <20230412214034.GL3223426@dread.disaster.area>
References: <20230411233159.GH360895@frogsfrogsfrogs>
 <ZDahf6XEA2trj7sQ@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDahf6XEA2trj7sQ@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 12, 2023 at 05:18:07AM -0700, Christoph Hellwig wrote:
> On Tue, Apr 11, 2023 at 04:31:59PM -0700, Darrick J. Wong wrote:
> > Unfortunately, the ondisk buffer is corrupt, but recovery just read the
> > buffer with no buffer ops specified:
> > 
> > 	error = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno,
> > 			buf_f->blf_len, buf_flags, &bp, NULL);
> 
> > +
> > +		/*
> > +		 * We're skipping replay of this buffer log item due to the log
> > +		 * item LSN being behind the ondisk buffer.  Verify the buffer
> > +		 * contents since we aren't going to run the write verifier.
> > +		 */
> > +		if (bp->b_ops) {
> > +			bp->b_ops->verify_read(bp);
> > +			error = bp->b_error;
> > +		}
> 
> How do we end up with ops attached here if xfs_buf_read doesn't
> attach them?  The buf type specific recover routines later attach
> ops, but this is called before we reach them.

The line of context above this hunk you cut out does exactly
that. i.e. this call:

		xlog_recover_validate_buf_type(mp, bp, buf_f, NULLCOMMITLSN);

-Dave.
-- 
Dave Chinner
david@fromorbit.com
