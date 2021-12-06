Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E92ABC433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Dec 2021 17:29:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241476AbhLFRdD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Dec 2021 12:33:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46160 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236887AbhLFRdC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Dec 2021 12:33:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638811773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=pluou9dkTfeERh9h0sY468HkUZGgU4PhxIEm9kg/E4c=;
        b=iRwsjFLpXAL61ZTMBy2ehnE9CDJX/5hePaIFqGctecCO8aJg6Pun/7oPUnfmKYhOLli6CZ
        c3qGCeoLxB+2gB2QtdfCHDPg/Ymp0g4Fx3TkezKhmFYFy6UaJqo/oM2VNgMknjYppSEmoL
        Yc3kmDc5e2rTNMbpbHxNs3XYNVUmc7k=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-66-x8Fv0pLcM0Cg9Cw4QnY-iQ-1; Mon, 06 Dec 2021 12:29:32 -0500
X-MC-Unique: x8Fv0pLcM0Cg9Cw4QnY-iQ-1
Received: by mail-qv1-f71.google.com with SMTP id q9-20020ad45749000000b003bdeb0612c5so13041565qvx.8
        for <linux-xfs@vger.kernel.org>; Mon, 06 Dec 2021 09:29:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=pluou9dkTfeERh9h0sY468HkUZGgU4PhxIEm9kg/E4c=;
        b=BXB8+UpOihtkAVvkGYD3xFkLRWEIYABkMcU/++nzVrVoRQ9+/uu4Qu9LAJ5iDKJb9c
         +uTYALF5NUTfID4fafKCx2tbnHCsRvgdld/Qajj4BdQV+8iI1hg1a38taPrmb6LboTNc
         +iENafbdqgwE6irsBaKkBSY6KC+tgyq8r2WJJZWOf/WqLySSd4vi/kvIjBmTR5IbUABG
         Y+o8pUQKnoAzSQt0M6CXeK3zGDnd8Gx5hBNQqIKwC8M2GXPdBli7vnZausoX1zNlhBjb
         ZSdNHRv5naG/EsFLhycVMxkpNf4toEZsa2kZm3etIcFcXSkcfnFx6H+DPnyLNv9gt9UZ
         Yuqg==
X-Gm-Message-State: AOAM530slYtqO1xe589DkO6MhtR4C7KRUYmewfnBnBgkGrHfhzMbm0S+
        dSy5mampQgdxn1Pt5+ymvZtH5z2znGNi65q83UrB0ips13hsHg/CeAi8U0mjsIe1aQZwdeoEQjy
        HxFW57AFWm4WRpqMnIV6/6FukF5/rii+fvd3/9K9HwmFGGs8RKBVFQs8SlkYF1Xxs+JaA2o4=
X-Received: by 2002:a05:6214:e66:: with SMTP id jz6mr38609867qvb.20.1638811771754;
        Mon, 06 Dec 2021 09:29:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyvbdh9YZT4N8DhBSleru2VC9+oXuAlUNTGr+zSmXmYTsDmrMaksJ4xrxr9dJns4eVYOjjzAw==
X-Received: by 2002:a05:6214:e66:: with SMTP id jz6mr38609833qvb.20.1638811771455;
        Mon, 06 Dec 2021 09:29:31 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id l15sm8054678qtx.77.2021.12.06.09.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 09:29:31 -0800 (PST)
Date:   Mon, 6 Dec 2021 12:29:28 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Gonzalo Siero Humet <gsierohu@redhat.com>
Subject: [RFD] XFS inode reclaim (inactivation) under fs freeze
Message-ID: <Ya5IeB3iBBcpD1z+@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

We have reports on distro (pre-deferred inactivation) kernels that inode
reclaim (i.e. via drop_caches) can deadlock on the s_umount lock when
invoked on a frozen XFS fs. This occurs because drop_caches acquires the
lock and then blocks in xfs_inactive() on transaction alloc for an inode
that requires an eofb trim. Unfreeze blocks on the same lock and thus
the fs is deadlocked (in a frozen state). As far as I'm aware, this has
been broken for some time and probably just not observed because reclaim
under freeze is a rare and unusual situation.
    
With deferred inactivation, the deadlock problem actually goes away
because ->destroy_inode() will never block when the filesystem is
frozen. There is new/odd behavior, however, in that lookups of a pending
inactive inode spin loop waiting for the pending inactive state to
clear. That won't happen until the fs is unfrozen.

Also, the deferred inactivation queues are not consistently flushed on
freeze. I've observed that xfs_freeze invokes an xfs_inodegc_flush()
indirectly via xfs_fs_statfs(), but fsfreeze does not. Therefore, I
suspect it may be possible to land in this state from the onset of a
freeze based on prior reclaim behavior. (I.e., we may want to make this
flush explicit on freeze, depending on the eventual solution.)

Some internal discussion followed on potential improvements in response
to the deadlock report. Dave suggested potentially preventing reclaim of
inodes that would require inactivation, keeping them in cache, but it
appears we may not have enough control in the local fs to guarantee this
behavior out of the vfs and shrinkers (Dave can chime in on details, if
needed). He also suggested skipping eofb trims and sending such inodes
directly to reclaim. My current preference is to invoke an inodegc flush
and blockgc scan during the freeze sequence so presumably no pending
inactive but potentially accessible (i.e. not unlinked) inodes can
reside in the queues for the duration of a freeze. Perhaps others have
different ideas or thoughts on these.

In any event, this is an FYI/RFD given that deferred inactivation is
fairly new and I'm not sure we have a concrete sense of whether the
resulting changes in behavior might be more or less observable (and/or
disruptive) to users than the historical, more severe problem.

Brian

