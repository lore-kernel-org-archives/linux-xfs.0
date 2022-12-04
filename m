Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9714C4321E
	for <linux-xfs@archiver.kernel.org>; Sun,  4 Dec 2022 16:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiLDQh6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 4 Dec 2022 11:37:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiLDQh5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Dec 2022 11:37:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00EA812D29
        for <linux-xfs@vger.kernel.org>; Sun,  4 Dec 2022 08:37:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670171823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xAcFBfhNJHwotRSc2lWCOi76ow6aaVuRhG6ZwPyPCys=;
        b=EsgFR8HCYcIPx8mtoKDsF/vUsMjV2STZQC3l5PToDRyU55uNLbMDYk7D+/yF3PBaCLtj7B
        o68oleKEA/7EzhiWk10+BJ8jbBNA32wirBWLusKgV+gOqkXbJcgQsa1gOKx+opCRlJGFyI
        ZbehxZdxxcAOgbCS6OYjzF92+V/doQ0=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-633-0LwJiAUaPhixTHHomTB-_g-1; Sun, 04 Dec 2022 11:37:01 -0500
X-MC-Unique: 0LwJiAUaPhixTHHomTB-_g-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-3b48b605351so102511487b3.22
        for <linux-xfs@vger.kernel.org>; Sun, 04 Dec 2022 08:37:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xAcFBfhNJHwotRSc2lWCOi76ow6aaVuRhG6ZwPyPCys=;
        b=DqTAJcASAIMBp+HNNMpXPBHOk1Ys4BrxMLRh4gAOyJJQ3/XTgkHdNkWYfL0AwBVcWw
         UF7h7hei1JO8oWFg2DtHMp5qenQFShkndNAv6JvNHq/weumuGW5XwX0HpZ7cmaaCIjxn
         0mU5i3nZg0l7uPGiaA47y2oxbWwGVEt+gEy7wm4cqGGk3hhxzrzZ8weZS5/0K7UcdI4B
         0Q56OT+Y/P7am9r6Clp/GMq4tL5tPNIIkFFWktox8bMB1shSO5PyqnZ1c08Kqqh2673U
         kEswLjsfY1pbnSR5JCY8BV483Rr9wbX6g+LQNbvE3LJ78pwXlx5j8pPVSU95D4eNT7Au
         IVHQ==
X-Gm-Message-State: ANoB5pm5ijrnWhRtPL9eu1kPmsyzebzCJrCIAS20vscpgmZPrPQOt5Bi
        y5cWc7xP3lQZH7chgqe/9AsDfEQimAuWdCVun8y94CoDt6LBx399dqYjKp2cf8x2/xI9fyCSE0L
        F9PJeovIMHi5gtqoL18M8PXVo5HZV07vwVPS8
X-Received: by 2002:a05:6902:1370:b0:6ff:eb24:45aa with SMTP id bt16-20020a056902137000b006ffeb2445aamr3374365ybb.321.1670171821156;
        Sun, 04 Dec 2022 08:37:01 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6l1GEsDbt+1fLFvB5CX9o/590iQHKz3Y0r+oifb1/CEIrRXsQMblaRNYfjnfzmfVHrTa1jtlVuqyzychSWXQ4=
X-Received: by 2002:a05:6902:1370:b0:6ff:eb24:45aa with SMTP id
 bt16-20020a056902137000b006ffeb2445aamr3374352ybb.321.1670171820974; Sun, 04
 Dec 2022 08:37:00 -0800 (PST)
MIME-Version: 1.0
References: <000000000000d1663705ee97d4d7@google.com> <20221129203054.GF3600936@dread.disaster.area>
In-Reply-To: <20221129203054.GF3600936@dread.disaster.area>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Sun, 4 Dec 2022 17:36:49 +0100
Message-ID: <CAHc6FU4OhgPsgBGZjKEma8Qt0=HnfkTWL2mWEXCrJEi4P4SnLQ@mail.gmail.com>
Subject: Re: [Cluster-devel] [syzbot] WARNING in iomap_read_inline_data
To:     Dave Chinner <david@fromorbit.com>
Cc:     syzbot <syzbot+7bb81dfa9cda07d9cd9d@syzkaller.appspotmail.com>,
        linux-xfs@vger.kernel.org, cluster-devel@redhat.com,
        djwong@kernel.org, syzkaller-bugs@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 29, 2022 at 9:31 PM Dave Chinner <david@fromorbit.com> wrote:
> Looks like something to do with the gfs2 inline data functionality -
> syzbot probably corrupted the resource index inode given the
> gfs2_fill_super() context.

Hmm, interesting. We're not checking the size of inline (stuffed)
inodes when reading them from disk in gfs2_dinode_in(). I'll fix that.

Thanks,
Andreas

