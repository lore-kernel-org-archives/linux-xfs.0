Return-Path: <SRS0=aCB+=YX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B067DCA9EC7
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 15:48:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FA5220656
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 15:48:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ReOfxv/Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfJ3Ps1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Oct 2019 11:48:27 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:41699 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfJ3Ps0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 11:48:26 -0400
Received: by mail-oi1-f195.google.com with SMTP id g81so2360605oib.8
        for <linux-xfs@vger.kernel.org>; Wed, 30 Oct 2019 08:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gj9hCTVviCIZQiNm0Xht1ZF+XXxGcESBre4ygleGi3w=;
        b=ReOfxv/QxhHaYnzVsjGpnkpzC+mLpPUgEM5PXlrtUA08OJQo8FqwhG9/GmjHNa/AZX
         7ZABlnUttnr/chp4n3LNy8BKHEw+rCi5WVberFzFDMQBna5TORGrNWmi4iISs2SG8/Am
         8ifMF4elWxlCPu4LPi1qZs/kTWleNAPC59zhqq1B5Ao5TWThy3iLyMX8MhiRdt+fKl4T
         vv2Ol4C29A7kN2GK/icPQaFlW7ark4WDP7h8s3WWZXXoYx/4Nnpd6JRte5yMIObnocLn
         4DsjWmn0F9eMrFhowv7qsTPrEkxv3W7mFRSG0hWE/MYg6WRtQpxhfePgGxrNjrTr5L4g
         VLNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gj9hCTVviCIZQiNm0Xht1ZF+XXxGcESBre4ygleGi3w=;
        b=Iq+OVolUkN2Q2pcFZ9zd1o8ez66ttql3TK6bbVqlwdLGizu5zDm6E7QofLMMGZZpQ4
         SsH1drEWbWXjRZ9Qg8RyB8t13/OuqE00xyAPDvOIjG66HKIgiJL5tyKTTDBfKrWS7Sk3
         5c9IzK8d2+LrdttBBIO2NwIoRbVme22Af4chgFtN/z8x5J7gMFEhIh/vKDEd8x3AYbO2
         it3OknCM1M6xkSD6YEwwjWuPs5sqGasvQwrGsZZ3VVzeHR9Yp906UQbkclcqEmvlsNW+
         WH5pfX0Ndid9ZKCEdooc9L5E1CAc8uHOBASsWWN7FyGqrHub0I1JSkxypmnTLGkATF1n
         VbmA==
X-Gm-Message-State: APjAAAX9yEGZ9ilhh4Jx6cAcaE9uMpH1NvegwsM3+xC7uvidF5ClgrCW
        9kgHBJfGsQv0CV/rhbXScQY=
X-Google-Smtp-Source: APXvYqy3o2A7KEiENc8IfuQz+dTzxa2VDs6TnpJVMzt0BU/5Bw6L1Eeaye/Bfh+7GKp41OJjzoFXsg==
X-Received: by 2002:a54:4499:: with SMTP id v25mr9529384oiv.17.1572450505567;
        Wed, 30 Oct 2019 08:48:25 -0700 (PDT)
Received: from ubuntu-m2-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id y7sm142421ote.81.2019.10.30.08.48.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 30 Oct 2019 08:48:25 -0700 (PDT)
Date:   Wed, 30 Oct 2019 08:48:23 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Ian Kent <raven@themaw.net>, kbuild@lists.01.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com,
        kbuild test robot <lkp@intel.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [djwong-xfs:mount-api-crash 91/104] fs/xfs/xfs_message.c:23:40:
 warning: address of array 'mp->m_super->s_id' will always evaluate to 'true'
Message-ID: <20191030154823.GA28650@ubuntu-m2-xlarge-x86>
References: <201910291437.fsxNAnIM%lkp@intel.com>
 <20191030033925.GA14630@ubuntu-m2-xlarge-x86>
 <20191030154543.GF15221@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030154543.GF15221@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 30, 2019 at 08:45:43AM -0700, Darrick J. Wong wrote:
> On Tue, Oct 29, 2019 at 08:39:25PM -0700, Nathan Chancellor wrote:
> > On Tue, Oct 29, 2019 at 02:45:40PM +0800, kbuild test robot wrote:
> > > CC: kbuild-all@lists.01.org
> > > CC: "Darrick J. Wong" <darrick.wong@oracle.com>
> > > TO: Ian Kent <raven@themaw.net>
> > > CC: "Darrick J. Wong" <darrick.wong@oracle.com>
> > > CC: Christoph Hellwig <hch@lst.de>
> 
> FYI, It's customary to cc the patch author [and the xfs list]...

Ugh sorry, was in a rush last night and not paying attention :( will be
better next time and thanks for adding the right people!

Cheers,
Nathan
