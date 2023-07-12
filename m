Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E59AEB64D9
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 09:27:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbjGLJ1I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 05:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbjGLJ1H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 05:27:07 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45903FB
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 02:27:06 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id af79cd13be357-7672073e7b9so500641385a.0
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 02:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689154025; x=1691746025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dJqzjnaNxujwoIoAz2odfZ/u/uZoLrV+J5MUVOfc13s=;
        b=OESnhggm17Ol21MQZKxclmr58z0xJui16YcjIggjBVcXmGYCsB850o96Zw4N9Hfir3
         XZiqcmWuPp6FH4b2z6Qaz2bEsyj/U6ZcMllLJZ10bB2mXdQmPTEowjxNapaojz8ublJ7
         ZYMghX4AnHdZMJtAYPMbLx/b1aBNSJrViV6bu6wiqg0rMRPkig8j0M7d7Ndfa0mL6XTQ
         EGQWlxGDdS24mPkwJ7m6c9XsXQTlLDD1nKBwS5yw2pKHETmiXEpIVDBO1a1KSSycmL4K
         5zQiY+gwsTpNIA3Uky1kQE8QFiiZ4LEX2fQ+PpOlzAxmqxczIgom6X39CJ34hgZAk1mA
         z8YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689154025; x=1691746025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dJqzjnaNxujwoIoAz2odfZ/u/uZoLrV+J5MUVOfc13s=;
        b=HqfiUFYQ3coxFfREMFVEHrYOB0exfJJlgvOxs6Uc5CqR9lfo62vj+8EKtr+biBNWR0
         anRnyKqT7d47En20JQ8t/m3ZqlKMwjrihL8koifymSMKZszI7vCetaXyt+cXa+5wh+4o
         pKBDv5TjhC13YZj5+EIVo6TbPXI5aWaepW3o+TMx5QqCBLJlF7Q7PIBsyJ8Fc2I23Ksh
         gnch3VNhTMNV6AZpJ53ncvGD5gD/Ay5CA/kr/40YhJ6mhqS+CXGMXpWNpBnK5iGxjai8
         R9S5dOrzwT+E09dueGM0EHxpHJTila27Z/iMRWU/3IjTkkgC8D9X4RMxnZGTk2RC+/RO
         1V7A==
X-Gm-Message-State: ABy/qLbmaQsjYlaJDsWEaYroF0qL9UlhAd5jVKgDwvkeiLeUCgaOVeJG
        qBdM4cCX6K97K8xDU7fryrFZPlsih3ZWbB62Lmo=
X-Google-Smtp-Source: APBJJlFjP7brRsv+SH1IcT0Shn85X4dn66hPdEPuFi/rXaV4Pyyabm0qnSN0nbYm87+x/BbxrplMtRV6Vn235xptwC4=
X-Received: by 2002:a05:620a:24d3:b0:765:a828:7d02 with SMTP id
 m19-20020a05620a24d300b00765a8287d02mr20131574qkn.24.1689154025340; Wed, 12
 Jul 2023 02:27:05 -0700 (PDT)
MIME-Version: 1.0
References: <20230710215354.GA679018@onthe.net.au> <20230711001331.GA683098@onthe.net.au>
 <20230711015716.GA687252@onthe.net.au> <ZKzIE6m+iCEd+ZWk@dread.disaster.area>
 <20230711070530.GA761114@onthe.net.au> <ZK3V1wQ6jQCxtTZJ@dread.disaster.area>
 <20230712011356.GB886834@onthe.net.au> <ZK4E/gGuaBu+qvKL@dread.disaster.area> <20230712021713.GA902741@onthe.net.au>
In-Reply-To: <20230712021713.GA902741@onthe.net.au>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 12 Jul 2023 12:26:54 +0300
Message-ID: <CAOQ4uxi1h323CPy2J2=MA5H630Uv6FCfxhnrJ7GSzD5NzXuzfg@mail.gmail.com>
Subject: Re: Subject: v5.15 backport - 5e672cd69f0a xfs: non-blocking inodegc pushes
To:     Chris Dunlop <chris@onthe.net.au>
Cc:     Leah Rumancik <lrumancik@google.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        Leah Rumancik <leah.rumancik@gmail.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 12, 2023 at 5:37=E2=80=AFAM Chris Dunlop <chris@onthe.net.au> w=
rote:
>
> Request for backport to v5.15:
>
> 5e672cd69f0a xfs: non-blocking inodegc pushes

This is not the subject of above commit, it was the
subject of the cover letter:
https://www.spinics.net/lists/linux-xfs/msg61813.html

containing the following upstream commits:
7cf2b0f9611b xfs: bound maximum wait time for inodegc work
5e672cd69f0a xfs: introduce xfs_inodegc_push()

>
> Reference:
>
> https://lore.kernel.org/all/ZK4E%2FgGuaBu+qvKL@dread.disaster.area/
> ---------------------------------------------------------------------
> From: Dave Chinner <david@fromorbit.com>
> To: Chris Dunlop <chris@onthe.net.au>
> Cc: linux-xfs@vger.kernel.org
> Subject: Re: rm hanging, v6.1.35
>
> On Wed, Jul 12, 2023 at 11:13:56AM +1000, Chris Dunlop wrote:
> >> On Tue, Jul 11, 2023 at 05:05:30PM +1000, Chris Dunlop wrote:
> >>> In particular, could "5e672cd69f0a xfs: non-blocking inodegc pushes"
> >>> cause a significantly greater write load on the cache?
> ...
> > Or could / should it be considered for an official backport?  Looks lik=
e it
> > applies cleanly to current v5.15.120.
>
> I thought that had already been done - there's supposed to be
> someone taking care of 5.15 LTS backports for XFS....

Leah has already queued these two patches for 5.15 backport,
but she is now on sick leave, so that was not done yet.

We did however, identify a few more inodegc fixes from 6.4,
which also fix a bug in one of the two commits above:

03e0add80f4c xfs: explicitly specify cpu when forcing inodegc delayed
work to run immediately
   Fixes: 7cf2b0f9611b ("xfs: bound maximum wait time for inodegc work")
b37c4c8339cd xfs: check that per-cpu inodegc workers actually run on that c=
pu
2254a7396a0c xfs: fix xfs_inodegc_stop racing with mod_delayed_work
   Fixes: 6191cf3ad59f ("xfs: flush inodegc workqueue tasks before cancel")

6191cf3ad59f ("xfs: flush inodegc workqueue tasks before cancel") has alrea=
dy
been applied to 5.15.y.

stable tree rules require that the above fixes from 6.4 be applied to 6.1.y
before 5.15.y, so I have already tested them and they are ready to be poste=
d.
I wanted to wait a bit after the 6.4.0 release to make sure that we did not=
 pull
the blanket too much to the other side, because as the reports from Chris
demonstrate, the inodegc fixes had some unexpected outcomes.

Anyway, it is 6.4.3 already and I haven't seen any shouts on the list,
plus the 6.4 fixes look pretty safe, so I guess this is a good time for me
to post the 6.1.y backports.

w.r.t testing and posting the 5.15.y backports, we currently have a problem=
.
Chandan said that he will not have time to fill in for Leah and I don't hav=
e
a baseline established for 5.15 and am going on vacation next week anyway.

So either Chandan can make an exception for this inodegc series, or it will
have to wait for Leah to be back.

Thanks,
Amir.
