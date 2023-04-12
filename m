Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68FE5C77B6E
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 15:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbjDLP6I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 11:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbjDLP6H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2023 11:58:07 -0400
X-Greylist: delayed 7892 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 12 Apr 2023 08:58:04 PDT
Received: from mail.flyingcircus.io (mail.flyingcircus.io [IPv6:2a02:238:f030:102::1064])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41DA172C
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 08:58:04 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
        s=mail; t=1681315081;
        bh=7dWMk+p6mNi5KllLoYfV87TEwXLRd/4hJdzUzk2/xLA=;
        h=Subject:From:In-Reply-To:Date:Cc:References:To;
        b=kaLw2HE+oP3ZqylwbPrhcxb+Yk4z1VoqBcFKZAqkeO+IzGqu8/OX/JrB7ZQl7JBQ4
         esaEinBQpc7VPb9crgfo5wIZhNlD+MdO7/80OXylm5EN+zDtdhgspk/0PDOrFlQ9K2
         CWIPXlcWxIh8oVwtnwJQQhEM7KXeaXzyl9u6EMJI=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: Backport of "xfs: open code ioend needs workqueue helper" to
 5.10?
From:   Christian Theune <ct@flyingcircus.io>
In-Reply-To: <CAOQ4uxg6cTF2YnW6anxMxOH_88+JZW+sC9rG468Pjy=XrNEgrQ@mail.gmail.com>
Date:   Wed, 12 Apr 2023 17:57:41 +0200
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <6AB6497D-18E5-41C4-B688-4DED6703534F@flyingcircus.io>
References: <57B035ED-1926-4524-8063-EB0A8DB54AF7@flyingcircus.io>
 <CAOQ4uxg6cTF2YnW6anxMxOH_88+JZW+sC9rG468Pjy=XrNEgrQ@mail.gmail.com>
To:     Amir Goldstein <amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

ugh. Sorry, looks like I jumped the gun. Mea culpa.

We experienced a hang like this:

Apr 05 11:51:27 kernel: "echo 0 > =
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 05 11:51:27 kernel: task:xfs-conv/vdc1   state:D stack:    0 pid:  =
606 ppid:     2 flags:0x00004080
Apr 05 11:51:27 kernel: Workqueue: xfs-conv/vdc1 xfs_end_io [xfs]
Apr 05 11:51:27 kernel: Call Trace:
Apr 05 11:51:27 kernel:  __schedule+0x274/0x870
Apr 05 11:51:27 kernel:  schedule+0x46/0xb0
Apr 05 11:51:27 kernel:  xlog_grant_head_wait+0xc5/0x1d0 [xfs]
Apr 05 11:51:27 kernel:  xlog_grant_head_check+0xde/0x100 [xfs]
Apr 05 11:51:27 kernel:  xfs_log_reserve+0xbe/0x1b0 [xfs]
Apr 05 11:51:27 kernel:  xfs_trans_reserve+0x143/0x180 [xfs]
Apr 05 11:51:27 kernel:  xfs_trans_alloc+0xee/0x1a0 [xfs]
Apr 05 11:51:27 kernel:  xfs_iomap_write_unwritten+0x120/0x2e0 [xfs]
Apr 05 11:51:27 kernel:  ? record_times+0x15/0x90
Apr 05 11:51:27 kernel:  xfs_end_ioend+0xd8/0x140 [xfs]
Apr 05 11:51:27 kernel:  xfs_end_io+0xb8/0xf0 [xfs]
Apr 05 11:51:27 kernel:  process_one_work+0x1b6/0x350
Apr 05 11:51:27 kernel:  rescuer_thread+0x1d1/0x3a0
Apr 05 11:51:27 kernel:  ? worker_thread+0x3e0/0x3e0
Apr 05 11:51:27 kernel:  kthread+0x11b/0x140
Apr 05 11:51:27 kernel:  ? kthread_associate_blkcg+0xb0/0xb0
Apr 05 11:51:27 kernel:  ret_from_fork+0x22/0x30

Which seems to be similar to this:
https://bugs.launchpad.net/bugs/1996269

I followed their patchset here:
https://review.opendev.org/c/starlingx/kernel/+/864257

And I was under the impression that I picked the right one to ask for =
backporting, but it seems that was incorrect. I went through the list =
again and I think the following patches are the ones missing from 5.10:

8182ec00803085354761bbadf0287cad7eac0e2f - =
https://review.opendev.org/c/starlingx/kernel/+/864257/5/kernel-std/centos=
/patches/0035-xfs-drop-submit-side-trans-alloc-for-append-ioends.patch
edbf1eb9032b84631031d9b43570e262f3461c24 - =
https://review.opendev.org/c/starlingx/kernel/+/864257/5/kernel-std/centos=
/patches/0036-xfs-open-code-ioend-needs-workqueue-helper.patch
170e31793806ce5e5a9647b6340954536244518e - =
https://review.opendev.org/c/starlingx/kernel/+/864257/5/kernel-std/centos=
/patches/0037-xfs-drop-unused-ioend-private-merge-and-setfilesize-.patch
2fd609b6c90a88630a50fb317473b210759b3873 - =
https://review.opendev.org/c/starlingx/kernel/+/864257/5/kernel-std/centos=
/patches/0038-xfs-drop-unnecessary-setfilesize-helper.patch

The first one in the series was applied in 5.10.129 afaict and landed in =
mainstream in 5.12 already.

Cheers,
Christian

> On 12. Apr 2023, at 16:12, Amir Goldstein <amir73il@gmail.com> wrote:
>=20
> On Wed, Apr 12, 2023 at 5:06=E2=80=AFPM Christian Theune =
<ct@flyingcircus.io> wrote:
>>=20
>> Hi,
>>=20
>> afaict this was fixed in 5.13 but hasn=E2=80=99t been backported. =
I=E2=80=99ve seen one of our VMs running 5.10.169 crash with this.
>>=20
>> Anybody willing to backport this? It=E2=80=99s only triggered a =
single time so far and we are rolling out 5.15 anyways, but maybe this =
was an oversight =E2=80=A6 ?
>=20
> What do you mean by "crash with this"?
>=20
> There is no logic change in the commit mentioned below.
>=20
> Thanks,
> Amir.
>=20
>>=20
>> commit 7adb8f14e134d5f885d47c4ccd620836235f0b7f
>> Author: Brian Foster <bfoster@redhat.com>
>> Date:   Fri Apr 9 10:27:55 2021 -0700
>>=20
>>    xfs: open code ioend needs workqueue helper
>>=20
>>    Open code xfs_ioend_needs_workqueue() into the only remaining
>>    caller.
>>=20
>>    Signed-off-by: Brian Foster <bfoster@redhat.com>
>>    Reviewed-by: Christoph Hellwig <hch@lst.de>
>>    Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>>    Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>>=20
>>=20
>> Kind regards,
>> Christian
>>=20
>> --
>> Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
>> Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
>> Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
>> HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian =
Theune, Christian Zagrodnick
>>=20

Liebe Gr=C3=BC=C3=9Fe,
Christian Theune

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

