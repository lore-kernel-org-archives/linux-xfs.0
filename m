Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D688C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 22:58:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FB78227BF
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 22:58:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732185AbhAYW5u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Jan 2021 17:57:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732154AbhAYW5o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jan 2021 17:57:44 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D3FC061573
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 14:57:03 -0800 (PST)
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1l4An8-0000eI-Ma; Mon, 25 Jan 2021 22:57:02 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#897387: xfslibs-dev needs to include .la files
Reply-To: Bastian Germann <bastiangermann@fishpost.de>,
          897387@bugs.debian.org
X-Loop: owner@bugs.debian.org
X-Debian-PR-Message: followup 897387
X-Debian-PR-Package: xfslibs-dev
X-Debian-PR-Keywords: 
References: <20180501190311.GA30840@bombadil.infradead.org> <20180501190311.GA30840@bombadil.infradead.org> <20180501190311.GA30840@bombadil.infradead.org>
X-Debian-PR-Source: xfsprogs
Received: via spool by 897387-submit@bugs.debian.org id=B897387.16116152941680
          (code B ref 897387); Mon, 25 Jan 2021 22:57:01 +0000
Received: (at 897387) by bugs.debian.org; 25 Jan 2021 22:54:54 +0000
Received: from mail-wr1-x444.google.com ([2a00:1450:4864:20::444]:33056)
        by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <bastiangermann@fishpost.de>)
        id 1l4Al4-0000Qt-GM
        for 897387@bugs.debian.org; Mon, 25 Jan 2021 22:54:54 +0000
Received: by mail-wr1-x444.google.com with SMTP id 7so14607274wrz.0
        for <897387@bugs.debian.org>; Mon, 25 Jan 2021 14:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=to:references:subject:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=RIYXj9oc6TApFxTYKjM0hi7AgQEg20CChJmWQ9GCFYs=;
        b=fJgLeDSXhVM4y8mib9HQL2P+DNd2HRjXE4apQyAo5qbgarwQooD5uCLIQoToRT5eBO
         FaCv7M3RTOUs4gYdC2DHjlm2b1JLpDeKuJy085CkB1d2r+Fv4MySA/xMa5jomnCz9R+5
         27/fsdZek1ppjl/uE1fJF+M2PU39H6S2bpHsnzsoXsO3Jo1BecprjRXPsnUr7F6ybuY8
         fv99XTsii3Toc/f7oIWhaJJ5wUJlQRyDvFKe+HHHL6Uh4ZN0c5QhmRgKRu38jEhsfpG+
         Zf9udb66zsOzwE49aQfp7Se/nCMZrwIBP5G4g3ELkQ0bYjtSNONPPxMlhwmGdbijr6Nf
         Naxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:subject:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RIYXj9oc6TApFxTYKjM0hi7AgQEg20CChJmWQ9GCFYs=;
        b=sS64xmL9FS1pFgGDvH/OEvkD7iN5cJUulB3dLNk5o5obvIXxpKNCCt79ty+Rk99Hje
         +Ho/LjU9QtKAzFLaMVC11mntxgR4nnvSBzW0tvRFJN6foAEBQ9mf/iGvjToIsNkB2D0t
         vlWCskEzZBLQFlNcs0Ce9D0w8RLQc1iDy7YOdVcA0Ya/rCOg4mi4iFCyncVzioA2y5HE
         sN3209dNwU5purXdsopTwKNV79jk9ymGAfe+xj3bIJzYK0WlYMJ7E6z7zdtGP2pjPmM1
         yoz2EQf5714ux9HyTENgO479zZLAJldho0+dageFkgaZjIL8JB2eTasb3bWbEzBsC9LX
         pagA==
X-Gm-Message-State: AOAM533q4BgQxLqJ2iKd8v7C8SbzFGFosTokxNAS3ExYMTaRNy/JzAXQ
        CC5MVpXKPVk4vQ4uJGdKziojCNtHChSAm2UR
X-Google-Smtp-Source: ABdhPJxnl64wI/kYLGmmk7Roe7bGEnXPwlQiqk7GW5decOxhlq5LNT7HJuFgPnp+fJqjQyHvDUTDvg==
X-Received: by 2002:adf:ec52:: with SMTP id w18mr3159220wrn.65.1611615291743;
        Mon, 25 Jan 2021 14:54:51 -0800 (PST)
Received: from ?IPv6:2003:d0:6f35:5400:9d4a:a26f:7cc6:6e27? (p200300d06f3554009d4aa26f7cc66e27.dip0.t-ipconnect.de. [2003:d0:6f35:5400:9d4a:a26f:7cc6:6e27])
        by smtp.gmail.com with ESMTPSA id m8sm21840434wrv.37.2021.01.25.14.54.51
        for <897387@bugs.debian.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 14:54:51 -0800 (PST)
To:     897387@bugs.debian.org
From:   Bastian Germann <bastiangermann@fishpost.de>
Message-ID: <4c267c5f-df65-3c67-0f52-08bbe95928bf@fishpost.de>
Date:   Mon, 25 Jan 2021 23:54:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20180501190311.GA30840@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE-frami
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Tags: wontfix

On Tue, 1 May 2018 12:03:11 -0700 Matthew Wilcox <willy@infradead.org> 
wrote:
> Package: xfslibs-dev
> Version: 4.15.1-1
> 
> trying to build the latest from
> git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
> 
>     [CC]    t_truncate_self
> /bin/bash ../libtool --quiet --tag=CC --mode=link gcc t_truncate_self.c -o t_truncate_self -g -O2 -g -O2 -DDEBUG  -I../include -DVERSION=\"1.1.1\" -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall -DHAVE_FALLOCATE   -lattr /usr/lib/libhandle.la -lacl -lpthread   ../lib/libtest.la
> libtool:   error: cannot find the library '/usr/lib/libhandle.la' or unhandled argument '/usr/lib/libhandle.la'
> 
> I downloaded the debian package of xfslibs-dev, built it, then
> manually copied libhandle/libhandle.la into /lib and then I could build
> xfstests-dev.

Please see https://wiki.debian.org/ReleaseGoals/LAFileRemoval for a 
reason not to include the .la file. In fact, it is explicitly removed 
during the Debian package build. Most probably, you can configure 
xfstests-dev not to require a libhandle.la file.
