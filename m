Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:50235 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751554AbeBZWzB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Feb 2018 17:55:01 -0500
Received: by mail-it0-f67.google.com with SMTP id a75so12825176itd.0
        for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2018 14:55:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180226224330.GC19318@magnolia>
References: <20180226224330.GC19318@magnolia>
From: Nathan Scott <nathans@redhat.com>
Date: Tue, 27 Feb 2018 09:55:00 +1100
Message-ID: <CAFMei7NAXrbi3DPwVijo8us1KWex9NfxwZVy+umOHKx-dTC59w@mail.gmail.com>
Subject: Re: [PATCH] debian: don't fail postinst when upgrading chroot
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Tue, Feb 27, 2018 at 9:43 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> If we're upgrading a systemd-enabled chroot we'll fail because systemctl
> can't connect to a running systemd (nor should it).  We don't need to
> issue daemon-reload inside a chroot that doesn't have a running systemd,
> so we can ignore the return value.

LGTM.

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Nathan Scott <nathans@debian.org>

cheers.

--
Nathan
