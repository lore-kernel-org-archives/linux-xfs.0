Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77584C001E0
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 15:31:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbjG0Pbr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 11:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbjG0Pbq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 11:31:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A551BFB
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 08:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690471856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ipwWv9qohygmDheSwvipDL61mRNhGhWvzTXZaxmmTb0=;
        b=asysvNaN6kJJsFg5GuX8A9PJK/jLv46rIZzk3AlVQ/qe4JAxgtmCN+Q79qwD718A3g5XrW
        9poN9FjgiXPonrPjDeZVf30p6AGeUV84kH4EolyC42oyKB/tOngyvdGg//RHIMPkIVucH2
        ZyBPw3UD2Ilwn+EHcn2jeuxXK+AHEfI=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203-IkgSEW8qPUSpR8-IlupFpw-1; Thu, 27 Jul 2023 11:30:53 -0400
X-MC-Unique: IkgSEW8qPUSpR8-IlupFpw-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-6870778be4eso196877b3a.3
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 08:30:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690471852; x=1691076652;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ipwWv9qohygmDheSwvipDL61mRNhGhWvzTXZaxmmTb0=;
        b=Cm4KNlzgESlO5Ik+LJ04OIfetSAGMG62gOb9sqDimyRF3TiBx9il1XnDleH8qNl2qT
         INkqKg7LTXzaQ7k9BFkSDOlxWFRFP0Ki+TMGxjadsNOKYbOBGDzDQqinxINDFU79201X
         d/chf5HhPyhwKBFuuZH9rsbrep+DMMtJAYx965V+iDrfw9+IOLtAu4werEI8l5G0GBNV
         ItfGzvm5QCSiP4v0wbrDKkb5P40PMkN+JXiMka8NbLb2SHu9jLpW6WqgDTtnjJGVkTCU
         +e6/IZ0MW4qesHa90MaETDf1AI+dEUKT7pzWm4OD6jbAkp+VRF4gXmUwNR2LoqIpx7MO
         chdg==
X-Gm-Message-State: ABy/qLajHpPkFOSx5lvMt9ymi0Z7wZRaU3bzgQ0vP96kelOcaRKkOmds
        0p0ho3rtoIoGq3WMWKvdlBT5XDatBef0pp0NgWx6cM7cGqn87ui9xCCWVNfxpmlWoZT12rXc4gL
        YdTZnY8pmVZJaSTXXzvv+
X-Received: by 2002:a05:6a20:8c:b0:138:60e:9c4 with SMTP id 12-20020a056a20008c00b00138060e09c4mr3996387pzg.23.1690471852288;
        Thu, 27 Jul 2023 08:30:52 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHS6CrrNztyfJmUF8E4eU5gwZc9Nmnz2D1mNhus7Es3PhlLRFOz771yGYgzr/XY+OLEWMa8jA==
X-Received: by 2002:a05:6a20:8c:b0:138:60e:9c4 with SMTP id 12-20020a056a20008c00b00138060e09c4mr3996368pzg.23.1690471851896;
        Thu, 27 Jul 2023 08:30:51 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id j22-20020aa78016000000b006862b2a6b0dsm1701992pfi.15.2023.07.27.08.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 08:30:51 -0700 (PDT)
Date:   Thu, 27 Jul 2023 23:30:46 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] check: add a -smoketest option
Message-ID: <20230727153046.dl4palugnyidxoe7@zlang-mailbox>
References: <20230719152907.GA11377@frogsfrogsfrogs>
 <20230719161115.byva7tvwoafkesga@zlang-mailbox>
 <20230720022756.GH11352@frogsfrogsfrogs>
 <20230720143433.n5gkhukdkz7s5ab7@zlang-mailbox>
 <20230726000524.GG11340@frogsfrogsfrogs>
 <20230726060102.GB30264@mit.edu>
 <20230726145441.lbzzokwigrztimyq@zlang-mailbox>
 <20230726205930.GC30264@mit.edu>
 <20230727032537.hyqyuvemnwmh25d5@zlang-mailbox>
 <20230727143326.GG30264@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230727143326.GG30264@mit.edu>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 27, 2023 at 10:33:26AM -0400, Theodore Ts'o wrote:
> On Thu, Jul 27, 2023 at 11:25:37AM +0800, Zorro Lang wrote:
> > > SOAK_DURATION=4m ./check -g smoketest
> > 
> > Now we provide two ways to help to customize testing in fstests:
> > 
> > 1)
> > https://lore.kernel.org/fstests/20230727030529.r4ivp6dmtrht5zo2@zlang-mailbox/T/#mc5cdb59344f4cd681515bf0fab501d7f30f1e263
> > 
> > 2)
> > https://lore.kernel.org/fstests/169033660570.3222210.3010411210438664310.stgit@frogsfrogsfrogs/T/#u
> > 
> > Which one do you like to use? I'd like to hear more review points before I
> > choose one to merge.
> 
> (1) is the "./check -t smoketest" option, and it provides a more
> generic way of adding new templates.  On the positive side it allows
> more of this kind of simple "configuration" style options where "-t
> smoketest" is essentially syntactic sugar for:
> 
> 	SOAK_DURATION=${SOAK_DURATION:-4m} ./check -g smoketest"
> 
> The potential disadvantage of (1) is that it seems like extra
> complexity for what is really simple.
> 
> 
> (2) is "./check -smoketest" option.  Its advantage is that it might
> easier for a drive-by patcher to type.  The disadvantage is that it's
> adding Yet Another Option to the ./check script.
> 
> I also will note that we have some "long options" which use a single
> hypen (e.g., -overlay and -udiff) but newer "long options" seem to use
> the double hypehn approach (e.g., --exact-order and --large-fs).  My
> personal preference is for the newer GNU getopt style of using double
> hyphens, but the fact that we have both types of long options
> is... unfortunate.

Yeah, I'd like to tidy the ./check, include the option names. But change the
check option format will affect many users, cause most of their scripts go
wrong suddently, then they need to check and use new option format. That's
why I still not touch this part.

> 
> 
> I guess I have a slight preference for (1), but I'm really not sure
> either is really necessary.  My view is that for a drive-by tester,
> trying to set up xfstests is Too Hard.  So the reality is they will be
> using some kind of wrapper script --- either one that they've written
> for their own, such as what Darrick (and I assume other XFS developers
> have their own), or they're using something like kdevops or
> kvm-xfstests.

Sure, you're right. fstests can be used to do a simple test, but for regular
test, a wrapper is needed. Darrick has his wrapper, Dave might has his wrapper
too. My team also has our wrapper, (we also have wrappers to run ltp and others).
Different users might have different testing environment, so they might build
different wrappers to connect fstests with their own environment/requirement.

So I'd like to keep fstests as simple underlying test cases, provide basic
testing functions to anyone who would like to run it, try to not limit much
things. But I'd like to let fstests provides more help to each of your testing
requirement. That's my current crude thought :-P

> 
> From *my* perspective, I have absolutely *no* problem with having my
> wrapper script use:
> 
> 	SOACK_DURATION=4m ./check -g smoketest
> 
> because I only have to do it once, and no end-user is ever going to
> see it.  They will just use "kvm-xfstests smoke", and all of the magic
> will be hidden from them.
> 
> The main advantage of having some kind of "official" top-level way of
> specifying the smoke test is that it makes it more likely that
> different wrapper scripts will converge on the same kind of smoke
> test, and it becomes easier for fstests developers to communicate with
> each other because the concept of what a "smoke test" is has been well
> defined in the fstests source code.  And for that purpose, I think the
> "./check -t smoketest" approach works just fine.

OK, thanks for your reply. I'll double check with Darrick, then merge
one of them :)

Thanks,
Zorro

> 
> But really, I can live with either.   :-)
> 
> Cheers,
> 
> 						- Ted
> 

