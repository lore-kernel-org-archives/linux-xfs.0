Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADFEAC3524F
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 06:40:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83E402082E
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 06:40:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bIeVYP9Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725385AbgBEGkr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Feb 2020 01:40:47 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:45906 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgBEGkr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Feb 2020 01:40:47 -0500
Received: by mail-io1-f68.google.com with SMTP id i11so859036ioi.12;
        Tue, 04 Feb 2020 22:40:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ps49yErJSGLxuDdumQjkw++0jVSap89fdxSUrxe19J0=;
        b=bIeVYP9QD9+yi6kH8sAPAGGCN6jtIKBznIinQ3ixnS4h+WM0OkVEXCIwTj4Kw4UB2L
         /xFAJrgmuVlXiSneeUIV+ZZdGcIU+dNlqUYpm5DlQB5snPBRpZQusf30u7xZpsrxwxfV
         /FPgRBrqquygD/w3mSWMgNGajM/yJfZaGKPVuvEx84qtDD9lPia8jF+p7Xa1Swkk7Z8q
         RPVsR8JVIOeBS3sQ5VI48aBHYavN+n055eAq/WVV64scmVW3gu2KJ2HFYLNM4T6ppsfr
         R5JSByK45ONXCPacSIx/AbGIw1ykw6KnuJK2sJemJgvcnJVXk2LvKayYx/viUChjvbPa
         UM8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ps49yErJSGLxuDdumQjkw++0jVSap89fdxSUrxe19J0=;
        b=lSniGW/f24RxYTqb440CxGpfNw+0DjxEdClPDg4ddjpF8jcfQ+tTNdYULvhgxnLYki
         /FRVsKNZA2PSk70m0NLnXQ95gu5BvnuosBGo0UiQHtcY8SohQ2905FlM8IwFTFBW6LsM
         X0Y/ASjyV9sYcwnlGzOxCU1pvFzN32fsCol2IY2u94l7y+1ScHdMGqJAEUWwSUtm/Ebi
         URm/QSCjmndDFQ9PjwDM7M6DF5K65UziLVFuK4/xmbn8JqAlT+MqIojQE570244V0o+2
         DEr6IP/94c3ueKcoohdUqAjFUAcoKQYfDlLtTi6vFy0UDrC7OIeAGwUBs/GKTcOKo/dn
         lszA==
X-Gm-Message-State: APjAAAUC50G8/pv6vvf39pz7dfc68nBJAKfupoUxxIirCEVqjtqfmfTY
        3VYDrLd4KMilfhljfaJHYlnjC2WCPGr4oWQsXew=
X-Google-Smtp-Source: APXvYqw5vC2dY/TnotFfjq/Kzx5GD0Y1NwOa31h5QMSNnkDDBPYInflsxJdDRpzuaX5tiGwM1OKp3mRQXRgX+M4w3UY=
X-Received: by 2002:a02:81cc:: with SMTP id r12mr26599392jag.93.1580884846619;
 Tue, 04 Feb 2020 22:40:46 -0800 (PST)
MIME-Version: 1.0
References: <158086094707.1990521.17646841467136148296.stgit@magnolia> <158086095935.1990521.3334372807118647101.stgit@magnolia>
In-Reply-To: <158086095935.1990521.3334372807118647101.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 5 Feb 2020 08:40:35 +0200
Message-ID: <CAOQ4uxi5i-iTZG7+BgybvS7SQqat94k5jQXUK2LW-9iDf2NgnQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] xfs: test setting labels with xfs_admin
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 5, 2020 at 2:02 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Test setting filesystem labels with xfs_admin.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/912     |  103 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/912.out |   43 ++++++++++++++++++++++
>  tests/xfs/group   |    1 +
>  3 files changed, 147 insertions(+)
>  create mode 100755 tests/xfs/912
>  create mode 100644 tests/xfs/912.out
>
>
> diff --git a/tests/xfs/912 b/tests/xfs/912
> new file mode 100755
> index 00000000..1eef36cd
> --- /dev/null
> +++ b/tests/xfs/912
> @@ -0,0 +1,103 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test No. 912
> +#
> +# Check that xfs_admin can set and clear filesystem labels offline and online.
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +       cd /

odd cleanup.
I think the standard rm tmp files is needed for in-case common
helpers generate tmp files.

> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +_require_scratch
> +_require_xfs_db_command label
> +_require_xfs_io_command label
> +grep -q "xfs_io" "$(which xfs_admin)" || \
> +       _notrun "xfs_admin does not support online label setting of any kind"

odd test. If it cannot be prettier than than perhaps hide this inside
a _require helper?

> +
> +rm -f $seqres.full
> +
> +echo
> +echo "Format with label"
> +_scratch_mkfs -L "label0" > $seqres.full
> +
> +echo "Read label offline"
> +_scratch_xfs_admin -l
> +
> +echo "Read label online"
> +_scratch_mount
> +_scratch_xfs_admin -l
> +
> +echo
> +echo "Set label offline"
> +_scratch_unmount
> +_scratch_xfs_admin -L "label1"
> +
> +echo "Read label offline"
> +_scratch_xfs_admin -l
> +
> +echo "Read label online"
> +_scratch_mount
> +_scratch_xfs_admin -l
> +
> +echo
> +echo "Set label online"
> +_scratch_xfs_admin -L "label2"
> +
> +echo "Read label online"
> +_scratch_xfs_admin -l
> +
> +echo "Read label offline"
> +_scratch_unmount
> +_scratch_xfs_admin -l
> +
> +echo
> +echo "Clear label online"
> +_scratch_mount
> +_scratch_xfs_admin -L "--"
> +
> +echo "Read label online"
> +_scratch_xfs_admin -l
> +
> +echo "Read label offline"
> +_scratch_unmount
> +_scratch_xfs_admin -l
> +
> +echo
> +echo "Set label offline"
> +_scratch_xfs_admin -L "label3"
> +
> +echo "Read label offline"
> +_scratch_xfs_admin -l
> +
> +echo
> +echo "Clear label offline"
> +_scratch_xfs_admin -L "--"
> +
> +echo "Read label offline"
> +_scratch_xfs_admin -l
> +
> +echo "Read label online"
> +_scratch_mount
> +_scratch_xfs_admin -l
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/912.out b/tests/xfs/912.out
> new file mode 100644
> index 00000000..186d827f
> --- /dev/null
> +++ b/tests/xfs/912.out
> @@ -0,0 +1,43 @@
> +QA output created by 912
> +
> +Format with label
> +Read label offline
> +label = "label0"
> +Read label online
> +label = "label0"
> +
> +Set label offline
> +writing all SBs
> +new label = "label1"
> +Read label offline
> +label = "label1"
> +Read label online
> +label = "label1"
> +
> +Set label online
> +label = "label2"
> +Read label online
> +label = "label2"
> +Read label offline
> +label = "label2"
> +
> +Clear label online
> +label = ""
> +Read label online
> +label = ""
> +Read label offline
> +label = ""
> +
> +Set label offline
> +writing all SBs
> +new label = "label3"
> +Read label offline
> +label = "label3"
> +
> +Clear label offline
> +writing all SBs
> +new label = ""
> +Read label offline
> +label = ""
> +Read label online
> +label = ""
> diff --git a/tests/xfs/group b/tests/xfs/group
> index edffef9a..898bd9e4 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -512,3 +512,4 @@
>  512 auto quick acl attr
>  747 auto quick scrub
>  748 auto quick scrub
> +912 auto quick label
>
