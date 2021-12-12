Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 786B9C433F5
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Dec 2021 14:21:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbhLLOVb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Dec 2021 09:21:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbhLLOV3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Dec 2021 09:21:29 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5D0C061714
        for <linux-xfs@vger.kernel.org>; Sun, 12 Dec 2021 06:21:29 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id q74so32433444ybq.11
        for <linux-xfs@vger.kernel.org>; Sun, 12 Dec 2021 06:21:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1fQiWUkIyzToTBAbQ/ekyM+3RjbLcaO35r6gfICY1yc=;
        b=DLc7i+UY5vFijtAkoB5tVg8jWBcipSljIIEy7Klc/XNZGeU2/x+z2D/AHGJE/FXT8y
         0REzSTfW45wlZc4jNlKW1KdMT6ZM6Rfl1KK4zXVTnD+OZgLit51+lRTzNoi09GgIcAac
         uZHRf0Q8Hm/mhYOHu8/sNnkfzY4kQ1Nz23DkflOnLV/9EUTfU0cKw4MWM7SZQceboZJ7
         cKDux3d32vIM7krjXJ1a8oTea73XjyanWuATlj+NHq7ir+li1FXADNsyJsTESiY2smLE
         lj8hzUZOONv5YP78jscCumacZC9IftOga6pMJN6U8lO4k/J4gnX7lQR3Y7kX8+a9MVzb
         ZvQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1fQiWUkIyzToTBAbQ/ekyM+3RjbLcaO35r6gfICY1yc=;
        b=vg7My7/b/7A/mQ15qQZ5JQR3cMbazfXC/Hpq4HSa0sj5Npa4Ui/zFoOt0rAcBcRwEP
         9jZBXXm04bmTTUY5LAFS7hnMQkCyPr5ZBq7OD6ERcPoRfdR1O1vO+vIKXbp8urFnq37e
         z8I+UYdRcRfIYF9MbOEgguAdMakD4X7WWlqqq1HfY5Lt9vf7Y2Gks0UPhgeLv9o6nvQk
         FkySWlQHLMU9AlFZtXjhhZvHtM3O17DCju7gg3u5e/qJG5yeRg4aAVFqsZzGoUeEJEWN
         1p/90N6fe+H3BeS/9j6uzjc57Gm98LYo4+JGEBxYedtDYb4ZVrdWeqsZ+pkJR3sCj068
         nhCg==
X-Gm-Message-State: AOAM53154jbi/wi5eBMP3gQSdnFhbnxPeSMTWEh7g9KQxsHdksvqttDR
        lxtXjWQ0hlt5wKHlrrRr0wcWMX1qmzkIlOFT0uyYjQ==
X-Google-Smtp-Source: ABdhPJysgraFZdgFILz22CS3472BuSjp8L5D6jfbLREYcXmbsFA8ZMB7PGNzSNQo5aP1iNOLGKdNe+Tkte8LtnIf6zk=
X-Received: by 2002:a25:2601:: with SMTP id m1mr3065763ybm.695.1639318888777;
 Sun, 12 Dec 2021 06:21:28 -0800 (PST)
MIME-Version: 1.0
References: <CAJCQCtQdXZEXC+4iDgG9h5ETmytfaU1+mzAQ+sA9TfQ1qo3Y_w@mail.gmail.com>
 <054e4e59-a585-5375-e80b-5db3ade2f633@gmail.com>
In-Reply-To: <054e4e59-a585-5375-e80b-5db3ade2f633@gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sun, 12 Dec 2021 09:21:12 -0500
Message-ID: <CAJCQCtQ=-XC-6sLnZgi23hkA7L2Pn7=pYf-Mqv43bm6fyxbN0g@mail.gmail.com>
Subject: Re: VMs getting into stuck states since kernel ~5.13
To:     =?UTF-8?Q?Arkadiusz_Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        xfs list <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 9, 2021 at 9:56 AM Arkadiusz Mi=C5=9Bkiewicz
<a.miskiewicz@gmail.com> wrote:
>
> W dniu 08.12.2021 o 19:54, Chris Murphy pisze:
> > Hi,
> >
> > I'm trying to help progress a kernel regression hitting Fedora
> > infrastructure in which dozens of VMs run concurrently to execute QA
> > testing. The problem doesn't happen immediately, but all the VM's get
> > stuck and then any new process also gets stuck, so extracting
> > information from the system has been difficult and there's not a lot
> > to go on, but this is what I've got so far.
>
> Does qemu there have this fix?
>
> https://github.com/qemu/qemu/commit/cc071629539dc1f303175a7e2d4ab854c0a8b=
20f
>
> block: introduce max_hw_iov for use in scsi-generic

OK this worker is running a version of qemu with this fix backported
now, and the problem still happens.

I'll try to get answers to Dave's other questions (I don't have direct
access to this system, so there's a suboptimal relay happening in the
conversation).


--=20
Chris Murphy
