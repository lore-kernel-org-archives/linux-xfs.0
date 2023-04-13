Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EFFFC77B6C
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Apr 2023 07:45:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbjDMHo7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Apr 2023 03:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjDMHo6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2023 03:44:58 -0400
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497E68689
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 00:44:56 -0700 (PDT)
Received: by mail-vs1-xe2e.google.com with SMTP id f10so973451vsv.13
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 00:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681371895; x=1683963895;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jyq/avfF6JvJLnE4KOlQksc+L7pMbFAjARQZVx1BuPU=;
        b=dRp54MqmpP3cdo/Xb82N+tokTlmmJxyfKj5HMt2F8JbKTJrJIeN/okgZtWyQVMuekj
         XC07BnkzsrUs60qAKTFXbi919urdPc2VXWxFDWL5XZ9XvmlkZKheordQp+BMH2voxjR5
         IX1t991kOPEUbmihj6FruwWPmHRFMqt3vihB/Nu8P7A6CzmoyxmQj465KKyd0sL5nh9S
         sw+hhWE/AQUs/4BaEtsECBPQQmnvpwAlDBvNX9u9glsM879PmBxbJ6FSQaBm1BRl/VIr
         nI3XsEc+g3cJHiq3u6pVrBoTDl50aIPnxTnRAx5FsfkNyop1vninzTGfrJOW+2d83FTp
         1jrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681371895; x=1683963895;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jyq/avfF6JvJLnE4KOlQksc+L7pMbFAjARQZVx1BuPU=;
        b=Q1xHUWQCUM1FRD3zwObLwFulcDBLir094cgYl++fCE8VNTP9GiGSv0Q70g5+zRYubf
         RM2kkcOE20M4OW2nqhoetOgzJluUwZv8vSpLexiAURRMi6nDQf4Fz2jCqMuKcZBy/oFP
         DmoUxwZVOvKMcB/NjlFSfDNQ8t0JDxi0zBOO9sOFOnY6ove/wXc+iV2aufEf014+OanN
         3hi7AIZ3PQ3UGLqL7asV+8ldjSPaVYyiK5IEZgARRl4kSZyD94ZlGtTHfBfB9GDQP3da
         hM6jKMSjQK/Rh6yWNswrJxCt11NVO179oEmM99qjWMHg8ForpIK5zeC2iX16moPkUGOX
         VU4Q==
X-Gm-Message-State: AAQBX9frpyFuMOtywk0wc0dcawvb1HOaaePIqISQYMGmpa30A+nQcqo7
        WXb06DASduoXZr8+17XVw209ULC3a/Y8+eWltso=
X-Google-Smtp-Source: AKy350ZGjegCPLnKgDo/VhKpwevt0RJZLddtLYGjqFOdrnA0jjzvZaIwrlVXSA/pmsQ1RvpEvXAle+wVnTDipdZhLz0=
X-Received: by 2002:a67:c00d:0:b0:426:7730:1b89 with SMTP id
 v13-20020a67c00d000000b0042677301b89mr757408vsi.0.1681371894977; Thu, 13 Apr
 2023 00:44:54 -0700 (PDT)
MIME-Version: 1.0
References: <57B035ED-1926-4524-8063-EB0A8DB54AF7@flyingcircus.io>
 <CAOQ4uxg6cTF2YnW6anxMxOH_88+JZW+sC9rG468Pjy=XrNEgrQ@mail.gmail.com> <6AB6497D-18E5-41C4-B688-4DED6703534F@flyingcircus.io>
In-Reply-To: <6AB6497D-18E5-41C4-B688-4DED6703534F@flyingcircus.io>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 13 Apr 2023 10:44:43 +0300
Message-ID: <CAOQ4uxjj2UqA0h4Y31NbmpHksMhVrXfXjLG4Tnz3zq_UR-3gSA@mail.gmail.com>
Subject: Re: Backport of "xfs: open code ioend needs workqueue helper" to 5.10?
To:     Christian Theune <ct@flyingcircus.io>
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Chandan Babu R <chandan.babu@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 12, 2023 at 6:58=E2=80=AFPM Christian Theune <ct@flyingcircus.i=
o> wrote:
>
> Hi,
>
> ugh. Sorry, looks like I jumped the gun. Mea culpa.
>
> We experienced a hang like this:
>
> Apr 05 11:51:27 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs=
" disables this message.
> Apr 05 11:51:27 kernel: task:xfs-conv/vdc1   state:D stack:    0 pid:  60=
6 ppid:     2 flags:0x00004080
> Apr 05 11:51:27 kernel: Workqueue: xfs-conv/vdc1 xfs_end_io [xfs]
> Apr 05 11:51:27 kernel: Call Trace:
> Apr 05 11:51:27 kernel:  __schedule+0x274/0x870
> Apr 05 11:51:27 kernel:  schedule+0x46/0xb0
> Apr 05 11:51:27 kernel:  xlog_grant_head_wait+0xc5/0x1d0 [xfs]
> Apr 05 11:51:27 kernel:  xlog_grant_head_check+0xde/0x100 [xfs]
> Apr 05 11:51:27 kernel:  xfs_log_reserve+0xbe/0x1b0 [xfs]
> Apr 05 11:51:27 kernel:  xfs_trans_reserve+0x143/0x180 [xfs]
> Apr 05 11:51:27 kernel:  xfs_trans_alloc+0xee/0x1a0 [xfs]
> Apr 05 11:51:27 kernel:  xfs_iomap_write_unwritten+0x120/0x2e0 [xfs]
> Apr 05 11:51:27 kernel:  ? record_times+0x15/0x90
> Apr 05 11:51:27 kernel:  xfs_end_ioend+0xd8/0x140 [xfs]
> Apr 05 11:51:27 kernel:  xfs_end_io+0xb8/0xf0 [xfs]
> Apr 05 11:51:27 kernel:  process_one_work+0x1b6/0x350
> Apr 05 11:51:27 kernel:  rescuer_thread+0x1d1/0x3a0
> Apr 05 11:51:27 kernel:  ? worker_thread+0x3e0/0x3e0
> Apr 05 11:51:27 kernel:  kthread+0x11b/0x140
> Apr 05 11:51:27 kernel:  ? kthread_associate_blkcg+0xb0/0xb0
> Apr 05 11:51:27 kernel:  ret_from_fork+0x22/0x30
>
> Which seems to be similar to this:
> https://bugs.launchpad.net/bugs/1996269
>
> I followed their patchset here:
> https://review.opendev.org/c/starlingx/kernel/+/864257
>
> And I was under the impression that I picked the right one to ask for bac=
kporting, but it seems that was incorrect. I went through the list again an=
d I think the following patches are the ones missing from 5.10:
>
> 8182ec00803085354761bbadf0287cad7eac0e2f - https://review.opendev.org/c/s=
tarlingx/kernel/+/864257/5/kernel-std/centos/patches/0035-xfs-drop-submit-s=
ide-trans-alloc-for-append-ioends.patch
> edbf1eb9032b84631031d9b43570e262f3461c24 - https://review.opendev.org/c/s=
tarlingx/kernel/+/864257/5/kernel-std/centos/patches/0036-xfs-open-code-ioe=
nd-needs-workqueue-helper.patch
> 170e31793806ce5e5a9647b6340954536244518e - https://review.opendev.org/c/s=
tarlingx/kernel/+/864257/5/kernel-std/centos/patches/0037-xfs-drop-unused-i=
oend-private-merge-and-setfilesize-.patch
> 2fd609b6c90a88630a50fb317473b210759b3873 - https://review.opendev.org/c/s=
tarlingx/kernel/+/864257/5/kernel-std/centos/patches/0038-xfs-drop-unnecess=
ary-setfilesize-helper.patch
>

The only commit that fixes the bug is:
7cd3099f4925 xfs: drop submit side trans alloc for append ioends

The rest are just code cleanups.

That fix was missed in my original backports from v5.13 because of a tool e=
rror,
so thank you for pointing it out.

I have added it to my test branch and will follow up with posting to
stable later on.

Chandan,

Please make sure you include this fix when you get to considering
fixes from v5.13 to 5.4.y.

I will wait with posting this fix to 5.10.y until I get the v5.13
backports wish list from you.

Thanks,
Amir.
