Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4E96C77B61
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Apr 2023 10:51:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbjDMKve (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Apr 2023 06:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbjDMKv1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2023 06:51:27 -0400
Received: from mail.flyingcircus.io (mail.flyingcircus.io [IPv6:2a02:238:f030:102::1064])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A34D901C
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 03:51:05 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
        s=mail; t=1681383063;
        bh=H5qqC9xMs1bJfDoARg1H2WPdtLdGbCFT/4ngyQ1x4dQ=;
        h=Subject:From:In-Reply-To:Date:Cc:References:To;
        b=bfPCmIas4TXtjvjoB4aLFyXreC4myDk8YbKxPPjlNZZhSe8ggTmpPKznPqn4Pn6GP
         6/60oCVliqwNGwgODM+/1+SQa6RKAO9yCEJIzDqacU18tLYx2gW4x/aAIgKFO606ay
         rV707NcTqm5ZeP7frKDGCEB3xv14poAFSpWKbGL0=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: Backport of "xfs: open code ioend needs workqueue helper" to
 5.10?
From:   Christian Theune <ct@flyingcircus.io>
In-Reply-To: <87o7nsjck6.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Thu, 13 Apr 2023 12:50:42 +0200
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A9DB186F-5E8C-4731-A5B3-6E30BD47D34E@flyingcircus.io>
References: <57B035ED-1926-4524-8063-EB0A8DB54AF7@flyingcircus.io>
 <CAOQ4uxg6cTF2YnW6anxMxOH_88+JZW+sC9rG468Pjy=XrNEgrQ@mail.gmail.com>
 <6AB6497D-18E5-41C4-B688-4DED6703534F@flyingcircus.io>
 <CAOQ4uxjj2UqA0h4Y31NbmpHksMhVrXfXjLG4Tnz3zq_UR-3gSA@mail.gmail.com>
 <87o7nsjck6.fsf@debian-BULLSEYE-live-builder-AMD64>
To:     Chandan Babu R <chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Amir and Chandan,

much appreciated! I=E2=80=99m building up a history of being a truffle =
pig WRT forgotten fixes. :)

Christian

> On 13. Apr 2023, at 12:31, Chandan Babu R <chandan.babu@oracle.com> =
wrote:
>=20
> On Thu, Apr 13, 2023 at 10:44:43 AM +0300, Amir Goldstein wrote:
>> On Wed, Apr 12, 2023 at 6:58=E2=80=AFPM Christian Theune =
<ct@flyingcircus.io> wrote:
>>>=20
>>> Hi,
>>>=20
>>> ugh. Sorry, looks like I jumped the gun. Mea culpa.
>>>=20
>>> We experienced a hang like this:
>>>=20
>>> Apr 05 11:51:27 kernel: "echo 0 > =
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>> Apr 05 11:51:27 kernel: task:xfs-conv/vdc1   state:D stack:    0 =
pid:  606 ppid:     2 flags:0x00004080
>>> Apr 05 11:51:27 kernel: Workqueue: xfs-conv/vdc1 xfs_end_io [xfs]
>>> Apr 05 11:51:27 kernel: Call Trace:
>>> Apr 05 11:51:27 kernel:  __schedule+0x274/0x870
>>> Apr 05 11:51:27 kernel:  schedule+0x46/0xb0
>>> Apr 05 11:51:27 kernel:  xlog_grant_head_wait+0xc5/0x1d0 [xfs]
>>> Apr 05 11:51:27 kernel:  xlog_grant_head_check+0xde/0x100 [xfs]
>>> Apr 05 11:51:27 kernel:  xfs_log_reserve+0xbe/0x1b0 [xfs]
>>> Apr 05 11:51:27 kernel:  xfs_trans_reserve+0x143/0x180 [xfs]
>>> Apr 05 11:51:27 kernel:  xfs_trans_alloc+0xee/0x1a0 [xfs]
>>> Apr 05 11:51:27 kernel:  xfs_iomap_write_unwritten+0x120/0x2e0 [xfs]
>>> Apr 05 11:51:27 kernel:  ? record_times+0x15/0x90
>>> Apr 05 11:51:27 kernel:  xfs_end_ioend+0xd8/0x140 [xfs]
>>> Apr 05 11:51:27 kernel:  xfs_end_io+0xb8/0xf0 [xfs]
>>> Apr 05 11:51:27 kernel:  process_one_work+0x1b6/0x350
>>> Apr 05 11:51:27 kernel:  rescuer_thread+0x1d1/0x3a0
>>> Apr 05 11:51:27 kernel:  ? worker_thread+0x3e0/0x3e0
>>> Apr 05 11:51:27 kernel:  kthread+0x11b/0x140
>>> Apr 05 11:51:27 kernel:  ? kthread_associate_blkcg+0xb0/0xb0
>>> Apr 05 11:51:27 kernel:  ret_from_fork+0x22/0x30
>>>=20
>>> Which seems to be similar to this:
>>> https://bugs.launchpad.net/bugs/1996269
>>>=20
>>> I followed their patchset here:
>>> https://review.opendev.org/c/starlingx/kernel/+/864257
>>>=20
>>> And I was under the impression that I picked the right one to ask
>>> for backporting, but it seems that was incorrect. I went through the
>>> list again and I think the following patches are the ones missing
>>> from 5.10:
>>>=20
>>> 8182ec00803085354761bbadf0287cad7eac0e2f -
>>> =
https://review.opendev.org/c/starlingx/kernel/+/864257/5/kernel-std/centos=
/patches/0035-xfs-drop-submit-side-trans-alloc-for-append-ioends.patch
>>> edbf1eb9032b84631031d9b43570e262f3461c24 -
>>> =
https://review.opendev.org/c/starlingx/kernel/+/864257/5/kernel-std/centos=
/patches/0036-xfs-open-code-ioend-needs-workqueue-helper.patch
>>> 170e31793806ce5e5a9647b6340954536244518e -
>>> =
https://review.opendev.org/c/starlingx/kernel/+/864257/5/kernel-std/centos=
/patches/0037-xfs-drop-unused-ioend-private-merge-and-setfilesize-.patch
>>> 2fd609b6c90a88630a50fb317473b210759b3873 -
>>> =
https://review.opendev.org/c/starlingx/kernel/+/864257/5/kernel-std/centos=
/patches/0038-xfs-drop-unnecessary-setfilesize-helper.patch
>>>=20
>>=20
>> The only commit that fixes the bug is:
>> 7cd3099f4925 xfs: drop submit side trans alloc for append ioends
>>=20
>> The rest are just code cleanups.
>>=20
>> That fix was missed in my original backports from v5.13 because of a =
tool error,
>> so thank you for pointing it out.
>>=20
>> I have added it to my test branch and will follow up with posting to
>> stable later on.
>>=20
>> Chandan,
>>=20
>> Please make sure you include this fix when you get to considering
>> fixes from v5.13 to 5.4.y.
>>=20
>=20
> Sure, I will do that. However ...
>=20
>> I will wait with posting this fix to 5.10.y until I get the v5.13
>> backports wish list from you.
>>=20
>=20
> Since I am working on another XFS work item there will be some delay =
before I
> share the list of patches to be backported from v5.13 to 5.4.y.
>=20
> --=20
> chandan


Liebe Gr=C3=BC=C3=9Fe,
Christian Theune

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

