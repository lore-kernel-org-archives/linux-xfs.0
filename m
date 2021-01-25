Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A66C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 23:23:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA187227BF
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 23:23:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732273AbhAYXWY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Jan 2021 18:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732293AbhAYXVu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jan 2021 18:21:50 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE68C061574
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 15:21:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
        :CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
        Content-ID:Content-Description:In-Reply-To;
        bh=yePgnAQ1J5mCuaVrZmrl9egXFgFfczFL/B8LDIc2GrA=; b=TWNKrkzNvkGwcn78Qi3tpH15xd
        u7meHHvPpMlhb7xpfZJoCTLb6xYCUa/4hxZqbeFG37N4XJe7WdVHgDyR6wQv0A/cn00qmdd+x3Sl/
        EWmI9OhVnIfHHBI5QNNNkyJRyy3MA2kKp/NHLXgfpLAAbJuvs6Sg2fyF4TRHi24j6z+YbY8iosHPR
        f0gi4P9DyNgURkd1TKfeZ9JnxTGYBkwcM60hRp9wwmkzNZXFD0PNglPaV8tS2iWnuTfYfED39/oqJ
        pYl6PCTvJfg67bPhmWolbB7BKeOM48iMLdWwOYYjnS2JOGORI5Q38ZMSH6230gEcT0HyECoKHIkk5
        hNhyhp/w==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1l4BAR-0003N3-NQ; Mon, 25 Jan 2021 23:21:07 +0000
X-Loop: owner@bugs.debian.org
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
Content-Type: text/plain; charset=utf-8
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
CC:     linux-xfs@vger.kernel.org, debian-bugs-closed@lists.debian.org
Subject: Processed: update some xfsprogs bugs
Message-ID: <handler.s.C.161161667511525.transcript@bugs.debian.org>
References: <ee0bfaad-bfbb-65ff-54a2-a674fc005a42@fishpost.de>
X-Debian-PR-Package: src:xfsprogs xfsprogs xfslibs-dev
X-Debian-PR-Source: xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date:   Mon, 25 Jan 2021 23:21:07 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Processing commands for control@bugs.debian.org:

> tags 860546 confirmed
Bug #860546 [xfsprogs] xfsprogs: xfs_fsr returns success (zero) on failure
Added tag(s) confirmed.
> found 860546 5.6.0-1
Bug #860546 [xfsprogs] xfsprogs: xfs_fsr returns success (zero) on failure
Marked as found in versions xfsprogs/5.6.0-1.
> tags 905052 confirmed
Bug #905052 [xfslibs-dev] xfslibs-dev: broken symlink: /lib/libhandle.a -> =
/usr/lib/libhandle.a
Added tag(s) confirmed.
> close 638158
Bug #638158 [xfsprogs] xfsprogs: Damaged filesystem causes xfs_repair to so=
metimes (but not always) segfault
Marked Bug as done
> tags 897387 wontfix
Bug #897387 [xfslibs-dev] xfslibs-dev needs to include .la files
Added tag(s) wontfix.
> close 757455
Bug #757455 [src:xfsprogs] please run dh_autoreconf or manually update m4/l=
ibtool.m4 for ppc64el
Marked Bug as done
> tags 694624 patch
Bug #694624 [xfsprogs] /usr/sbin/xfs_freeze: freezes under lying (root) fil=
esystem if mountpoint is not currently mounted
Added tag(s) patch.
>
End of message, stopping processing here.

Please contact me if you need assistance.
--=20
638158: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D638158
694624: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D694624
757455: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D757455
860546: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D860546
897387: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D897387
905052: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D905052
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
