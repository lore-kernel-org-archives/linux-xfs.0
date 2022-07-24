Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AC3EC433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Jul 2022 14:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbiGXOBj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 Jul 2022 10:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiGXOBi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Jul 2022 10:01:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F191E1208C
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jul 2022 07:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658671296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wzjWFBWWzS3vs3FN1IPanHJriLLGg6ks/nHjRtM9sk4=;
        b=AwHbDveBkK2jWrGYFLxI7zrYRryHXUQs3PMguf6I1lPeWOLSvSk/H5GTpCnT2TVYdMsH9q
        bie8HrkPMQGv3gsZkM9dPSN8ap67cZVoZs3DuI3qMSCEFUPBV064hV7uUQ5tQhA/caVmBA
        oj5r5UwKake5eV7z9RHeQSCTmcffRKY=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-28-teEG7i6dOW2GUYIDIdCAfw-1; Sun, 24 Jul 2022 10:01:34 -0400
X-MC-Unique: teEG7i6dOW2GUYIDIdCAfw-1
Received: by mail-qk1-f199.google.com with SMTP id j16-20020a05620a411000b006b5fb8e5d95so7782395qko.19
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jul 2022 07:01:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wzjWFBWWzS3vs3FN1IPanHJriLLGg6ks/nHjRtM9sk4=;
        b=Hwe917oUASEtL/REhS8oN3rwVnU5GaOkyPl2Zpifm414auezGayw+SVwAg3pBEkREu
         9KCckRkEfYRzGxOusQX+K+M056x5DbCABuUEoEbqY5rTgzzzJCAxHENrwFnBzWAMQBpj
         rAmw0eM9OoBYAl2Vv4wO6IZ589wGlE31/5Cr1Pxb7p6V8GVZO/s9S+KPnwOGLorfIufd
         hHfGV43inxvwVcVUfghb1FwBot3YL8ndjbgMH7rbatm2IzrD0nS+jVc4kikZF6nc9wme
         RNZgNWqFXtj3s1BhbniUwYZPRyfT2/edFODHBAmj1LkHS0bSD0XxkRit8gq9+799BldY
         5y2A==
X-Gm-Message-State: AJIora/6rqSG+4l/UuXTWNmI49TZ3ft8nQokYRfHk7m2ehwclOmsS/OL
        c5q1+Pb/f0PQfkIiyakDtUhv0CfmmNiV3XqmSyUdIQbocI4J79um28nDSTwMumuWTCsJAsEDM9R
        DS78ymkWu8uGkDKtxV6JP
X-Received: by 2002:a05:620a:440b:b0:6b6:2e97:e4c with SMTP id v11-20020a05620a440b00b006b62e970e4cmr5863143qkp.649.1658671294213;
        Sun, 24 Jul 2022 07:01:34 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sXjyC2lhd0m4Unr0J9jztJkm6o9Gsai/nnsdBeMnp3H5ecGWasJL9RJPsbpIxbnJsp5aJkvw==
X-Received: by 2002:a05:620a:440b:b0:6b6:2e97:e4c with SMTP id v11-20020a05620a440b00b006b62e970e4cmr5863123qkp.649.1658671293882;
        Sun, 24 Jul 2022 07:01:33 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x29-20020a05620a0b5d00b006a6a4b43c01sm7164773qkg.38.2022.07.24.07.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 07:01:33 -0700 (PDT)
Date:   Sun, 24 Jul 2022 22:01:27 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCHSET v2 0/8] fstests: check file block congruency of file
 range operations
Message-ID: <20220724140127.dm5lf6ibrkzvkcis@zlang-mailbox>
References: <165826663647.3249494.13640199673218669145.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165826663647.3249494.13640199673218669145.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 19, 2022 at 02:37:16PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> I started running fstests with XFS filesystems that don't have the usual
> file geometry characteristics -- block sizes larger than 4k, realtime
> filesystems with extent sizes that aren't a power of two, etc.  What I
> found is that many file operation tests (fallocate, reflink, etc.) that
> operate on disk blocks assume that aligning the arguments to 64k is
> sufficient to avoid EINVAL.  Unfortunately, this just means that these
> tests fail left and right on realtime filesystems where the file
> allocation unit is large (~2MB, anyone?) or a weird number (28K).
> 
> Add a predicate to all of these tests so that we can _notrun them if
> they make assumptions about file size /and/ encode something (usually
> file hashes) in the golden output that mean we can't easily accomodate
> these corner cases without redesigning each test.
> 
> v2: skip congruency tests for network filesystems, be more consistent about
>     TEST_DIR in the arguments, fix a bug in a helper's callsite reported by
>     Zorro.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D

I'd like to merge this patchset after my personal review and testing. As I
didn't find any regression from this patchset, and there's not any objection
from anyone after two weeks passed. So I'm going to merge it, to help Darrick
shift to his next patchset he's working on.

Reviewed-by: Zorro Lang <zlang@redhat.com>

> 
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=check-blocksize-congruency
> ---
>  common/filter     |    4 ++--
>  common/punch      |    3 ++-
>  common/rc         |   28 +++++++++++++++++++++++++++-
>  tests/generic/017 |    2 +-
>  tests/generic/031 |    1 +
>  tests/generic/064 |    2 +-
>  tests/generic/116 |    1 +
>  tests/generic/118 |    1 +
>  tests/generic/119 |    1 +
>  tests/generic/121 |    1 +
>  tests/generic/122 |    1 +
>  tests/generic/134 |    1 +
>  tests/generic/136 |    1 +
>  tests/generic/137 |    1 +
>  tests/generic/144 |    1 +
>  tests/generic/149 |    1 +
>  tests/generic/153 |    2 +-
>  tests/generic/158 |    2 +-
>  tests/generic/162 |    1 +
>  tests/generic/163 |    1 +
>  tests/generic/164 |    1 +
>  tests/generic/165 |    1 +
>  tests/generic/168 |    1 +
>  tests/generic/170 |    1 +
>  tests/generic/181 |    1 +
>  tests/generic/183 |    1 +
>  tests/generic/185 |    1 +
>  tests/generic/186 |    1 +
>  tests/generic/187 |    1 +
>  tests/generic/188 |    1 +
>  tests/generic/189 |    1 +
>  tests/generic/190 |    1 +
>  tests/generic/191 |    1 +
>  tests/generic/194 |    1 +
>  tests/generic/195 |    1 +
>  tests/generic/196 |    1 +
>  tests/generic/197 |    1 +
>  tests/generic/199 |    1 +
>  tests/generic/200 |    1 +
>  tests/generic/201 |    1 +
>  tests/generic/284 |    1 +
>  tests/generic/287 |    1 +
>  tests/generic/289 |    1 +
>  tests/generic/290 |    1 +
>  tests/generic/291 |    1 +
>  tests/generic/292 |    1 +
>  tests/generic/293 |    1 +
>  tests/generic/295 |    1 +
>  tests/generic/352 |    1 +
>  tests/generic/358 |    1 +
>  tests/generic/359 |    1 +
>  tests/generic/372 |    1 +
>  tests/generic/404 |    2 +-
>  tests/generic/414 |    1 +
>  tests/generic/483 |    4 ++++
>  tests/generic/495 |    4 ++++
>  tests/generic/501 |    1 +
>  tests/generic/503 |    4 ++++
>  tests/generic/515 |    1 +
>  tests/generic/516 |    1 +
>  tests/generic/540 |    1 +
>  tests/generic/541 |    1 +
>  tests/generic/542 |    1 +
>  tests/generic/543 |    1 +
>  tests/generic/544 |    1 +
>  tests/generic/546 |    1 +
>  tests/generic/578 |    1 +
>  tests/generic/588 |    2 ++
>  tests/generic/673 |    1 +
>  tests/generic/674 |    1 +
>  tests/generic/675 |    1 +
>  tests/generic/677 |    4 ++++
>  tests/generic/683 |    1 +
>  tests/generic/684 |    1 +
>  tests/generic/685 |    1 +
>  tests/generic/686 |    1 +
>  tests/generic/687 |    1 +
>  tests/generic/688 |    1 +
>  tests/xfs/069     |    1 +
>  tests/xfs/114     |    2 ++
>  tests/xfs/166     |    4 ++++
>  tests/xfs/180     |    1 +
>  tests/xfs/182     |    1 +
>  tests/xfs/184     |    1 +
>  tests/xfs/192     |    1 +
>  tests/xfs/193     |    1 +
>  tests/xfs/198     |    1 +
>  tests/xfs/200     |    1 +
>  tests/xfs/203     |    4 ++++
>  tests/xfs/204     |    1 +
>  tests/xfs/208     |    1 +
>  tests/xfs/209     |    1 +
>  tests/xfs/210     |    1 +
>  tests/xfs/211     |    1 +
>  tests/xfs/212     |    1 +
>  tests/xfs/215     |    1 +
>  tests/xfs/218     |    1 +
>  tests/xfs/219     |    1 +
>  tests/xfs/221     |    1 +
>  tests/xfs/223     |    1 +
>  tests/xfs/224     |    1 +
>  tests/xfs/225     |    1 +
>  tests/xfs/226     |    1 +
>  tests/xfs/228     |    1 +
>  tests/xfs/230     |    1 +
>  tests/xfs/231     |    1 +
>  tests/xfs/232     |    1 +
>  tests/xfs/237     |    1 +
>  tests/xfs/239     |    1 +
>  tests/xfs/240     |    1 +
>  tests/xfs/241     |    1 +
>  tests/xfs/248     |    1 +
>  tests/xfs/249     |    1 +
>  tests/xfs/251     |    1 +
>  tests/xfs/254     |    1 +
>  tests/xfs/255     |    1 +
>  tests/xfs/256     |    1 +
>  tests/xfs/257     |    1 +
>  tests/xfs/258     |    1 +
>  tests/xfs/280     |    1 +
>  tests/xfs/312     |    1 +
>  tests/xfs/315     |    1 +
>  tests/xfs/322     |    1 +
>  tests/xfs/326     |    1 +
>  tests/xfs/329     |    1 +
>  tests/xfs/346     |    1 +
>  tests/xfs/347     |    1 +
>  tests/xfs/436     |    1 +
>  tests/xfs/507     |    3 +++
>  tests/xfs/537     |    2 +-
>  130 files changed, 180 insertions(+), 10 deletions(-)
> 

