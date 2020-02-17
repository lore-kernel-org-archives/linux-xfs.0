Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2073C3B185
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 10:56:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DC4120725
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 10:56:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="auppTt5x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbgBQK4N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 05:56:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27747 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727503AbgBQK4N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 05:56:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581936971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CGOF231jdjZpZHQTnYnSOxFW0m0idzht9M9nHcGuwiI=;
        b=auppTt5xCbO3aPDoy++jcdLvut5bIKwIuz1wdX+Iw9LAdNJNFHPkzk19MavJnpxkllU+r0
        DdeIO1/4FJd387l0p54j1YlL6LyYG60M8t79nuonhUMSp33BH0qbBhzmxoDHB8WoueSe5f
        Q5kLgxFLprQzMQ5a6wbWAePVsnwUp7g=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-C-n_xMtmN82jowND7RhXWA-1; Mon, 17 Feb 2020 05:56:07 -0500
X-MC-Unique: C-n_xMtmN82jowND7RhXWA-1
Received: by mail-vk1-f197.google.com with SMTP id z24so6648949vkn.0
        for <linux-xfs@vger.kernel.org>; Mon, 17 Feb 2020 02:56:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CGOF231jdjZpZHQTnYnSOxFW0m0idzht9M9nHcGuwiI=;
        b=CNXgHCd7ATG6SN7Gtrmry8VFVlrsK4wGW6wUAeFOm5ou8wsIyd0iO/WkWhkpvcJ3IT
         DUVFyaDUft9WH68w3pyfUpvfv5Ledet6OhpTzyp80IgbuoNtawE7SviOkyywk79fJf2c
         hcYTjwl7EJDJ1hJYmr2NKa348GZ1nnJFP1O59c4oyPgVG69DcsZt79f0Pf95l55gMo0Y
         UyykMGGNIUSitAvHYfI7YJEY0zI+XblApD6+Ig93rhttfSD2T95GlpuugozowpRYnEJL
         ej5Hi4csUaobD7SX1I+Yi8HcPTbZr81X8zQyL56YrGHcA8Cow6eaK4PBpJQrlgw/zKPH
         eWyw==
X-Gm-Message-State: APjAAAWsRVAdvy5XekMzNBXqwR1KfQ9kDQXsrEm2iXuurzsmh7zxw6xE
        Xsd2ynn5IAQYmYbAKvpzls6OGWsxOREd8fHMGMatOGuYLKE3AsVEBpClqDzjgYQk0z3m3QiCrM0
        Vr27NukR0SBMAvvS5MfrZOCv/1h9q0RFHDPjn
X-Received: by 2002:a67:ff17:: with SMTP id v23mr7066326vsp.121.1581936966663;
        Mon, 17 Feb 2020 02:56:06 -0800 (PST)
X-Google-Smtp-Source: APXvYqyz+JsoUFsa1XiaF7mKDvbRqwkkylKdRq3JCLKEGTHs8VNXEoyNGbR/JnPjPxTkaqRY+8452dsmR80Jd57jtXI=
X-Received: by 2002:a67:ff17:: with SMTP id v23mr7066319vsp.121.1581936966411;
 Mon, 17 Feb 2020 02:56:06 -0800 (PST)
MIME-Version: 1.0
References: <20200214185942.1147742-1-preichl@redhat.com> <DM6PR04MB57544CDC68D9DFAB48B61F1386140@DM6PR04MB5754.namprd04.prod.outlook.com>
In-Reply-To: <DM6PR04MB57544CDC68D9DFAB48B61F1386140@DM6PR04MB5754.namprd04.prod.outlook.com>
From:   Pavel Reichl <preichl@redhat.com>
Date:   Mon, 17 Feb 2020 11:55:55 +0100
Message-ID: <CAJc7PzWrcXpcraAMEfMi6idTeYa9o009tZLOSzp3A6sC-km3DA@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] xfs: Refactor xfs_isilocked()
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Feb 15, 2020 at 2:38 AM Chaitanya Kulkarni
<Chaitanya.Kulkarni@wdc.com> wrote:
>
> Since it has more than one patch and version 5,
> I couldn't find the cover-letter and a change log for this
> series, is there a particular reason why it is not present or I
> missed it?
>
> On 02/14/2020 11:00 AM, Pavel Reichl wrote:
> > Refactor xfs_isilocked() to use newly introduced __xfs_rwsem_islocked().
> > __xfs_rwsem_islocked() is a helper function which encapsulates checking
> > state of rw_semaphores hold by inode.
> >
> >
>
>

Hi Chaitanya,

sorry for the absence of the changelog I forgot to add it - that was
not on purpose.

To summarize the changes: I moved the asserts from the first patch to
the third as suggested by Eric and changed the commit messages as
suggested by Dave.

Regarding the missing cover-letter it was same since version one and I
was not sure I should resend it with every new version, should I?

 Thanks you for your comments.

Best regards

Pavel Reichl

