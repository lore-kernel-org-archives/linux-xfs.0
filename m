Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93D76C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Nov 2021 00:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40D8561AA2
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Nov 2021 00:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353271AbhKPAfa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Nov 2021 19:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344608AbhKOTZH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Nov 2021 14:25:07 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54EFFC04A1B9
        for <linux-xfs@vger.kernel.org>; Mon, 15 Nov 2021 10:35:41 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id s186so49727391yba.12
        for <linux-xfs@vger.kernel.org>; Mon, 15 Nov 2021 10:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4vBj+1Z+tdGD5NjjExREEHvjNGdrcWTlSqiqfm9DnGE=;
        b=qSkMjRPnrKRdIqc/za67eea+qPXcP7xvRioM3siLCIZjWlUceTGIndIadcIarelEhU
         F6VjapzUIy2F1tjWo/RQZ1aP7BXX0taGyo3EVKtWSreklioZZqsyc5KKS4W1co+bSbEJ
         3oX63qj32Idq6B38AdB8DsqSH8WJ9z8c+4Fs9PmcBG4ChFiDr1Ygnva/QsMt1u0pRuyg
         S/22Js0hp1Hkv2VNRmOD+1Hw4au6KeohrRqgO1jtgg3tj2OC76YgV5Qb9G7ako/rWWwX
         BgvS7pKvWSwF30jeuMfnweqngLbarc77726fHdSnHqZzTzNnisxQmXe0fEzRIyc5Fgvi
         Zarg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4vBj+1Z+tdGD5NjjExREEHvjNGdrcWTlSqiqfm9DnGE=;
        b=0FXn55mPGaEK3kFzN1XD+EqaCrpDf5zSqwTOcbejlsh424QUKdHF3nj/kmIoMzV2jg
         nUm7pNLPow142c+EGW2WrzrAi26NDEec9c4CnsGXoruJ8aVSr7n3/ROy00JNsHX3Qvha
         /JkrCNnFmSGsHS/YPmI0qZRg/Hff3K6W5exZ7Y/iBFY1JCwAVCm6cUZpK1wzL6R8KwL2
         dAAfCGUsSl7q+Dwo5d8pgTOI/uzbIPEafUYP00ZGqeb3V+gD9GVtZl/UrzgDPGOy/GhE
         9iACLhYHVunhofhVzhoYUAaH4VpOMRZwZXvnsTX3NI3CsB618wx1NT6i+T6orG4hmuv7
         dNIg==
X-Gm-Message-State: AOAM533cnGXr08tFd54IqCq7TQQvZeEx6tC8dH71MTB76D7RqlrO7tUU
        ikL9gJMZ/clZXf4p2PD9yLBc9hOsaqMFJeotI/4UFzA9vpJctN1AV9Y=
X-Google-Smtp-Source: ABdhPJzfaUmbbzezIMa8Iy2/S0ffqwm0FKaFr+kB3weKROEizNxwUcuRyr28gURWWhWQwEjFGkse+qX31eM21PyeTGg=
X-Received: by 2002:a05:6902:1021:: with SMTP id x1mr1100978ybt.391.1637001340490;
 Mon, 15 Nov 2021 10:35:40 -0800 (PST)
MIME-Version: 1.0
References: <CAA43vkU_X5Ss0uiKwji3eOPSo00-t-UGO-hNnAUy7-Wuyuce-g@mail.gmail.com>
In-Reply-To: <CAA43vkU_X5Ss0uiKwji3eOPSo00-t-UGO-hNnAUy7-Wuyuce-g@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 15 Nov 2021 13:35:24 -0500
Message-ID: <CAJCQCtQCJ-biTPq8+_yZx6x3=ART1tMYttpMwwddzx4frWdDow@mail.gmail.com>
Subject: Re: Question regarding XFS crisis recovery
To:     Sean Caron <scaron@umich.edu>
Cc:     xfs list <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 15, 2021 at 12:22 PM Sean Caron <scaron@umich.edu> wrote:
>
> Hi all,
>
> I recently had to manage a storage failure on a ~150 TB XFS volume and
> I just wanted to check with the group here to see if anything could
> have been done differently. Here is my story.
>
> We had a 150 TB RAID 60 volume formatted with XFS. The volume was made
> up of two 21-drive RAID 6 strings (4 TB drives). This was all done
> with Linux MD software RAID.
>
> The filesystem was filled to 100% capacity when it failed. I'm not
> sure if this contributed to the poor outcome.
>
> There was no backup available of this filesystem (of course).
>
> About a week ago, we had two drives become spuriously ejected from one
> of the two RAID 6 strings that composed this volume. This seems to
> happen sometimes as a result of various hardware and software
> glitches. We checked the drives with smartctl, added them back to the
> array and a resync operation started.
>
> The resync ran for a little while and failed, because a third disk in
> the array (which mdadm had never failed out, and smartctl still
> thought was OK) reported a read error/bad blocks and dropped out of
> the array.
>
> We decided to clone the failed disk to a brand new replacement drive with:
>
> dd conv=notrunc,noerror,sync
>
> Figuring we'd lose a few sectors to get nulled out, but we'd have a
> drive that could run the rebuild without getting kicked due to read
> errors (we've used this technique in the past to recover from this
> kind of situation successfully).
>
> Clone completed. We swapped the clone drive with the bad blocks drive
> and kicked off another rebuild.
>
> Rebuild fails again because a fourth drive is throwing bad blocks/read
> errors and gets kicked out of the array.
>
> We scan all 21 drives in this array with smartctl and there are
> actually three more drives in total where SMART has logged read
> errors.
>
> This is starting to look pretty bad but what can we do? We just clone
> these three drives to three more fresh drives using dd
> conv=notrunc,noerror,sync.
>
> Swap them in for the old bad block drives and kick off another
> rebuild. The rebuild actually runs and completes successfully. MD
> thinks the array is fine, running, not degraded at all.
>
> We mount the array. It mounts, but it is obviously pretty damaged.
> Normally when this happens we try to mount it read only and copy off
> what we can, then write it off. This time, we can't hardly do anything
> but an "ls" in the filesystem without getting "structure needs
> cleaning". Doing any kind of material access to the filesystem gives
> various major errors (i.e. "in-memory corruption of filesystem data
> detected") and the filesystem goes offline. Reads just fail with I/O
> errors.
>
> What can we do? Seems like at this stage we just run xfs_repair and
> hope for the best, right?
>
> Ran xfs_repair in dry run mode and it's looking pretty bad, just from
> the sheer amount of output.
>
> But there's no real way to know exactly how much data xfs_repair will
> wipe out, and what alternatives do we have? The filesystem hardly
> mounts without faulting anyway. Seems like there's little choice going
> forward to run it, and see what shakes out.
>
> We run xfs_repair overnight. It ran for a while, then eventually hung
> in Phase 4, I think.
>
> We killed xfs_repair off and re-ran it with the -P flag. It runs for
> maybe two or three hours and eventually completes.
>
> We mount the filesystem up. Of around 150 TB, we have maybe 10% of
> that in data salad in lost+found, 21 GB of good data and the rest is
> gone.
>
> Copy off what we can, and call it dead. This is where we're at now.
>
> It seems like the MD rebuild process really scrambled things somehow.
> I'm not sure if this was due to some kind of kernel bug, or just
> zeroed out bad sectors in wrong places or what. Once the md resync
> ran, we were cooked.
>
> I guess, after blowing through four or five "Hope you have a backup,
> but if not, you can try this and pray" checkpoints, I just want to
> check with the developers and group here to see if we did the best
> thing possible given the circumstances?
>
> Xfs_repair is it, right? When things are that scrambled, pretty much
> all you can do is run an xfs_repair and hope for the best? Am I
> correct in thinking that there is no better or alternative tool that
> will give different results?
>
> Can a commercial data recovery service make any better sense of a
> scrambled XFS than xfs_repair could? When the underlying device is
> presenting OK, just scrambled data on it?

I'm going to let others address the XFS issues if any. My take is this
is not at all XFS related, but a problem with lower layers in the
storage stack.

What is the SCT ERC value for each of the drives?  This value must be
less than the kernel's SCSI command timer, which by default is 30
seconds.

It sounds to me like a common misconfiguration where the drive SCT ERC
is not configured, bad sectors accumulate over time because they are
never being fixed up as a result of the miconfiguration. And once a
single stripe is lost, representing a critical amount off file system
metadata, you lose the whole file system. It's a very high penalty for
what is actually an avoidable problem, but relies on esoteric
knowledge and resistence of downstream distros to change kernel
defaults because they don't understand most of the knobs. And upstream
kernel development's reluctance to change defaults because of various
downstream expectations based on them. Those are generally valid
positions, but in the specific case of large software raid arrays,
Linux has a bad reputation strictly because of crap defaults where the
common case is that SCT ERC is a higher value than the SCSI command
timer. And this will *always* lead to data loss, eventually.

Check the *device* timeout with this command
smartctl -l scterc /dev/sdX

Check the *kernel* timeout with this command
cat /sys/block/sdX/device/timeout

If the drive doesn't support configurable SCT ERC, then you must
increase the kernel's command timer to a ridiculous value like 180.
Seriously 180 seconds for a drive to decide whether a sector is
unreadable is ridiculous but the logic of the consumer drive is
there's no redundancy so try as long and hard as possible before
giving up, the exact opposite of what we want in a raid array.

This guide is a bit stale, I prefer to change either SCT ERC or the
command timer with a udev rule. But the result is the same.
https://raid.wiki.kernel.org/index.php/Timeout_Mismatch

-- 
Chris Murphy
