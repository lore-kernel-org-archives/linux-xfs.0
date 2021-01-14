Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10629C43381
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 10:40:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD5B423A3B
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 10:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728921AbhANKkT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 05:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728975AbhANKj4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jan 2021 05:39:56 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F9FC061574
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jan 2021 02:39:05 -0800 (PST)
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1l001v-0002S0-0e; Thu, 14 Jan 2021 10:39:03 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#976683: RFS: xfsprogs/5.10.0-0.1 [NMU] -- Utilities for managing the XFS filesystem
Reply-To: nathans@redhat.com, 976683@bugs.debian.org
X-Loop: owner@bugs.debian.org
X-Debian-PR-Message: followup 976683
X-Debian-PR-Package: src:xfsprogs
X-Debian-PR-Keywords: 
References: <8b769e38-3ffd-5e8c-7a57-d451daa30e67@fishpost.de> <fff77770-2496-0c1e-3849-bc1acc492725@fishpost.de> <8b769e38-3ffd-5e8c-7a57-d451daa30e67@fishpost.de>
X-Debian-PR-Source: xfsprogs
Received: via spool by 976683-submit@bugs.debian.org id=B976683.16106206517955
          (code B ref 976683); Thu, 14 Jan 2021 10:39:02 +0000
Received: (at 976683) by bugs.debian.org; 14 Jan 2021 10:37:31 +0000
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37563)
        by buxtehude.debian.org with esmtp (Exim 4.92)
        (envelope-from <nathans@redhat.com>)
        id 1l000Q-000245-Hh
        for 976683@bugs.debian.org; Thu, 14 Jan 2021 10:37:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610620646;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=lrl3snCKTPFhAsPMUvZGD9SHnOdpH2NPG0sUZtRJmdM=;
        b=Y/kMqqToydMdFKBS3J2dACEjNKhqM8O6evJzytsCx1UQU/GT+BcMaPC4KNeeshPTl31xqT
        +xgl3CIqANpneENZSzEp+4wjtK9KCWf3aGgchEBX62O1Gh6qPHhCPbzSd/HWdP0rh9kp2t
        /LaGk5C+MwiMgo3XtmtxnGVR+Hvpd/U=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-AKU7D-7HPySVcfwIyHVsyg-1; Thu, 14 Jan 2021 05:37:24 -0500
X-MC-Unique: AKU7D-7HPySVcfwIyHVsyg-1
Received: by mail-ed1-f70.google.com with SMTP id y19so2198678edw.16
        for <976683@bugs.debian.org>; Thu, 14 Jan 2021 02:37:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to;
        bh=lrl3snCKTPFhAsPMUvZGD9SHnOdpH2NPG0sUZtRJmdM=;
        b=LyJsbMnehd1vLxIDWRhyt6v/WtLXZUkJ/JQezf1O27eIZzHDMWWPEBssQ8+U6Xq0zY
         8HsnljZsHPKRb2GVJS1vIXuN62n+6y31jFprBLmbFzxrk64cCjzpXLbdVAuQz+2nYJi9
         f9M8QRpN1OiM3EV5m50gfbySvUKxF4/FwFCZ5ZdZKcMe3LHMmzBtETLGgAyzDLgUzpuV
         nuEML4McvxiH2yb5enM5fCS+gbcL5AcP0iFz8ljv5PdiHn7JO72qaAmLttvFWyWwKdDI
         ePgjqXEG02boNKOuMHYt7JoHBUwN8qTYci/6TuJFyrR1vuN6NXvlAahB+9k3y6KoB2gz
         6BJA==
X-Gm-Message-State: AOAM532zKhAabl4WePIWvggRbHJXfwHNAwrz+N8O1QjWZSLlqxrqxCZs
        0Dubg4tnX6R8QIeQfrdv5fCoodGpYC1DQROlYz10/XpwPq8eQtYJl1z4SvzdIXUz2HB3STxKNm2
        cE0cjwY1vsUwLWieWOG8b0V8JvDvdI8D4
X-Received: by 2002:a17:906:3b82:: with SMTP id u2mr4623504ejf.66.1610620642870;
        Thu, 14 Jan 2021 02:37:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz1yBB7H9H6owqbJn+4nR7g701xAFAg3nCygaFAo6ORdC4wqHzw9P/wuVxw3YN/e1gQwarLZSjtgqxNqJZrP/A=
X-Received: by 2002:a17:906:3b82:: with SMTP id u2mr4623497ejf.66.1610620642681;
 Thu, 14 Jan 2021 02:37:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <fff77770-2496-0c1e-3849-bc1acc492725@fishpost.de>
From:   Nathan Scott <nathans@redhat.com>
Date:   Thu, 14 Jan 2021 21:37:11 +1100
Message-ID: <CAFMei7NNM3FLngqn9rhOTk9a_ebspBmfg9a==3ZkxKp-hhAOFw@mail.gmail.com>
To:     Bastian Germann <bastiangermann@fishpost.de>,
        976683@bugs.debian.org
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nathans@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Bastian,

On Sun, Jan 10, 2021 at 8:04 AM Bastian Germann
<bastiangermann@fishpost.de> wrote:
> [...]
>
> Changes since the last upload:
>
>   xfsprogs (5.10.0-0.1) unstable; urgency=medium

Please get your changes merged in the upstream xfsprogs git repo (via linux-xfs
mailing list patches), and add yourself to the Uploaders line.

Thanks.

--
Nathan
