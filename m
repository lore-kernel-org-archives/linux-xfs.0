Return-Path: <SRS0=xS0A=54=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4476C352BE
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Apr 2020 22:28:54 +0000 (UTC)
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7454F206C3
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Apr 2020 22:28:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=juliacomputing-com.20150623.gappssmtp.com header.i=@juliacomputing-com.20150623.gappssmtp.com header.b="tAqXHlP8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7454F206C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=juliacomputing.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-xfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbgDLW2x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Apr 2020 18:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:57744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgDLW2w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Apr 2020 18:28:52 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C591AC014A4B
        for <linux-xfs@vger.kernel.org>; Sun, 12 Apr 2020 15:28:51 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id e4so4732995ils.4
        for <linux-xfs@vger.kernel.org>; Sun, 12 Apr 2020 15:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=juliacomputing-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ANGfUKyG+6xWky2jJ2nWMKG+M8IIxgEacG/h0ycqR20=;
        b=tAqXHlP8pnC0Fae5HqLveAPHChvu5fDrBR9aCpdJ/+VGWLe239sL5EQQWbqaz3R9zk
         EAQUa5NP5nmgrY74n41PftFvtCCNCkmDthGZgO1ECVJSvQ4IMF53VSupjwSpg+7RuiI2
         v8IH811tUAia95Hhy4SCvG+4vNYPYkm/oQwKOCJSYOIjRu3W/kSiUZHWJk1lZ+sCtpCN
         sz3mK9n7qAcYjYqEBtPNGS5pNjUaJMtI1sYKypSgAKOTUQlwM5XiVkmGcy1PN8/Nb7x4
         5Dp2zxa0TXQ+m0aDA5A0d4GXIcPgOuuLePU4s7tZZkslKAfNetsNFpjzQdzBZpgG9Dy/
         XODw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ANGfUKyG+6xWky2jJ2nWMKG+M8IIxgEacG/h0ycqR20=;
        b=sdVINFnCRjurrIszENg1IueW2SQdQMpGiZokN6kKBxYSM3OZJkRDTf2b3XvWyxUnn0
         BcvZPPMfOZo/pXrZP6PkmjSyQgVUPYPOrhF+52SRDmTXaTOF3FabaIBX0/oJUZrdaFzX
         dBs4g00XLcOHn+t9Eenzv7VyawI2WHpswtc0g698imSc0uME2niblx9sqXE2as0tLTJJ
         Am1FOFDEYci1mQDjRGX90KVPXgF7x3fImnx8mcToWNitru3CW/KWYfOWTXQRo9aRmmXk
         7AlmYv5+eeD/4WHGPKO95VpwUnbHtvMAEfID6kypuSjrt13DoIe3EeFg2Mxy9K97Gwhn
         3C8w==
X-Gm-Message-State: AGi0PuaPtBlAU5As4ntjqx7K8b29wjNTz+W50Wi67FveDB6aKffrxNE1
        EZUHACvD2LSlfe3C3byH7JDJQGjR+lveqvecQ0YewQ==
X-Google-Smtp-Source: APiQypJO2Sswe5+NMVXMBxFMyLnpwoxty/zztpPW7J2prcZwXcKcdiwPWUFR1BvBQmKAE2/hAJpBzCD4M7x9p/ukihc=
X-Received: by 2002:a92:250e:: with SMTP id l14mr14538847ill.201.1586730530779;
 Sun, 12 Apr 2020 15:28:50 -0700 (PDT)
MIME-Version: 1.0
References: <CABV8kRw_jGxPqWc68Bj-uP_hSrKO0MmShOmtuzGQA2W3WHyCrg@mail.gmail.com>
 <CAOQ4uxhPKR34cXvWfF49z8mTGJm+oP2ibfohsXNdY7tXaOi4RA@mail.gmail.com>
In-Reply-To: <CAOQ4uxhPKR34cXvWfF49z8mTGJm+oP2ibfohsXNdY7tXaOi4RA@mail.gmail.com>
From:   Keno Fischer <keno@juliacomputing.com>
Date:   Sun, 12 Apr 2020 18:28:13 -0400
Message-ID: <CABV8kRxVA0j2qLkyWx+vULh2DxK2Ef4nPk-zXCikN8XmdBOFgQ@mail.gmail.com>
Subject: Re: Same mountpoint restriction in FICLONE ioctls
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Olga Kornievskaia <kolga@netapp.com>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> You did not specify your use case.

My use case is recording (https://rr-project.org/) executions
of containers (which often make heavy use of bind mounts on
the same file system, thus me running into this restriction).
In essence, at relevant read or mmap operations,
rr needs to checkpoint the file that was opened,
in case it later gets deleted or modified.
It always tries to FICLONE the file first,
before deciding heuristically whether to
instead create a copy (if it decides there is a low
likelihood the file will get changed - e.g. because
it's a system file - it may decide to take the chance and
not copy it at the risk of creating a broken recording).
That's often a decent trade-off, but of course it's not
100% perfect.

> The question is: do you *really* need cross mount clone?
> Can you use copy_file_range() instead?

Good question. copy_file_range doesn't quite work
for that initial clone, because we do want it to fail if
cloning doesn't work (so that we can apply the
heuristics). However, you make a good point that
the copy fallback should probably use copy_file_range.
At least that way, if it does decide to copy, the
performance will be better.

It would still be nice for FICLONE to ease this restriction,
since it reduces the chance of the heuristics getting
it wrong and preventing the copy, even if such
a copy would have been cheap.

> Across which filesystems mounts are you trying to clone?

This functionality was written with btrfs in mind, so that's
what I was testing with. The mounts themselves are just
different bindmounts into the same filesystem.

Keno
