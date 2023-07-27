Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 736E7C41513
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 03:26:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjG0D0d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Jul 2023 23:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbjG0D0c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jul 2023 23:26:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302272127
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jul 2023 20:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690428344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=retRHZZ4WFUgburZXns/fqADaGNP8g2q2H1nB0JLVuY=;
        b=ICRyDQLyjR7usM+EVdFOg+vtNszsceVvx7WgSdDkzh0XEW7oxiH0QE5rHrRmtJAwALO5SK
        FLqa16L/6UZH9ZH3rdkGXwHNz5xx9F+/phjj9rEoGJL4EVDKS95uYrWH5+lXiCY8GaqSUm
        JG2CS0FjT0FcWZjSJwBtT06DhLKTfzo=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-557-f83ofUecNoOlGhGmMpsaeg-1; Wed, 26 Jul 2023 23:25:43 -0400
X-MC-Unique: f83ofUecNoOlGhGmMpsaeg-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1bbd260ca2dso4276055ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jul 2023 20:25:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690428342; x=1691033142;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=retRHZZ4WFUgburZXns/fqADaGNP8g2q2H1nB0JLVuY=;
        b=WOL8ZbsvBmKqQEfiXG5SLn6QyDdOMYl50w0NKeFFogv+t/q+3L+AriYR3j0++gZHck
         5D4oRPd1ZNLT7uPlutyIwEtLmS5ENYVBW7n/1WvDO1CuKk6Pa3bnEGTX19/ZfLD3i16c
         sC69sbo9Z3Uqr+htGyfVAs8w9tPlchCaEGP9AIkZkwfpnJrtvrvF/NG9oTSo/3DksuFb
         BrxqC9hk6Fn9n+g+CUNS/3eQWemqmJm/8SvCWaACW9xVwD+wnz5E05NaeBhwMslFF3Lx
         iS5eoqepYcQntPf2a5xkoUUzqKiVdBA7gHVw9RBywyiY7APQLhDytpylkfVU9vBtXiLK
         cfsw==
X-Gm-Message-State: ABy/qLYyq+5XZG7u7qpOZlyATJc3REiufzvaXy+/irWrJ84Ar676kt9X
        LBEFKuVpB9qdovMWAgi3FHtcIc10Z1EGUUDY5WWyKtMcPGb9mW1qDiSqf921s8zyIK0c+4QtbTO
        /yeE7aYqbVO/ycl1QKJ2v
X-Received: by 2002:a17:903:2311:b0:1b3:d4d5:beb2 with SMTP id d17-20020a170903231100b001b3d4d5beb2mr5591653plh.9.1690428342013;
        Wed, 26 Jul 2023 20:25:42 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGr6P6lhARPVq35Sz98PkJ7CfdygFWGoQHdTRc+q7xfzvanHeUOLNFNhOgou2zlwBQyALCaPQ==
X-Received: by 2002:a17:903:2311:b0:1b3:d4d5:beb2 with SMTP id d17-20020a170903231100b001b3d4d5beb2mr5591635plh.9.1690428341700;
        Wed, 26 Jul 2023 20:25:41 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id a12-20020a170902eccc00b001b03b7f8adfsm301472plh.246.2023.07.26.20.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 20:25:41 -0700 (PDT)
Date:   Thu, 27 Jul 2023 11:25:37 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] check: add a -smoketest option
Message-ID: <20230727032537.hyqyuvemnwmh25d5@zlang-mailbox>
References: <168972905626.1698606.12419796694170752316.stgit@frogsfrogsfrogs>
 <20230719151024.ef7vgjmtoxwxkmjm@zlang-mailbox>
 <20230719152907.GA11377@frogsfrogsfrogs>
 <20230719161115.byva7tvwoafkesga@zlang-mailbox>
 <20230720022756.GH11352@frogsfrogsfrogs>
 <20230720143433.n5gkhukdkz7s5ab7@zlang-mailbox>
 <20230726000524.GG11340@frogsfrogsfrogs>
 <20230726060102.GB30264@mit.edu>
 <20230726145441.lbzzokwigrztimyq@zlang-mailbox>
 <20230726205930.GC30264@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230726205930.GC30264@mit.edu>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 26, 2023 at 04:59:30PM -0400, Theodore Ts'o wrote:
> On Wed, Jul 26, 2023 at 10:54:41PM +0800, Zorro Lang wrote:
> > 
> > Ahaha, I'm just waiting for Darrick wake up, then ask him is there any
> > requirement/context about this patch. Due to he (looks like) a bit
> > hurry to push this patch :)
> > 
> > If most of you prefer this way (an ./check option, not a separated wrapper
> > script), I'm OK with that.
> 
> I'm agnostic on that front, since I already *have* my own wrapper
> script.  So if we need to do it in the wrapper script, I'm certainly
> OK with that.  OTOH, if we think it's a feature which is generally
> interesting to multiple developers and/or test wrappers, maybe it
> makes sense to push things into the ./check sccript.
> 
> So I certainly don't have any objections to adding support to my
> /root/runtests.sh so that "{gce,kvm,android}-xfstests smoke" gets ends
> up running the moral equivalent of:
> 
> SOAK_DURATION=4m ./check -g smoketest

Hi Ted,

Now we provide two ways to help to customize testing in fstests:

1)
https://lore.kernel.org/fstests/20230727030529.r4ivp6dmtrht5zo2@zlang-mailbox/T/#mc5cdb59344f4cd681515bf0fab501d7f30f1e263

2)
https://lore.kernel.org/fstests/169033660570.3222210.3010411210438664310.stgit@frogsfrogsfrogs/T/#u

Which one do you like to use? I'd like to hear more review points before I
choose one to merge.

Thanks,
Zorro

> 
> ... and adding extra special case support in the check script just for
> this use case.  I'm doing enough other stuff in runtests.sh[1] that
> it's really not a big deal for me.  :-)
> 
> [1] https://github.com/tytso/xfstests-bld/blob/master/test-appliance/files/root/runtests.sh
> 
> 
> More generally, there are some "intresting" hacks --- for example, I
> want to be able to run code in between every single test run, and the
> way I do it is a big ugly, but effective.  I basically set
> 
> LOGGER_PROG to my own special script, gce-logger[2]
> 
> [2] https://github.com/tytso/xfstests-bld/blob/master/test-appliance/files/usr/local/lib/gce-logger
> 
> and this allows the user to upload a script which will get run in
> between every single individual fstest (e.g., to grab information from
> BPF, or grab and reset lockstats, etc.).  This script also updates the
> VM metadata so someone can query the VM to find out what test it's
> currently running, and the percentage completion for that VM.
> 
> I could have asked for extra features in check, but whenever possible
> I try to work around it to limit the number of special things just for
> my set of wrapper scripts.
> 
> 
> > Just recently I'm a bit worry about the ./check code, it's becoming more
> > and more complex. I hope to separate something from it, but many things
> > entwined, and growing. Anyway that's another story, I'll look into this
> > patchset and review it soon.
> 
> Well, I don't use the config sections feature at all, because my
> wrapper script has a lot more functionality than what you can get with
> the config sections, so I just pass in TEST_DEV, SCRATCH_DEV,
> MKFS_OPTIONS, etc., via environment variables, and I have my own set
> of scripts to set up te test parameters.
> 
> So if you were going to simplify things by removing config sections,
> *I* wouldn't care.  Enough other people might be using it that
> changing the fstests interface for this might raise a lot of
> objections from other folks, though.
> 
> Cheers,
> 
> 					- Ted
> 

