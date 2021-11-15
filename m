Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12E8EC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Nov 2021 17:22:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1A7B632B9
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Nov 2021 17:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236881AbhKORZc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Nov 2021 12:25:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237814AbhKORYE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Nov 2021 12:24:04 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EBCC0432F7
        for <linux-xfs@vger.kernel.org>; Mon, 15 Nov 2021 09:14:46 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id s186so49085191yba.12
        for <linux-xfs@vger.kernel.org>; Mon, 15 Nov 2021 09:14:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03;
        h=mime-version:from:date:message-id:subject:to;
        bh=XKrccz4jATFmPxh1dIkigb9crsFJUMGqIpjw8ExPhk0=;
        b=BeSC0RgaMhAaHUYlyqTm253zv9XiuwVOKii7pfnU+cD//QBxkuOo3gQqw/y3QqZmYh
         OBdzhDMZxP62XYIuZMFllE5coTIAqYF4qulqtoY7iLC4cPgo64HvkdC7GyaPylt4bw+E
         X2x23drgYDXmrfq56kqEINHXni1ZkRCWHVgueigOdVFXwelfRXz0D2Jt2Qaooat1XFFD
         2fQH9cUPPD4CD4gTcUH/0YA5B1AWsuPCpLFO0/jD4qzyC097eG9Kh2X5fs/RvqVT5zpf
         5SagcGwYfYZAGHAgogroxqNp3yKmhz7Tbiv+X+bzS2epvKYMSkeVh1FFEE7RS5bGL20I
         Dpgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=XKrccz4jATFmPxh1dIkigb9crsFJUMGqIpjw8ExPhk0=;
        b=BGAS/FuuLHfWoVrcaLPiCUilkH3WZnTqxarPYkioirax6hpIp/VroF+cEl+Wa0LK/e
         v3wrVze4oIgh2N/pJ2FhRXHNZuXBNV5wjfyeJXbJMrSGIHPyzrk6l1Hdjy2GjmILyK1L
         23eY7fQw5rkgMUk2t2OjUcpnEDNms77GMBkk+Ck5gyepUfki5fKA5A21Px4X0QUQhMB0
         XbNETsRzLmNeq4AoMT6olTBCg9L4yB/tfwTabwsgpgeRrriK8sDspN1aaCB/Mb4L0txY
         CEVe2oltLM21LVb4zMYSS4PC77BGGBKBSVwjZ9GlBtB6hL/75LwTT7kCg4r9oWr5XjGA
         cnIg==
X-Gm-Message-State: AOAM531oLLnFknqZPmn0UYHj08Sm7D03/oWzngsrCh3ZaEDsrp3/Jkko
        WxljUQ3wX3GydPBW59e9Nl4Ua1+qf8LXZk78QXY11crJAQB8Rg==
X-Google-Smtp-Source: ABdhPJzELTbOg9wCHeUny+2Ht0GLqkkr+jaVhmKTxQVe9c53FwJ5ND5Nk0K9TrYXQT5pIFcW5Gv4m1ophdqb7bTezIc=
X-Received: by 2002:a5b:a85:: with SMTP id h5mr582748ybq.502.1636996485676;
 Mon, 15 Nov 2021 09:14:45 -0800 (PST)
MIME-Version: 1.0
From:   Sean Caron <scaron@umich.edu>
Date:   Mon, 15 Nov 2021 12:14:34 -0500
Message-ID: <CAA43vkU_X5Ss0uiKwji3eOPSo00-t-UGO-hNnAUy7-Wuyuce-g@mail.gmail.com>
Subject: Question regarding XFS crisis recovery
To:     linux-xfs@vger.kernel.org, Sean Caron <scaron@umich.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I recently had to manage a storage failure on a ~150 TB XFS volume and
I just wanted to check with the group here to see if anything could
have been done differently. Here is my story.

We had a 150 TB RAID 60 volume formatted with XFS. The volume was made
up of two 21-drive RAID 6 strings (4 TB drives). This was all done
with Linux MD software RAID.

The filesystem was filled to 100% capacity when it failed. I'm not
sure if this contributed to the poor outcome.

There was no backup available of this filesystem (of course).

About a week ago, we had two drives become spuriously ejected from one
of the two RAID 6 strings that composed this volume. This seems to
happen sometimes as a result of various hardware and software
glitches. We checked the drives with smartctl, added them back to the
array and a resync operation started.

The resync ran for a little while and failed, because a third disk in
the array (which mdadm had never failed out, and smartctl still
thought was OK) reported a read error/bad blocks and dropped out of
the array.

We decided to clone the failed disk to a brand new replacement drive with:

dd conv=notrunc,noerror,sync

Figuring we'd lose a few sectors to get nulled out, but we'd have a
drive that could run the rebuild without getting kicked due to read
errors (we've used this technique in the past to recover from this
kind of situation successfully).

Clone completed. We swapped the clone drive with the bad blocks drive
and kicked off another rebuild.

Rebuild fails again because a fourth drive is throwing bad blocks/read
errors and gets kicked out of the array.

We scan all 21 drives in this array with smartctl and there are
actually three more drives in total where SMART has logged read
errors.

This is starting to look pretty bad but what can we do? We just clone
these three drives to three more fresh drives using dd
conv=notrunc,noerror,sync.

Swap them in for the old bad block drives and kick off another
rebuild. The rebuild actually runs and completes successfully. MD
thinks the array is fine, running, not degraded at all.

We mount the array. It mounts, but it is obviously pretty damaged.
Normally when this happens we try to mount it read only and copy off
what we can, then write it off. This time, we can't hardly do anything
but an "ls" in the filesystem without getting "structure needs
cleaning". Doing any kind of material access to the filesystem gives
various major errors (i.e. "in-memory corruption of filesystem data
detected") and the filesystem goes offline. Reads just fail with I/O
errors.

What can we do? Seems like at this stage we just run xfs_repair and
hope for the best, right?

Ran xfs_repair in dry run mode and it's looking pretty bad, just from
the sheer amount of output.

But there's no real way to know exactly how much data xfs_repair will
wipe out, and what alternatives do we have? The filesystem hardly
mounts without faulting anyway. Seems like there's little choice going
forward to run it, and see what shakes out.

We run xfs_repair overnight. It ran for a while, then eventually hung
in Phase 4, I think.

We killed xfs_repair off and re-ran it with the -P flag. It runs for
maybe two or three hours and eventually completes.

We mount the filesystem up. Of around 150 TB, we have maybe 10% of
that in data salad in lost+found, 21 GB of good data and the rest is
gone.

Copy off what we can, and call it dead. This is where we're at now.

It seems like the MD rebuild process really scrambled things somehow.
I'm not sure if this was due to some kind of kernel bug, or just
zeroed out bad sectors in wrong places or what. Once the md resync
ran, we were cooked.

I guess, after blowing through four or five "Hope you have a backup,
but if not, you can try this and pray" checkpoints, I just want to
check with the developers and group here to see if we did the best
thing possible given the circumstances?

Xfs_repair is it, right? When things are that scrambled, pretty much
all you can do is run an xfs_repair and hope for the best? Am I
correct in thinking that there is no better or alternative tool that
will give different results?

Can a commercial data recovery service make any better sense of a
scrambled XFS than xfs_repair could? When the underlying device is
presenting OK, just scrambled data on it?

Thanks,

Sean
