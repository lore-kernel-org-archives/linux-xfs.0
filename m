Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D9C6C433E0
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 00:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A0EB23A7C
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 00:51:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbhAIAvU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Jan 2021 19:51:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60289 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726396AbhAIAvR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jan 2021 19:51:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610153389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RBFlUZnsdmO2Au6CZ7NolIOh5pCNrGUAYiQ25Z5EI+Q=;
        b=IAxra0NO9XsCpYxq8EuHKWXmmBVapNTbpk2RpN0HaFwAkTjvLBKV3NDeZNrqCbdxSAH7xB
        wI/eynCa6UpAY/LkMXUaB3vGBQAg4b0VgRdJcK2pwStZkHM7073tcfUyblzdZMq5OY5kWQ
        VFosCcMdV+FGnQL+SL64/srQBAHyNhg=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-UuY7qY6AOCSpr-FmH_H46Q-1; Fri, 08 Jan 2021 19:49:45 -0500
X-MC-Unique: UuY7qY6AOCSpr-FmH_H46Q-1
Received: by mail-pl1-f197.google.com with SMTP id l11so7312189plt.2
        for <linux-xfs@vger.kernel.org>; Fri, 08 Jan 2021 16:49:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RBFlUZnsdmO2Au6CZ7NolIOh5pCNrGUAYiQ25Z5EI+Q=;
        b=OPuvjKcfrQhbWbJNbAdqdKtHnz6qMLS8iTC0GzdVfNyYR3zPd+gaVEdoM8B826x+j7
         vjvYSAXeLWfkjYjDvobcb1D5enKK83Ei9AguapjcRa5lFly5auYTJwJ9klTuwedddlJg
         DarGpy24YcCDlKI0UyXGiFdisQu/iWnJgPzhwIeeUWM4Q0wUkJt8c1TbLeEHc41Bovg4
         i+cquWkZQOABP59x1cFg0Js103C0FQsaKDsgcB9fSNlgL8Qjz0JnhnXfPh3qJXgw/LCa
         OlKKXqHu8NUU3vH1abUxupKhHJzm6ScmKfayz7NLeQqJ8zkdD86oqTp7K/RRvQ8coz+4
         nBog==
X-Gm-Message-State: AOAM530ROOekEq6iuQSRKelZXvFQNCzoZf2RT7R5ZbnCwkQXhNLB5dZS
        3RAAEWyFzV4jqeO+OwNGeypG+2crxUDrTg1FZbyIL06DdF5LpDqUjC7ph7siPwMCG8QeCaywrjq
        ycDNAQIaW/Xp8SonCVnjn
X-Received: by 2002:a17:90a:74cd:: with SMTP id p13mr6212432pjl.25.1610153384742;
        Fri, 08 Jan 2021 16:49:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxM15KUDI+fwszRdBbR1bRldv3EqeR5ygdU0ZxakTu97L6VH3pfRLbfXVnpu0d7V8YUD9ZPSw==
X-Received: by 2002:a17:90a:74cd:: with SMTP id p13mr6212418pjl.25.1610153384519;
        Fri, 08 Jan 2021 16:49:44 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e13sm10151367pfj.63.2021.01.08.16.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 16:49:44 -0800 (PST)
Date:   Sat, 9 Jan 2021 08:49:34 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3 2/4] xfs: get rid of xfs_growfs_{data,log}_t
Message-ID: <20210109004934.GB660098@xiangao.remote.csb>
References: <20210108190919.623672-1-hsiangkao@redhat.com>
 <20210108190919.623672-3-hsiangkao@redhat.com>
 <20210108212132.GS38809@magnolia>
 <f1b99677-aefa-a026-681a-e7d0ad515a8a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f1b99677-aefa-a026-681a-e7d0ad515a8a@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 08, 2021 at 03:27:21PM -0600, Eric Sandeen wrote:
> On 1/8/21 3:21 PM, Darrick J. Wong wrote:
> > On Sat, Jan 09, 2021 at 03:09:17AM +0800, Gao Xiang wrote:
> >> Such usage isn't encouraged by the kernel coding style.
> >>
> >> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> >> ---
> >>  fs/xfs/libxfs/xfs_fs.h |  4 ++--
> >>  fs/xfs/xfs_fsops.c     | 12 ++++++------
> >>  fs/xfs/xfs_fsops.h     |  4 ++--
> >>  fs/xfs/xfs_ioctl.c     |  4 ++--
> >>  4 files changed, 12 insertions(+), 12 deletions(-)
> >>
> >> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> >> index 2a2e3cfd94f0..a17313efc1fe 100644
> >> --- a/fs/xfs/libxfs/xfs_fs.h
> >> +++ b/fs/xfs/libxfs/xfs_fs.h
> >> @@ -308,12 +308,12 @@ struct xfs_ag_geometry {
> >>  typedef struct xfs_growfs_data {
> >>  	__u64		newblocks;	/* new data subvol size, fsblocks */
> >>  	__u32		imaxpct;	/* new inode space percentage limit */
> >> -} xfs_growfs_data_t;
> >> +};
> > 
> > So long as Eric is ok with fixing this up in xfs_fs_compat.h in
> > userspace,
> > 
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Sure, why not :) (tho is growfs really a public interface?  I guess so,
> technically, though not documented as such.)

Yeah, although I think nobody else uses it (I could leave the typedef
definitions only if needed otherwise...)

Thanks,
Gao Xiang

> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> -Eric
> 

