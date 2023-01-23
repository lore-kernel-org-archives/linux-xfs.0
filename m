Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 321AAC25B50
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Jan 2023 21:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbjAWVNZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 16:13:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbjAWVNZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 16:13:25 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1BE38005
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 13:13:24 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id v6-20020a17090ad58600b00229eec90a7fso173023pju.0
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 13:13:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qUuoRbTPCEy1dUrURF88BK8q0sCN1NEQlYLdurMd3gw=;
        b=oq2mkP2aNzv6Zms+/RdFaa9+WkCYEUJIn2C0bhbllA3rO8owu837D9ZmiXCXGbQlKR
         zOOMGF4WaAFByn6obcziM5Zmy52q8pGgsXT+cjIi471StY4cPLgNPiFsTRebHuIixcRI
         OK9Hpi/+wGwJHkHjkJnwGm3VkFnEyYXkJp3+yaETzuhruRrEY7KB3o/p9QiwzoVtZhBB
         jTc9obhoEqZ0102QfjphADs4YEhWAkvtTyIII4qoH0JEINCWDxfDD/SYNpYG28dPiJT4
         jDCf0Kqw9ZuMPOnLgoem1R8YNvOCj0E0BcvRwsaNin5L9qmsWUSnaGXv4lyFan6LCif5
         VujQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qUuoRbTPCEy1dUrURF88BK8q0sCN1NEQlYLdurMd3gw=;
        b=ISxOcjOo8OdbReYRT9hv8vsQUFB/CujrLUf6kPR2rNdgukCM9xcHXhzuuA5oj+43oq
         Gf+mSAttcqAG1z5FCi7/ckG8wJZOzOBZz3e60rpQo2pWivHaUwlZ75v+RTIx/qHP5rT6
         7SLv0u61Z0B2/Zd6weMvJ+sc+xUuToXSJ5+PBH9cG2lujx0Eo3b6N3h9/oGAsoN47SoS
         QAWELbzt7bCxOK/MwFsP5a0VlrdCXXVzJWSAlAMEl1fnqERoxD4+9RnUNACQ1ZyfPb3+
         U8C0Eaze5X0egB7XqW0xNbUJCy9WzV4IWU1VNh/BSA+TV8sdcXbjKHK1ldYehz31dAPD
         PXXA==
X-Gm-Message-State: AFqh2kp0nYLy3wWTfYxLXM5p06Jb9rYKUVTLPfU4ykdEnNMK2nWPnl99
        9uPNZVrHthsv9jo1lWppwzGNADo+i9AjEGjMbvzEpp4felPlBw==
X-Google-Smtp-Source: AMrXdXuGVEZEFcJPoMAso6j02Hw76t4dvrg4LdyvxUykTpzLABbKY0PsoO/ld/qKS7jzxv0D72ziO5I12B3kIfJIdMM=
X-Received: by 2002:a17:90a:53:b0:226:c6d2:d5d5 with SMTP id
 19-20020a17090a005300b00226c6d2d5d5mr2895616pjb.100.1674508403809; Mon, 23
 Jan 2023 13:13:23 -0800 (PST)
MIME-Version: 1.0
From:   Daan De Meyer <daan.j.demeyer@gmail.com>
Date:   Mon, 23 Jan 2023 22:13:12 +0100
Message-ID: <CAO8sHc=t1nnLrQDL26zxFA5MwjYHNWTg16tN0Hi+5=s49m5Xxg@mail.gmail.com>
Subject: mkfs.xfs protofile and paths with spaces
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

We're trying to use mkfs.xfs's "-p" protofile option for unprivileged
population of XFS filesystems. However, the man page does not specify
how to encode filenames with spaces in them. Spaces are used as the
token delimiter so I was wondering if there's some way to escape
filenames with spaces in them?

Cheers,

Daan De Meyer
