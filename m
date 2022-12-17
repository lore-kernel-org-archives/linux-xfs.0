Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42120C3DA6E
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Dec 2022 10:01:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbiLQKBZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 17 Dec 2022 05:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiLQKBY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Dec 2022 05:01:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708331BA
        for <linux-xfs@vger.kernel.org>; Sat, 17 Dec 2022 02:00:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671271236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QiA0eqs2hIrTXVUuAbOZCJqheHyB9QNMtE3D6bFqT3o=;
        b=VfJ7jVJH2ZFzOVQ5GvttDGcCabqSqs2ota2bmMOQnVhXpiCxqUSrLeBXj5EeY2GKU+okhV
        DmAgjGX0dyiMxD2WYHdSeJdRdwFAW8Uhvh0a1hNKyMsRkEQsC9JUT3yoDjHGM+00ze2viv
        b7aV77vtXBefKrhzQ/gtOiF+mHNTvoI=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-438-lmnAW25eOFG_9TZwHi72nA-1; Sat, 17 Dec 2022 05:00:35 -0500
X-MC-Unique: lmnAW25eOFG_9TZwHi72nA-1
Received: by mail-pl1-f199.google.com with SMTP id z10-20020a170902ccca00b001898329db72so3358307ple.21
        for <linux-xfs@vger.kernel.org>; Sat, 17 Dec 2022 02:00:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QiA0eqs2hIrTXVUuAbOZCJqheHyB9QNMtE3D6bFqT3o=;
        b=zaWxEnKw8fHcnbXdvD/rag6pNW3yvrnGk/RDbc4RnK5K4A+GL0Fq3cqZ86yxTULDO9
         hOpT5k9ZTQjeULqhx33BZG/aUPpprwoZYOE2m1U5dUqB2ibewHZrbWgJcxUG8s3xxL7H
         a1QCbKD8TEIpHFDh7sdtNmRh/pXfJl/eKoLKnqxkP4ykvykW+zHj14mP2QO7TR+udMeO
         kcdv+vvawO+6LCY/UoFEYmUhRTaTHlFWMY2iAemFhYkb7aM8Ok99QdcfWhb/btleXtMM
         ls9B+J/cAKIq1MI3O+sQqJic+prwd0y/TWHYLee5gMUAiktKfKSBE/yJvzaGzQ0EKWfi
         xebQ==
X-Gm-Message-State: ANoB5pmPTQ7kGmOVQp5Tgr+3A2amZ5Sqy7WCWKAr31kRj4kB/Jros6hC
        XsEStinKGgPBCdQMRdggMLVTmvH+SiEcjCFHQPdtvt3TAbhQPF1yIjbbqwJQb0VLmLdy5urDIZZ
        ttEUd1GmxIILwgs8cPaVk
X-Received: by 2002:a17:902:d192:b0:189:c19a:2cd9 with SMTP id m18-20020a170902d19200b00189c19a2cd9mr29951026plb.25.1671271233811;
        Sat, 17 Dec 2022 02:00:33 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5IuFjDnmGqXa9ce7q7mVU7eUmroPAmzsPZ/4PzEzc1n99LL0sS2IZjrNWwS83lpQd+1qw5MQ==
X-Received: by 2002:a17:902:d192:b0:189:c19a:2cd9 with SMTP id m18-20020a170902d19200b00189c19a2cd9mr29951007plb.25.1671271233494;
        Sat, 17 Dec 2022 02:00:33 -0800 (PST)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c24d00b00189348ab156sm3092346plg.283.2022.12.17.02.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 02:00:33 -0800 (PST)
Date:   Sat, 17 Dec 2022 18:00:29 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs/122: fix EFI/EFD log format structure size after
 flex array conversion
Message-ID: <20221217100029.x4su3x5n3tlnuldi@zlang-mailbox>
References: <167096073708.1750519.5668846655153278713.stgit@magnolia>
 <167096074260.1750519.311637326793150150.stgit@magnolia>
 <20221214184047.k3iaxggotcli4423@zlang-mailbox>
 <Y516UhlSugONPpVp@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y516UhlSugONPpVp@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Dec 17, 2022 at 12:14:10AM -0800, Darrick J. Wong wrote:
> On Thu, Dec 15, 2022 at 02:40:47AM +0800, Zorro Lang wrote:
> > On Tue, Dec 13, 2022 at 11:45:42AM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Adjust this test since made EFI/EFD log item format structs proper flex
> > > arrays instead of array[1].
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > 
> > So we let this case fail on all older system/kernel? Is the kernel patch
> > recommended to be merged on downstream kernel?
> 
> Yes, since there are certain buggy compilers that mishandle the array
> size computation.  Prior to the introduction of xfs_ondisk.h, they were
> silently writing out filesystem structures that would not be recognized
> by more mainstream systems (e.g. x86).
> 
> OFC nearly all those reports about buggy compilers are for tiny
> architectures that XFS doesn't work well on anyways, so in practice it
> hasn't created any user problems (AFAIK).

Thanks, may you provide this detailed explanation in commit log, and better
to point out the kernel commits which is related with this testing change.

Due to this case isn't a case for a known issue, I think it might be no
suitable to add _fixed_by_kernel_commit in this case, but how about giving
more details in commit log.

Thanks,
Zorro

> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > >  tests/xfs/122.out |    8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > 
> > > 
> > > diff --git a/tests/xfs/122.out b/tests/xfs/122.out
> > > index a56cbee84f..95e53c5081 100644
> > > --- a/tests/xfs/122.out
> > > +++ b/tests/xfs/122.out
> > > @@ -161,10 +161,10 @@ sizeof(xfs_disk_dquot_t) = 104
> > >  sizeof(xfs_dq_logformat_t) = 24
> > >  sizeof(xfs_dqblk_t) = 136
> > >  sizeof(xfs_dsb_t) = 264
> > > -sizeof(xfs_efd_log_format_32_t) = 28
> > > -sizeof(xfs_efd_log_format_64_t) = 32
> > > -sizeof(xfs_efi_log_format_32_t) = 28
> > > -sizeof(xfs_efi_log_format_64_t) = 32
> > > +sizeof(xfs_efd_log_format_32_t) = 16
> > > +sizeof(xfs_efd_log_format_64_t) = 16
> > > +sizeof(xfs_efi_log_format_32_t) = 16
> > > +sizeof(xfs_efi_log_format_64_t) = 16
> > >  sizeof(xfs_error_injection_t) = 8
> > >  sizeof(xfs_exntfmt_t) = 4
> > >  sizeof(xfs_exntst_t) = 4
> > > 
> > 
> 

