Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB093C47096
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 06:32:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86FE6613F1
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 06:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhFCGeL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 02:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbhFCGeL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jun 2021 02:34:11 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE8CC06174A;
        Wed,  2 Jun 2021 23:32:27 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id b25so5174747iot.5;
        Wed, 02 Jun 2021 23:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PmhbRvWXjPoary3INhTONOUonfSMmWl8kiQKw20m8pY=;
        b=nEKiaHd/GDKw63P/jx1qn1impUsfWyAQ1DARvdV4hcKHOC84+a1SYTVRndafhq1aog
         jFHlWSYkEUsJ6+oU/ibhJgm7N8Wnfi4AZ/atk32i1MTYdhaDLZCx2LnOsgvKHoZ3IIC+
         Fg6+3cDhcpFPGXxMZp0yxUWolJ2hOUpT9IZK1Sn6Nk0upWP6xiWupAvcYCd+kd2s3U44
         loYMBT8CSt5XmlhFb/ens7JY/fLegsTloc+S1rnc6TnWyLWMA+JgLeMnUTJln8o7Gxt+
         hp6E2S96YhceKisMHawSuijKvbH/zbmqZWeE9d+lPjsvA1dcThIaQeZAPl7ofNcUaWEK
         AoGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PmhbRvWXjPoary3INhTONOUonfSMmWl8kiQKw20m8pY=;
        b=XrhVMYyndpfRZgvqP12XVgn/MXyyfmKosckjjLqeTDqOmfnhVdf/ItB3nRxDIYS1Lr
         4kN+GebnGaU4T0DzJTrHXMiUIWGz38muK024CgU9dzeL4rHCEFiqL4q3yMtV+AiMiqyC
         heLEGgtgvqKIAYOSm91/skHTmwJbp5lSebLCUkrS0H3bZbl/ZoGSgqOB/BszcKa+aO//
         W9HY4hC6B+ND7eHBKB/hJSurWMSz+B+Se8WHt3Qnq/eTnL3+Nx36YjZ2Iozivhv0q2KX
         SaMmn+4yOOI8dplexNPVEBZgHxQjeMSvgQ5G5mEPk9xH7YVL2yDk6Y7KIRD57Otrz3a4
         +Qag==
X-Gm-Message-State: AOAM530JwLdWXAA2EEKA7jUD/X9IkTDet9EHamg1LtCjbUNpoJ4Z3RGJ
        cNodlHY4goRefQBlqyFdPcXGF8QOMiVfL0okXU1bEroa
X-Google-Smtp-Source: ABdhPJzEsWFvxknDPwfgUUCGRAmCxjghLwbpoRZnH3XiTZNT9oA28aWNwmMkXWehCHVyOwGehARsbml/ExcOZPrZSVs=
X-Received: by 2002:a5d:814d:: with SMTP id f13mr27696446ioo.203.1622701947038;
 Wed, 02 Jun 2021 23:32:27 -0700 (PDT)
MIME-Version: 1.0
References: <162199360248.3744214.17042613373014687643.stgit@locust>
In-Reply-To: <162199360248.3744214.17042613373014687643.stgit@locust>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 3 Jun 2021 09:32:16 +0300
Message-ID: <CAOQ4uxioTzuo5B3kEKX_GY_aDyps1WXHH7OsOw6N0sNyf31+7w@mail.gmail.com>
Subject: Re: [PATCHSET RFC 00/10] fstests: move test group lists into test files
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 26, 2021 at 5:50 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> Hi all,
>
> Test group files (e.g. tests/generic/group) are a pain to keep up.
> Every week I rebase on Eryu's latest upstream, and every week I have to
> slog through dozens of trivial merge conflicts because of the
> groupfiles.  Moving tests is annoying because we have to maintain all
> this code to move the group associations from one /group file to
> another.
>
> It doesn't need to be this way -- we could move each test's group
> information into the test itself, and automatically generate the group
> files as part of the make process.  This series does exactly that.
>

This looks very nice :)

I do have one concern.
If the auto-generated group files keep the same path as the existing
source controlled group files, checkout of pre/post this change is
going to be challenging for developers running make in the source
directory.

Also .gitignore entries are needed for the auto-generated group files.

I wonder if it wouldn't be easier for everyone if the auto-generated
groups had a different name.

Thanks,
Amir.
