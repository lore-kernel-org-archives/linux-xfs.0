Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB02C43461
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 08:48:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15F0821974
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 08:48:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GYBYduF9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgIOIss (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Sep 2020 04:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726123AbgIOIsq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Sep 2020 04:48:46 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59568C06174A;
        Tue, 15 Sep 2020 01:48:46 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id u6so3167221iow.9;
        Tue, 15 Sep 2020 01:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GfhLVgRMJ2Uaz4wqw/1QGz+EqR3zSee7S6K5qC/BaWQ=;
        b=GYBYduF9P1Zn2HNNWUlTEjmYqplrFqJ/OQwQi72bnrjWMdwd/bYMjBfRLihktwLZFB
         VbKX4yWZBOeisJUURA8UyklhUslOrBC1bpzQu1CM8f/3d2Q5TL76Wn/4JNArcnt6T6qN
         FNQyjJOhFFD7+dmpYqQhAhWied0KNyKx19P/rvIm2YyohNZPbyoL5xedQiXmDrQ1S5Vq
         tKfpo9vBeEVLnmLtFDMLQ4+TLEHHGCcoE2Qq8YOp2/kccwQK96f9qoQg9zJ6ThY65nOQ
         27F16YcVzv6FOS44VZwaOGUle/xxU/wn23ijIMAsKAkyBLib9HqYovPjIt5h0kqqRC1v
         6pvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GfhLVgRMJ2Uaz4wqw/1QGz+EqR3zSee7S6K5qC/BaWQ=;
        b=r4ZFBVLWhJRfgn0yPbt1Aw/eDT6vDJJqIF8Zx9eaXiSZzi+KOMTf2/jyXAVy03Fxk6
         OcLoX23/jI5oH6rQNv42SpLU5MVoWyWjTT5FHhM4+qt069x7h5Sr0QRR/GDK7jEZRU0C
         DB3d8cPhawPF7PwowbO7SX+hB2uCBfQfi3fhyqPCz7jpnk+7vQzWLW8l6LdwGAGzhfl2
         /lknx+nBvYhaqnQRdADjPD/jCZr2MiwZ/O99Yeol+Fjx1abJmn3US2F+roR5GKfiAc/U
         qnIFfEwOW5Curm6bTIbKMXTljqGCtSQzrFtYhy5fZYJgRVPISmFi1IeqYBLUjQdDlfFu
         aTYw==
X-Gm-Message-State: AOAM533W25deyoh19FB77xciMOIg8HPXiK89EheWG0A1IeutOlqj4krf
        lJfCOu3j8i1d4MII4Bm3AznGaf2Ez636ckQ2c7lgCKVMIW8=
X-Google-Smtp-Source: ABdhPJzispuPkFF2WshKu6dqY4Uwyx9SyGpi20z5JljBv2k0TRb3GQ6wZHBI9/MLC4iiGAVvUxebtoa0hIc63azp3qY=
X-Received: by 2002:a02:734f:: with SMTP id a15mr17341979jae.120.1600159725747;
 Tue, 15 Sep 2020 01:48:45 -0700 (PDT)
MIME-Version: 1.0
References: <160013417420.2923511.6825722200699287884.stgit@magnolia> <160013424591.2923511.7236445306723372509.stgit@magnolia>
In-Reply-To: <160013424591.2923511.7236445306723372509.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 15 Sep 2020 11:48:34 +0300
Message-ID: <CAOQ4uxiyUWS+PzUsbz5V4ebgtpcbhr4E5cSFkBE3eeT7nhiY0A@mail.gmail.com>
Subject: Re: [PATCH 11/24] overlay/{069,071}: fix undefined variables
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 15, 2020 at 4:44 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Change OVL_BASE_TEST_MNT -> OVL_BASE_TEST_DIR, since the former is not
> actually defined anywhere.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Oops...
Thanks for fixing this.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
