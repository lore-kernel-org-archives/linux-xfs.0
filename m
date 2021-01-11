Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72BAFC433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 00:19:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D1C622AAF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 00:19:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbhAKATc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Jan 2021 19:19:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50495 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726049AbhAKATb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jan 2021 19:19:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610324283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wj0qgKHXmJTPKqNIGtj9rb5gPwm2Mk6sjAi2s0A8Iw8=;
        b=jO2nKMD9OVbg8yzdtshp0TQH474zXnbjnDedVMD9SM5zo1v8X2e3CXPBCFJTK4ZirMK8gh
        ASNCTd1ZNxm/4JkDSqe8de8ExR5tw3kfeQU8kFuQ/oTngSPlH5DMNnJmB5gVMf1HB3QUdf
        35/3eP+UOoevMhBaf7pvm+q4v6S+S4w=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-551-fT6PrwWFOSqydOPjQcer8w-1; Sun, 10 Jan 2021 19:18:01 -0500
X-MC-Unique: fT6PrwWFOSqydOPjQcer8w-1
Received: by mail-pj1-f70.google.com with SMTP id gv14so10386187pjb.1
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jan 2021 16:18:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wj0qgKHXmJTPKqNIGtj9rb5gPwm2Mk6sjAi2s0A8Iw8=;
        b=hcxqjUGLmMZgo2+MvAhscDjT5k14UTX0jb8bB+lf6vVlPp7/W2fr9KL2irndlWH8ab
         +NnroDP785fDCAC7ApIzJ6F5QxfHbQbe0AQ8LLn+GiVf1XDksEhvYtdDFclTMr8JpcnM
         r/xLbOKniGFeXrFH2gJ3A7ZUb3eutcV6hOJR91Vd+lU4Z+5koUE6g4Wv9HgBzZKK9otG
         pl+7uROaZfZWd3wNqgYuescfaSC8kzvkg+AuAlYLucgJaDJWUdM/0xL650L3i46NDQnt
         Ry5k0s9I6EIGynW0uMNm9bDuOvC2N6PrYZBU4bRCscYbkfcCnM46bF8fYn2Mh8zhYrWg
         llTg==
X-Gm-Message-State: AOAM530N31xcNhxu/IWhAFz5LFPg8bNIEiPqky8puqHO1LS65knntZ4+
        ebEbUX5Fl1QFR0ycYf9yKj/pJ9HSykGeXXmrN+9F9LQGa08ifwwfTzalnT9J4NaQ5cvrQe5M6Pa
        I++BkrAKfkkXDxDYUubtt
X-Received: by 2002:a17:90a:cf17:: with SMTP id h23mr14915043pju.82.1610324280259;
        Sun, 10 Jan 2021 16:18:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxENk58fWFKP3HPyl03hTce+OUGKZ1EUGCLq78jYR34vLY/9mImNxjzj6B82b+Se/oYKfiZMw==
X-Received: by 2002:a17:90a:cf17:: with SMTP id h23mr14915020pju.82.1610324279990;
        Sun, 10 Jan 2021 16:17:59 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f92sm17128130pjk.54.2021.01.10.16.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jan 2021 16:17:59 -0800 (PST)
Date:   Mon, 11 Jan 2021 08:17:49 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3 2/4] xfs: get rid of xfs_growfs_{data,log}_t
Message-ID: <20210111001749.GC660098@xiangao.remote.csb>
References: <20210108190919.623672-1-hsiangkao@redhat.com>
 <20210108190919.623672-3-hsiangkao@redhat.com>
 <20210108212132.GS38809@magnolia>
 <f1b99677-aefa-a026-681a-e7d0ad515a8a@sandeen.net>
 <20210109004934.GB660098@xiangao.remote.csb>
 <20210110210436.GM331610@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210110210436.GM331610@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 08:04:36AM +1100, Dave Chinner wrote:
> On Sat, Jan 09, 2021 at 08:49:34AM +0800, Gao Xiang wrote:
> > On Fri, Jan 08, 2021 at 03:27:21PM -0600, Eric Sandeen wrote:
> > > On 1/8/21 3:21 PM, Darrick J. Wong wrote:
> > > > On Sat, Jan 09, 2021 at 03:09:17AM +0800, Gao Xiang wrote:
> > > >> Such usage isn't encouraged by the kernel coding style.
> > > >>
> > > >> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > >> ---
> > > >>  fs/xfs/libxfs/xfs_fs.h |  4 ++--
> > > >>  fs/xfs/xfs_fsops.c     | 12 ++++++------
> > > >>  fs/xfs/xfs_fsops.h     |  4 ++--
> > > >>  fs/xfs/xfs_ioctl.c     |  4 ++--
> > > >>  4 files changed, 12 insertions(+), 12 deletions(-)
> > > >>
> > > >> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > > >> index 2a2e3cfd94f0..a17313efc1fe 100644
> > > >> --- a/fs/xfs/libxfs/xfs_fs.h
> > > >> +++ b/fs/xfs/libxfs/xfs_fs.h
> > > >> @@ -308,12 +308,12 @@ struct xfs_ag_geometry {
> > > >>  typedef struct xfs_growfs_data {
> > > >>  	__u64		newblocks;	/* new data subvol size, fsblocks */
> > > >>  	__u32		imaxpct;	/* new inode space percentage limit */
> > > >> -} xfs_growfs_data_t;
> > > >> +};
> > > > 
> > > > So long as Eric is ok with fixing this up in xfs_fs_compat.h in
> > > > userspace,
> > > > 
> > > > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Sure, why not :) (tho is growfs really a public interface?  I guess so,
> > > technically, though not documented as such.)
> 
> They are not described in man pages, though they are listed in
> xfsctl(3) so they are definitely public interfaces.
> 
> > Yeah, although I think nobody else uses it (I could leave the typedef
> > definitions only if needed otherwise...)
> 
> It is used elsewhere - ISTR that it is used by a couple of third
> party applications that integrate growing filesystems into their
> other storage management tasks.

Okay, will leave the definitions in the next version.

Thanks,
Gao Xiang

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

