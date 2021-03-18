Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28191C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 11:41:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C91AE64F2A
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 11:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhCRLk7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 07:40:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35114 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbhCRLkq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Mar 2021 07:40:46 -0400
Received: from ip5f5af0a0.dynamic.kabel-deutschland.de ([95.90.240.160] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1lMr17-0002fy-PH; Thu, 18 Mar 2021 11:40:41 +0000
Date:   Thu, 18 Mar 2021 12:40:41 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Vivek Goyal <vgoyal@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] fs: improve naming for fsid helpers
Message-ID: <20210318114041.n4jjnhjkiflekm25@wittgenstein>
References: <20210315145419.2612537-1-christian.brauner@ubuntu.com>
 <20210315145419.2612537-3-christian.brauner@ubuntu.com>
 <20210318062723.GB29726@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210318062723.GB29726@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 18, 2021 at 07:27:23AM +0100, Christoph Hellwig wrote:
> > -static inline kuid_t fsuid_into_mnt(struct user_namespace *mnt_userns)
> > +static inline kuid_t idmapped_fsuid(struct user_namespace *mnt_userns)
> >  {
> >  	return kuid_from_mnt(mnt_userns, current_fsuid());
> >  }
> >  
> > -static inline kgid_t fsgid_into_mnt(struct user_namespace *mnt_userns)
> > +static inline kgid_t idmapped_fsgid(struct user_namespace *mnt_userns)
> >  {
> >  	return kgid_from_mnt(mnt_userns, current_fsgid());
> >  }
> 
> I'm not sure the naming is an improvement.  I always think of
> identity mapped when reading it, which couldn't be further from what
> it does..  But either way comments describing what these helpers do
> would be very useful.

Good point. I'll add comments!
