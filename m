Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D33EDC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Apr 2022 13:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354101AbiDONpS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Apr 2022 09:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354129AbiDONpQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Apr 2022 09:45:16 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232BEBA339;
        Fri, 15 Apr 2022 06:42:46 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id y19so6500166qvk.5;
        Fri, 15 Apr 2022 06:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=R3T86T3mCsBpnlO1XOLs16Pr1tJsd/No9WFwt9RP4yg=;
        b=X5/Q+yG0eSVrgSVa/dmxW8h9EEVkHIKGfSywOT9oRB2ph0W0kt3lajQPp957ZEvDmO
         dxQDAgGvEDD0+cwjrNz+LchIr9R4EN+HKWZLayUzaKu3jhjKa0+o9XYdckbTAnLEmqmV
         r+mupjQkUiACem3YTQzgMG6tEukwPHtVAoUZCY+QvaM0qoMtVEDd5B/LJXNu+K+++av0
         OFVLyRYJ3nahi9NLnt+IB/kALFT+s017CCh777OZm5xKB4qjIP9FN2pCKdPmubdtF+de
         2MH6QJ95uTHvzD8Ozco+WNz7VJCGGrvVRNWo3V4MC2dCei45oYg9RTillz94FFifUdt9
         31nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=R3T86T3mCsBpnlO1XOLs16Pr1tJsd/No9WFwt9RP4yg=;
        b=OWLd0f1A3nwlrcHoTSebUqqNBoGB5ep8EMhSg3w8kUYs0DvsXE6n04JaGZU667nUO2
         JVtGHkugFNv3dMRD0wMpjAQkduEwURruC77CwEpcnmQWkpwzt/7xJXIA5LE0pVIccCsV
         raMQhXvkByVUVlFntYWfEF7jZkOn+AZMJFwAFOn/BD40lHtuUMgXWdNti2mbBsO7LqSl
         6uokcAxhqH5u8Qc71adxNQDmz8Look52RIy+7DqgKfrSGIflg4VCaHHzY8EuOim/d3oh
         CE3ZwdMRRC6sYnYEayS/RlITRu5pVz1NzjvdcoJeteckvJnBeE3DQOawX7HHxHcMGKi7
         F3mw==
X-Gm-Message-State: AOAM531k60UZhQso/gotivx0JtheA3NrvISuvqYiP1pkYrYSKPg5jyQW
        7+9x//h/i9p289hrW78t7QKbk7B+OcXTXkF1uQk=
X-Google-Smtp-Source: ABdhPJxQqaqiwphhhhCgWuHuODg9rdk6PU9vi+qIMlSU2vMdFy3aO443UJ7xrZtPVvllkVK+BxJU2O/SRuvKINQfqlk=
X-Received: by 2002:ad4:4ee6:0:b0:446:3ad0:e26b with SMTP id
 dv6-20020ad44ee6000000b004463ad0e26bmr1521774qvb.12.1650030165152; Fri, 15
 Apr 2022 06:42:45 -0700 (PDT)
MIME-Version: 1.0
References: <164971767143.169983.12905331894414458027.stgit@magnolia>
 <164971768254.169983.13280225265874038241.stgit@magnolia> <20220412115205.d6jjudlkxs72vezd@zlang-mailbox>
 <CAOQ4uxiDW6=qgWtH8uHkOmAyZBR7vfgwgt-DA_Rn0QVihQZQLw@mail.gmail.com>
 <20220413154401.vun2usvgwlfers2r@zlang-mailbox> <20220414155007.GC17014@magnolia>
 <20220414191017.jmv7jmwwhfy2n75z@zlang-mailbox>
In-Reply-To: <20220414191017.jmv7jmwwhfy2n75z@zlang-mailbox>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 15 Apr 2022 16:42:33 +0300
Message-ID: <CAOQ4uxgSmxaOHCj1RdCOX2p1Zmu5enkc4f_fkOLC_muPiMk=PA@mail.gmail.com>
Subject: Re: [PATCH 2/4] generic: ensure we drop suid after fallocate
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> Hi Darrick, that's another story, you don't need to worry about that in this case :)
> I'd like to ack this patch, but hope to move it from generic/ to shared/ . Maybe
> Eryu can help to move it, or I can do that after I get the push permission.
>
> The reason why I intend moving it to shared is:
> Although we are trying to get rid of tests/shared/, but the tests/shared/ still help to
> remind us what cases are still not real generic cases. We'll try to help all shared
> cases to be generic. When the time is ready, I'd like to move this case to generic/
> and change _supported_fs from "xfs btrfs ext4" to "generic".
>

Sorry, but I have to object to this move.
I do not think that is what tests/shared should be used for.

My preferences are:
1. _suppoted_fs generic && _require_xfs_io_command "finsert"
2. _suppoted_fs generic
3. _supported_fs xfs btrfs ext4 (without moving to tests/shared)

Thanks,
Amir.
