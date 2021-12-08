Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 184F4C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Dec 2021 18:54:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239420AbhLHS5v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Dec 2021 13:57:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232216AbhLHS5v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Dec 2021 13:57:51 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18957C061746
        for <linux-xfs@vger.kernel.org>; Wed,  8 Dec 2021 10:54:19 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id f9so8150460ybq.10
        for <linux-xfs@vger.kernel.org>; Wed, 08 Dec 2021 10:54:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=Oe0tpUDGY3RuZZBLNE6I0IhuleB6pOLOZvEDN+VLd/k=;
        b=UwbJa4Y9uALKrmoVYZ9HZCBLFwXT+KcyvS730uzQFj662VQ6DXQ5tMBt+X2LXd2yGa
         E6L+P2P7AVEXAGmCFqaGoefmaf8OC6vGgD8A8DIMH4g3qtGFJxOxyP1yrvdRJMZTvwbt
         48xldBT+oOeV5JIRWZfeH47NDGZ2CS01wKhzrFLgVtZ7y4zYjcorOeN5ZQzZPklyohA2
         fWui7vLV0jR3Kr73O9lP0jT8VDfcw69WzcvzmLn7A+cGd0VQQTtwHNVT34wNH/lhPrr+
         c9LqRSgwP1MbX0QS8cn3QWCoUuRBh+FLNMth/ZlzyjF3AGrQp5n+az9BQGoPn6pijVgf
         cUHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Oe0tpUDGY3RuZZBLNE6I0IhuleB6pOLOZvEDN+VLd/k=;
        b=1CuaXZt9QW6WF4BpJZ2I3crd3r0+uwioveH2FG4R0aozNUCYMkMHCTTAMGNZpXdSmG
         +KpqfIP+6RRQdmySYVW/luOhDV5WcfqR5Wv114LGPl/CDW1n4p/mnE885+qzpMc7Jipe
         yNU9HE66n4tgsdUs1MTqsgBMydqydcjI8YUHL5540JnKDvf8NuUyFMzjFHDFlMA/THL8
         4H+bUXDw4eFMhju9E5+XTCfHBZAI3oGQ9qbZws1AKG+XYXY2ZICM+rz1tP+Ec5NTRBc8
         cyPh/H0GTYsVPh6NT7wmepLFuEOTW+J3F0CiOnqeTazQu5piKztgg5+1SITy/RS9G+zO
         IIHQ==
X-Gm-Message-State: AOAM531HH3Z4wmjS/K1m+HQGtoZP0110BlkYZIZgDB5mPZ8ujwAFAPQ3
        osPr/b9fEowHIj37dvAF0CyusjthFQ3y58wFXcfmaYA9y90GyGtaHCo=
X-Google-Smtp-Source: ABdhPJwdVFBq5ngOR3stTMHDjLfaibdNLOwxM5XGiURulPbuWoQzJlkBIHAvuWItagJw/p6TuH2D30apxmXXR1mmNbI=
X-Received: by 2002:a25:71d7:: with SMTP id m206mr526362ybc.695.1638989658143;
 Wed, 08 Dec 2021 10:54:18 -0800 (PST)
MIME-Version: 1.0
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 8 Dec 2021 13:54:02 -0500
Message-ID: <CAJCQCtQdXZEXC+4iDgG9h5ETmytfaU1+mzAQ+sA9TfQ1qo3Y_w@mail.gmail.com>
Subject: VMs getting into stuck states since kernel ~5.13
To:     xfs list <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

I'm trying to help progress a kernel regression hitting Fedora
infrastructure in which dozens of VMs run concurrently to execute QA
testing. The problem doesn't happen immediately, but all the VM's get
stuck and then any new process also gets stuck, so extracting
information from the system has been difficult and there's not a lot
to go on, but this is what I've got so far.

Systems (Fedora openQA worker hosts) on kernel 5.12.12+ wind up in a
state where forking does not work correctly, breaking most things
https://bugzilla.redhat.com/show_bug.cgi?id=2009585

In that bug some items of interest ...

This megaraid_sas trace. The hang hasn't happened at this point
though, so it may not be related at all or it might be an instigator.
https://bugzilla.redhat.com/show_bug.cgi?id=2009585#c31

Once there is a hang, we have these traces from reducing the time for
the kernel to report blocked tasks. Much of the messages I'm told from
kvm/qemu folks are pretty ordinary/expected locks. But the XFS
portions might give a clue what's going on?

5.15-rc7
https://bugzilla-attachments.redhat.com/attachment.cgi?id=1840941
5.15+
https://bugzilla-attachments.redhat.com/attachment.cgi?id=1840939

So I can imagine the VM's are stuck because XFS is stuck. And XFS is
stuck because something in the block layer or megaraid driver is
stuck, but I don't know that for certain.

Thanks,

-- 
Chris Murphy
