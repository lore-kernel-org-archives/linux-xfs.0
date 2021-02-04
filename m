Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E36E0C433DB
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 20:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9ED6064F48
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 20:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhBDUj7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Feb 2021 15:39:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhBDUjv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Feb 2021 15:39:51 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7800EC0613D6
        for <linux-xfs@vger.kernel.org>; Thu,  4 Feb 2021 12:39:07 -0800 (PST)
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1l7lP7-0005jy-Bj; Thu, 04 Feb 2021 20:39:05 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#539723: xfsprogs: {mkfs.xfs] Please provide GNU --long options
Reply-To: Bastian Germann <bastiangermann@fishpost.de>,
          539723@bugs.debian.org
X-Loop: owner@bugs.debian.org
X-Debian-PR-Message: followup 539723
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Keywords: 
References: <20090803093257.29785.85748.reportbug@jondo.cante.net> <20090803093257.29785.85748.reportbug@jondo.cante.net> <20090803093257.29785.85748.reportbug@jondo.cante.net>
X-Debian-PR-Source: xfsprogs
Received: via spool by 539723-submit@bugs.debian.org id=B539723.161247087920221
          (code B ref 539723); Thu, 04 Feb 2021 20:39:04 +0000
Received: (at 539723) by bugs.debian.org; 4 Feb 2021 20:34:39 +0000
Received: from mail-ej1-x635.google.com ([2a00:1450:4864:20::635]:41292)
        by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <bastiangermann@fishpost.de>)
        id 1l7lKo-0005FY-J5
        for 539723@bugs.debian.org; Thu, 04 Feb 2021 20:34:39 +0000
Received: by mail-ej1-x635.google.com with SMTP id f14so7773977ejc.8
        for <539723@bugs.debian.org>; Thu, 04 Feb 2021 12:34:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=GoyoXrI35SR5i1XQECjBQ/vY8Gkp7Blw/u4GG903drg=;
        b=lvI8GItctT1fho0wcT9bKpwte8BF6XAiFswziIA3eHYCChzMFVEsv6TRuVF5HQSoSa
         XPpSU85mQXfCmvVg5up5S9k0BwHowUs0ZD2AOaGqlageH9p/Fo/gvCyr3GdVuvQIcOpB
         tSbBuLVpePjqFQeIOz41W3pOf1YcTE/84SFmWdacxibmIWmjPjEslHwvqLvWM7cCMlWw
         3fXsoBJre8XGOffKml1Jxco1UqNsRJH65g+Pj8Kgb7hwIcdk3xtpyrSY7lrG1YhGxYhd
         xpQsTCEUcHMAxCdHwrYIBE5ND2WMscZiO+nFDus7J/DZqPivUTkP5AVcQeOINb/tuMPC
         2RWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GoyoXrI35SR5i1XQECjBQ/vY8Gkp7Blw/u4GG903drg=;
        b=cgryKi2NNrEL1PB/HmLAanfbbPq5+D7uH39LchDvcGQ9mMo7peJPMsIYbH7dYO7eLL
         yU7wjqmI0mLBlsxFOE+6WadpfJxPlfOT56At3nUakBYJQaq3oERHR2FeZvGUeeUfLvV4
         gOX4TtL/NUA2VWdHaYvzVsGjOP/V5JwAhxX9cnVQgm3T8gl13MaL4Rwu4pPQfTE74107
         aOIMROfbZlg4i/eogjOy9Mxy5sQBLSjJdjCgdPCpq3hXE477NEnfVBMmdTFZ6SK+rusv
         zpqhkhfn7fcYrUdV7vxm1wboVN4KLE4UHBIHaP/t3d/5s2iEQXSju+q414WLRqM3LRzK
         myjg==
X-Gm-Message-State: AOAM533TwK2BmFu1H7fqtnP+ZLSoul2GI2jYtBpsGneiSf1bo53gshk1
        l1s/GW1r8dvK1xiLMlI0uMQlUihEJOXk/J3P
X-Google-Smtp-Source: ABdhPJxtPySvIp8vij7Yj13TFV7L9VtihTVIw8g6lXdyo8+g+cukRKmR1u5x9Eq1MXY4SE5VCxlNiA==
X-Received: by 2002:a17:906:b217:: with SMTP id p23mr899424ejz.126.1612470874994;
        Thu, 04 Feb 2021 12:34:34 -0800 (PST)
Received: from ?IPv6:2003:d0:6f35:5400:ebbc:e7b1:bde:1433? (p200300d06f355400ebbce7b10bde1433.dip0.t-ipconnect.de. [2003:d0:6f35:5400:ebbc:e7b1:bde:1433])
        by smtp.gmail.com with ESMTPSA id di27sm1138276edb.21.2021.02.04.12.34.33
        for <539723@bugs.debian.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 12:34:34 -0800 (PST)
To:     539723@bugs.debian.org
From:   Bastian Germann <bastiangermann@fishpost.de>
Message-ID: <730f3efc-253c-4eea-f4bc-9979e9e6b3c3@fishpost.de>
Date:   Thu, 4 Feb 2021 21:34:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20090803093257.29785.85748.reportbug@jondo.cante.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Tags: upstream wontfix
Control: notfound -1 xfsprogs/3.0.2

On Mon, 03 Aug 2009 12:32:57 +0300 Jari Aalto <jari.aalto@cante.net> wrote:
> Please add support for GNU --long options that are readable
> alternatives. An Example:
> 
> 	mkfs.xfs --force /dev/sda7
> 		 =======
> 

It is not common for mkfs.* programs to have --long options.
So most probably this will not be implemented.
