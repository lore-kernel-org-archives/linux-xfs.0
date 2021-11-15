Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2271DC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Nov 2021 00:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BF3C613AD
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Nov 2021 00:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348177AbhKPAoz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Nov 2021 19:44:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343669AbhKOTVf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Nov 2021 14:21:35 -0500
X-Greylist: delayed 451 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 15 Nov 2021 10:21:57 PST
Received: from c.mx.filmlight.ltd.uk (c.mx.filmlight.ltd.uk [IPv6:2a05:d018:e66:3130::21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E781CC061226
        for <linux-xfs@vger.kernel.org>; Mon, 15 Nov 2021 10:21:56 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by omni.filmlight.ltd.uk (Postfix) with ESMTP id 7808940000DE;
        Mon, 15 Nov 2021 18:08:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 omni.filmlight.ltd.uk 7808940000DE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=filmlight.ltd.uk;
        s=default; t=1636999692;
        bh=DLLulAFG6MEUG043oYjWM0yzOypr0nrrS02suwqEmM0=;
        h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
        b=G0tm9riBBHZR8gxO4mudQN00S2U5VWjL+t8RqMM8+dBeonV2Jl73pO4RKHTlAjgL4
         9J5TccYdO5qAHKIzomOJOjs8EtgNmUCFxNZy+MJIoMHAZmLdHA4VrgmK5GD1XUID42
         MekTdWo8ZyrSrRLW3UJg4w+gUVNX1OGTQA8u0/sc=
Received: from smtpclient.apple (cpc122860-stev8-2-0-cust234.9-2.cable.virginm.net [81.111.212.235])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: roger)
        by omni.filmlight.ltd.uk (Postfix) with ESMTPSA id 31517867204;
        Mon, 15 Nov 2021 18:08:12 +0000 (GMT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: Question regarding XFS crisis recovery
From:   Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <CAA43vkU_X5Ss0uiKwji3eOPSo00-t-UGO-hNnAUy7-Wuyuce-g@mail.gmail.com>
Date:   Mon, 15 Nov 2021 18:13:59 +0000
Cc:     Roger Willcocks <roger@filmlight.ltd.uk>, linux-xfs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <0CC7D592-3B70-4EE5-B94D-228740ABBEC9@filmlight.ltd.uk>
References: <CAA43vkU_X5Ss0uiKwji3eOPSo00-t-UGO-hNnAUy7-Wuyuce-g@mail.gmail.com>
To:     Sean Caron <scaron@umich.edu>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In principle that should have worked. And yes, when you=E2=80=99ve got =
the filesystem back to the point where it mounts, xfs-repair is your =
only option.

It might have been useful to take an xfs-metadump before the repair, to =
see what xfs-repair would make if it, and to share it with others for =
their thoughts.

It does seem like there should be an md resync recovery option which =
substitutes zeroes for bad blocks instead of giving up immediately. A =
few blocks of corrupted data in 150 TB is obviously preferable to no =
data at all.

Or allow it to fall back to reading the =E2=80=98dropped out=E2=80=99 =
drives if there=E2=80=99s a read error elsewhere in the stripe while =
they=E2=80=99re build rebuilt.=20

=E2=80=94
Roger


> On 15 Nov 2021, at 17:14, Sean Caron <scaron@umich.edu> wrote:
>=20
> Hi all,
>=20
> I recently had to manage a storage failure on a ~150 TB XFS volume and
> I just wanted to check with the group here to see if anything could
> have been done differently. Here is my story.
>=20
> We had a 150 TB RAID 60 volume formatted with XFS. The volume was made
> up of two 21-drive RAID 6 strings (4 TB drives). This was all done
> with Linux MD software RAID.
>=20
> The filesystem was filled to 100% capacity when it failed. I'm not
> sure if this contributed to the poor outcome.
>=20
> There was no backup available of this filesystem (of course).
>=20
> About a week ago, we had two drives become spuriously ejected from one
> of the two RAID 6 strings that composed this volume. This seems to
> happen sometimes as a result of various hardware and software
> glitches. We checked the drives with smartctl, added them back to the
> array and a resync operation started.
>=20
> The resync ran for a little while and failed, because a third disk in
> the array (which mdadm had never failed out, and smartctl still
> thought was OK) reported a read error/bad blocks and dropped out of
> the array.
>=20
> We decided to clone the failed disk to a brand new replacement drive =
with:
>=20
> dd conv=3Dnotrunc,noerror,sync
>=20
> Figuring we'd lose a few sectors to get nulled out, but we'd have a
> drive that could run the rebuild without getting kicked due to read
> errors (we've used this technique in the past to recover from this
> kind of situation successfully).
>=20
> Clone completed. We swapped the clone drive with the bad blocks drive
> and kicked off another rebuild.
>=20
> Rebuild fails again because a fourth drive is throwing bad blocks/read
> errors and gets kicked out of the array.
>=20
> We scan all 21 drives in this array with smartctl and there are
> actually three more drives in total where SMART has logged read
> errors.
>=20
> This is starting to look pretty bad but what can we do? We just clone
> these three drives to three more fresh drives using dd
> conv=3Dnotrunc,noerror,sync.
>=20
> Swap them in for the old bad block drives and kick off another
> rebuild. The rebuild actually runs and completes successfully. MD
> thinks the array is fine, running, not degraded at all.
>=20
> We mount the array. It mounts, but it is obviously pretty damaged.
> Normally when this happens we try to mount it read only and copy off
> what we can, then write it off. This time, we can't hardly do anything
> but an "ls" in the filesystem without getting "structure needs
> cleaning". Doing any kind of material access to the filesystem gives
> various major errors (i.e. "in-memory corruption of filesystem data
> detected") and the filesystem goes offline. Reads just fail with I/O
> errors.
>=20
> What can we do? Seems like at this stage we just run xfs_repair and
> hope for the best, right?
>=20
> Ran xfs_repair in dry run mode and it's looking pretty bad, just from
> the sheer amount of output.
>=20
> But there's no real way to know exactly how much data xfs_repair will
> wipe out, and what alternatives do we have? The filesystem hardly
> mounts without faulting anyway. Seems like there's little choice going
> forward to run it, and see what shakes out.
>=20
> We run xfs_repair overnight. It ran for a while, then eventually hung
> in Phase 4, I think.
>=20
> We killed xfs_repair off and re-ran it with the -P flag. It runs for
> maybe two or three hours and eventually completes.
>=20
> We mount the filesystem up. Of around 150 TB, we have maybe 10% of
> that in data salad in lost+found, 21 GB of good data and the rest is
> gone.
>=20
> Copy off what we can, and call it dead. This is where we're at now.
>=20
> It seems like the MD rebuild process really scrambled things somehow.
> I'm not sure if this was due to some kind of kernel bug, or just
> zeroed out bad sectors in wrong places or what. Once the md resync
> ran, we were cooked.
>=20
> I guess, after blowing through four or five "Hope you have a backup,
> but if not, you can try this and pray" checkpoints, I just want to
> check with the developers and group here to see if we did the best
> thing possible given the circumstances?
>=20
> Xfs_repair is it, right? When things are that scrambled, pretty much
> all you can do is run an xfs_repair and hope for the best? Am I
> correct in thinking that there is no better or alternative tool that
> will give different results?
>=20
> Can a commercial data recovery service make any better sense of a
> scrambled XFS than xfs_repair could? When the underlying device is
> presenting OK, just scrambled data on it?
>=20
> Thanks,
>=20
> Sean
>=20

