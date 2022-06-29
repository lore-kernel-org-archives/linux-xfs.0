Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53A5FC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 09:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbiF2JNB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 05:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232583AbiF2JNA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 05:13:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 301A41D0FD
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 02:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656493979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PHkzl/CtxfMEiDrBCMjqTBVk/1t45A9zbY4QPN+Lk68=;
        b=CDikhBlJMh8mT6WkNefiLZIHlSVyJW4eQORz/kjzG1rablvNu1FhtBvpB6GmkOEOEXJYkJ
        e6/PnHwMsrtoyErBkQae6tH2etYsXyK8fZ/YU0W/+o0QtbFv4HNRy8gIfrzAYhnPunA13y
        WpgoJKdhnH5TFaVi2MDDLStRyOWv2UU=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-38-6MxigpJmO3mnA2oOwJ9Gfg-1; Wed, 29 Jun 2022 05:12:57 -0400
X-MC-Unique: 6MxigpJmO3mnA2oOwJ9Gfg-1
Received: by mail-qv1-f69.google.com with SMTP id v13-20020ad4528d000000b004707f3f4683so14827252qvr.14
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 02:12:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PHkzl/CtxfMEiDrBCMjqTBVk/1t45A9zbY4QPN+Lk68=;
        b=MM0VOg93+3/tyEWlAnlHjjLEzoT9p7J/9FixwCKHi+ZRxhSCsd0QtQ9ok+wOe5oMSq
         YnWY/pBt1Dd0LBDuDP46ZqkaHMYqn29DnDDKpWO4Gk9Ay/bQQAbtfx3Sklp/4KFpTO3C
         +D8Nt2A4odYerGgEeUnfg3bs4kDfKQAq+G5rSiZY4SyUZ1mFwozlmmAY16oa3KLfQ0AT
         t3Kc21+J2RY5L7qftlq1N4D6fJL+2QigI7ysK2cbaHslWeqa+zh9lZZDJySNTJOK55wE
         yssozimLIWkSrnH1Ja8+aDnDiQfY3kPXDAdeCYKaQaBePGiht1JvZ8nd061ITqhJCNlm
         QbqQ==
X-Gm-Message-State: AJIora84kjWehUDOZXm0RdrmzwONeOzaLs1HZUhv9cT3EnUYkaiMyy8J
        bUAmcX9Kp0r5R5vaQSv/KO43HRP3MRrJtyUWXv/FYrlwp3k4+XkLuT78tcwa5PWV1k4t+2nztXj
        L9h89Sb7TUDnBaJuY35aU
X-Received: by 2002:ac8:584b:0:b0:31b:efad:e020 with SMTP id h11-20020ac8584b000000b0031befade020mr1461177qth.425.1656493976170;
        Wed, 29 Jun 2022 02:12:56 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vxPr2jKgDwkUQSZ+OnlrTusU8D4te8AP8eevk1tsKEwY1lBipsJ+RbHgcqLIL8sr82M3GFYw==
X-Received: by 2002:ac8:584b:0:b0:31b:efad:e020 with SMTP id h11-20020ac8584b000000b0031befade020mr1461165qth.425.1656493975905;
        Wed, 29 Jun 2022 02:12:55 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r4-20020ac84244000000b00317ca023e33sm10056891qtm.80.2022.06.29.02.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 02:12:55 -0700 (PDT)
Date:   Wed, 29 Jun 2022 17:12:48 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs/070: filter new superblock verifier messages
Message-ID: <20220629091248.vtqtlk2wvqkmtxkm@zlang-mailbox>
References: <165644767753.1045534.18231838177395571946.stgit@magnolia>
 <165644768886.1045534.3177166462110135738.stgit@magnolia>
 <20220629041547.GO1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629041547.GO1098723@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 29, 2022 at 02:15:47PM +1000, Dave Chinner wrote:
> On Tue, Jun 28, 2022 at 01:21:28PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > In Linux 5.19, the superblock verifier logging changed to elaborate on
> > what was wrong.  Fix the xfs_repair filtering function to accomodate
> > this development.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  common/repair |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > 
> > diff --git a/common/repair b/common/repair
> > index 463ef9db..398e9904 100644
> > --- a/common/repair
> > +++ b/common/repair
> > @@ -29,6 +29,7 @@ _filter_repair()
> >  # for sb
> >  /- agno = / && next;	# remove each AG line (variable number)
> >  s/(pointer to) (\d+)/\1 INO/;
> > +s/Superblock has bad magic number.*/bad magic number/;
> >  # Changed inode output in 5.5.0
> >  s/sb root inode value /sb root inode /;
> >  s/realtime bitmap inode value /realtime bitmap inode /;
> 
> Didn't I already fix that in commit 4c76d0ba ("xfs/070: filter the
> bad sb magic number error")?

Yes, you've added a line as below:
  s/^Superblock has (bad magic number) 0x.*/\1/;
which is equal to:
  s/Superblock has bad magic number.*/bad magic number/;
So we need to fix it again.

> 
> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 

