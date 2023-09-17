Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62579CD37B4
	for <linux-xfs@archiver.kernel.org>; Sun, 17 Sep 2023 22:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbjIQWqw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 Sep 2023 18:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239794AbjIQWqZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2023 18:46:25 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE61FCE7
        for <linux-xfs@vger.kernel.org>; Sun, 17 Sep 2023 15:44:55 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1c451541f23so6099455ad.2
        for <linux-xfs@vger.kernel.org>; Sun, 17 Sep 2023 15:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1694990695; x=1695595495; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1qyLoA8TT0bit01uyUmgXDLI8KadydZDu/PI6xCrN/Q=;
        b=D5U1Iqq0kZyoDMADIN6UnnxeUHZBU0TK+zLoYnULYfQwTs67Bx3SnTLbmtvLJetXfB
         7PMnvR96paGgA/48BoW+yZrgEr/hKWDtDOdsnwa0Pbl14U5Qp3EKXvDj3jfPZlWU3+PF
         zJtetdK7vPZEPJ9cn0DfNb4u2bV/Qodjt8KIBmJcO8TTZ6OV4ScUMYqP9fhYXArY4jQq
         cKDOmwZOdj+UEEu2PFMSzKN9KQ0oPlg+U7472X9iowox2+RoqyQxw153PGxY8lkaUBDe
         eWjcvL5W+tjqMyzEkDsPU4n1jFhr4IUxIji5EmGxw/ouD1dBB+0Bh7Ew/IAzG1d8ffSa
         Zi9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694990695; x=1695595495;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1qyLoA8TT0bit01uyUmgXDLI8KadydZDu/PI6xCrN/Q=;
        b=CF07eCb60O4NVNG3BSZhkaQ2Xo/kX1/AlS7FDle2i1PbG+XxL5WJHfmKzy82zyc33f
         0GXqXJbb2jVSC9qGt5Cl0D1ulzrV03O9KEE7qKH73dCahnlgia4ikswVP1UrG50Mq7y/
         uyz+dWGxcs8eYhT9f4TTkOssOd1+lECXBFR98yu7iSN24JZadYbaQKG6wNGK47HVmlzc
         6Nv0hBFUZPt29U5gkg6Cgq8ajIB0bG46D9Mwpj3dYqxWljaH5f+FsK7LXiIwqs5NjVNK
         +bWfKmXKFRdYbKq/rzPybGAnyxYtMwMPDAwKO6oun/Yu95C5gbDLVqp25CI+TL1FzbgL
         rjxw==
X-Gm-Message-State: AOJu0YxLOa3XyZMB0LGxN+Y+DlQf2Kzc66dunx9Svf9LZqSmTvPcrDxm
        FnuSImAq80CcbH0EXIxRUttQQQ==
X-Google-Smtp-Source: AGHT+IEo98msZk+KtoOCpjASUTrCWJR5nV+CWsthD9wL8xvjdfQ8r11KrNDPwfuSKyNdkwQsngWjyw==
X-Received: by 2002:a17:903:2643:b0:1bf:703d:cc6b with SMTP id je3-20020a170903264300b001bf703dcc6bmr5214643plb.10.1694990695330;
        Sun, 17 Sep 2023 15:44:55 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id y1-20020a170902ed4100b001c446f12973sm3778194plb.203.2023.09.17.15.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Sep 2023 15:44:54 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qi0VX-00267d-35;
        Mon, 18 Sep 2023 08:44:51 +1000
Date:   Mon, 18 Sep 2023 08:44:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     cheng.lin130@zte.com.cn
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, jiang.yong5@zte.com.cn,
        wang.liang82@zte.com.cn, liu.dong3@zte.com.cn
Subject: Re: [PATCH v3] xfs: introduce protection for drop nlink
Message-ID: <ZQeBY3kmww8qAjfP@dread.disaster.area>
References: <ZQJIyx419cw24ppF@dread.disaster.area>
 <202309151750563356840@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202309151750563356840@zte.com.cn>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 15, 2023 at 05:50:56PM +0800, cheng.lin130@zte.com.cn wrote:
> > On Wed, Sep 13, 2023 at 05:44:45PM +0800, cheng.lin130@zte.com.cn wrote:
> > > From: Cheng Lin <cheng.lin130@zte.com.cn>
> > >
> > > When abnormal drop_nlink are detected on the inode,
> > > shutdown filesystem, to avoid corruption propagation.
> > >
> > > Signed-off-by: Cheng Lin <cheng.lin130@zte.com.cn>
> > > ---
> > >  fs/xfs/xfs_inode.c | 9 +++++++++
> > >  1 file changed, 9 insertions(+)
> > >
> > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > index 9e62cc500..40cc106ae 100644
> > > --- a/fs/xfs/xfs_inode.c
> > > +++ b/fs/xfs/xfs_inode.c
> > > @@ -919,6 +919,15 @@ xfs_droplink(
> > >      xfs_trans_t *tp,
> > >      xfs_inode_t *ip)
> > >  {
> > > +
> > > +    if (VFS_I(ip)->i_nlink == 0) {
> > > +        xfs_alert(ip->i_mount,
> > > +              "%s: Deleting inode %llu with no links.",
> > > +              __func__, ip->i_ino);
> > > +        tp->t_flags |= XFS_TRANS_DIRTY;
> > Marking the transaction dirty is not necessary.
> > Otherwise this seems fine.
> Another strategy: 
> Set nlink to an invalid value(like XFS_NLINK_PINNED), and
> Complete this transaction before shutdown fs. To make sure
> nlink not be zero. If the nlink of a directory are zero, it may
> be cleaned up.
> Is that appropriate?

No, all I'm asking you to do is drop dirtying of the transaction
from this patch because it is a) unnecessary and b) a layering
violation.

It is unnecessary because the transaction will almost always be
dirty before we get to xfs_droplink(). In the cases where it isn't
dirty (e.g. xfs_remove() on a directory) we explicitly check that
nlink == 2 before proceeding to call xfs_droplink(). Hence we can't
actually get to xfs_droplink() with a clean transaction, and so
marking it dirty here on underrun is unnecessary as returning an
error from xfs_droplink() will result in shutting down the
filesystem when the transaction is cancelled.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
