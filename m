Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCF84C433E6
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 14:11:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92D4F6506C
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 14:11:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236018AbhCPOKy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Mar 2021 10:10:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59943 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236008AbhCPOKv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Mar 2021 10:10:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615903849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P7GTdNe6Dy5EEnzGnqdIg1/IwxsKYUNlzyTZ+NhaSQ8=;
        b=aMTwKeK7yrY0nrmAMrQAxgwSEP8N3CYyPAQO6p+Kb0VS27d19EXubcZrZ852in1QyM+TtL
        6Z/acteSxMbUvZh7KlXrkckqISW1NOjL6+EFJDar697OjlL734L8vAht3q4rNY4sQp4jrV
        R8oo6wfRxig8AbgeQhPDxCeoeFvFLTI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-vTwtrKaDOSyV05fyJ64b9A-1; Tue, 16 Mar 2021 10:10:48 -0400
X-MC-Unique: vTwtrKaDOSyV05fyJ64b9A-1
Received: by mail-wr1-f71.google.com with SMTP id n16so15664938wro.1
        for <linux-xfs@vger.kernel.org>; Tue, 16 Mar 2021 07:10:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=P7GTdNe6Dy5EEnzGnqdIg1/IwxsKYUNlzyTZ+NhaSQ8=;
        b=s2ripxNZ6riySiIMWqbLPi6kJ6ah6w9Rjbcg3ir1cFBKCOSuadoYcfG9YvjOXqNU0m
         Ht4VIivDhxoXGmkbH0caTkILHda65Xkun1seo0FUIBzBQIo3v9njCyo73PGAXj7YpiEZ
         px3HXfoh1gNchtM4jsidTtKs43DA0Ny9kkgjrhqYBNmUZ667B715ANbor0pXNlAxlSMJ
         lSxTTwL1Ou8WNJhjMngG7OA4VZj4cIr/7+R2F1rbguWY5R6vzX0u+OGTURf0tMcptG5U
         Xo00liZfZ9SkroFCb7aByieB2Hrs/QLYGQDHSKsSVXWOd10HcZhtHUPwk4ySk0fsXePE
         lOyA==
X-Gm-Message-State: AOAM5327N3cCEC6qflHeHoipbREk3Eut9ifbgSAKIx32VJusVTfNJyyH
        GO8qEf652uRx7Kxv0NajmJYzfY8+n2UXlr8V4ze4tECCFYi2ur9yztqaGmueHsWnZATkGrJPJQN
        FbMMB34maLEklFTmXK6Au
X-Received: by 2002:a5d:4002:: with SMTP id n2mr5255773wrp.148.1615903846639;
        Tue, 16 Mar 2021 07:10:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzEE7ihk/wp6rHXiH2Iji4V4pA0VmH1eg7dL7uGHAhP++vq1g0jUmQMOX1/SibrzuZcHOp1BA==
X-Received: by 2002:a5d:4002:: with SMTP id n2mr5255752wrp.148.1615903846440;
        Tue, 16 Mar 2021 07:10:46 -0700 (PDT)
Received: from andromeda.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id c128sm121089wme.3.2021.03.16.07.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 07:10:45 -0700 (PDT)
Date:   Tue, 16 Mar 2021 15:10:44 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_logprint: Fix buffer overflow printing quotaoff
Message-ID: <20210316141044.4myelroxkotnq57h@andromeda.lan>
Mail-Followup-To: Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs@vger.kernel.org
References: <20210316090400.35180-1-cmaiolino@redhat.com>
 <0a4f390e-53d2-7be9-fc6b-6064f4f8249b@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a4f390e-53d2-7be9-fc6b-6064f4f8249b@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 16, 2021 at 08:45:20AM -0500, Eric Sandeen wrote:
> On 3/16/21 4:04 AM, Carlos Maiolino wrote:
> > xlog_recover_print_quotaoff() was using a static buffer to aggregate
> > quota option strings to be printed at the end. The buffer size was
> > miscalculated and when printing all 3 flags, a buffer overflow occurs
> > crashing xfs_logprint, like:
> > 
> > QOFF: cnt:1 total:1 a:0x560530ff3bb0 len:160
> > *** buffer overflow detected ***: terminated
> > Aborted (core dumped)
> > 
> > Fix this by removing the static buffer and using printf() directly to
> > print each flag. 
> 
> Yeah, that makes sense. Not sure why it was using a static buffer,
> unless I was missing something?
> 
> > Also add a trailling space before each flag, so they
> 
> "trailing space before?" :) I can fix that up on commit.

Maybe I slipped into my words here... The current printed format, did something
like this:

type: USER QUOTAGROUP QUOTAPROJECT QUOTA

I just added a space before each flag string, to print like this:

type: USER QUOTA GROUP QUOTA PROJECT QUOTA


> >  	if (qoff_f->qf_flags & XFS_UQUOTA_ACCT)
> > -		strcat(str, "USER QUOTA");
> > +		printf(" USER QUOTA");
			^ here (an in the remaining ones)

> >  	if (qoff_f->qf_flags & XFS_GQUOTA_ACCT)
> > -		strcat(str, "GROUP QUOTA");
> > +		printf(" GROUP QUOTA");
> >  	if (qoff_f->qf_flags & XFS_PQUOTA_ACCT)
> > -		strcat(str, "PROJECT QUOTA");
> > -	printf(_("\tQUOTAOFF: #regs:%d   type:%s\n"),
> > -	       qoff_f->qf_size, str);
> > +		printf(" PROJECT QUOTA");
> 
> Seems like a clean solution, thanks.
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> > +	printf("\n");
> >  }
> >  
> >  STATIC void
> > 
> 

-- 
Carlos

