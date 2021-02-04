Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DEB9C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 22:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C13B164FAC
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 22:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhBDWdu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Feb 2021 17:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbhBDWds (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Feb 2021 17:33:48 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F41E8C0613D6
        for <linux-xfs@vger.kernel.org>; Thu,  4 Feb 2021 14:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
        :CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
        Content-ID:Content-Description:In-Reply-To;
        bh=G4DtHgK0CRyU6pnHvH3QyR0fwGjehUhzMxYZAeHtjek=; b=SFcu3P1pEeBCEd4B6jkpF0O4zt
        xCPw7uL2cWfP7/DuuNqXUTX0O3C6yg2TF7bI8LoVBUcGh+nlOHEtVf1EW3Cph8Ev6JCWd17NbEczZ
        5OmDup6uy6apX9hpnEhX7+5CnN7FacvKLPJjOM8fkeXOlQN5WKoDtwakEExxQwAUCBTJr0UZaucm0
        l+2KRdGhohnrHs8LmmA87qtdP0BYBjK77kbzd6rV3mmRwVUzvXAxEy87JxduGRDoBbNbEvuLvB83u
        U0GRKs21zIaIJKvZds5JeTmFXdSone/wG7LujmljrcFQX74XwWMmlAFW+2chE6KMdBF/0FEzgqqxt
        c3YjRe2A==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1l7nBT-0003o8-3e; Thu, 04 Feb 2021 22:33:07 +0000
X-Loop: owner@bugs.debian.org
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
Content-Type: text/plain; charset=utf-8
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
CC:     linux-xfs@vger.kernel.org
Subject: Processed: xfsprogs: confirm issues
Message-ID: <handler.s.C.161247773813500.transcript@bugs.debian.org>
References: <90d9e92f-1e19-0ba4-5467-73c78d161eb4@fishpost.de>
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Source: xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date:   Thu, 04 Feb 2021 22:33:07 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Processing commands for control@bugs.debian.org:

> tags 484069 confirmed
Bug #484069 [xfsprogs] xfsdump: cronscript to run xfs_fsr
Added tag(s) confirmed.
> tags 528356 confirmed
Bug #528356 [xfsprogs] xfsprogs: xfs_admin assumes that xfs_db is in the PA=
TH
Added tag(s) confirmed.
> tags 570704 confirmed
Bug #570704 [xfsprogs] duplicate /usr/share/doc/xfsprogs/changelog{,.Debian=
}.gz
Added tag(s) confirmed.
> tags 915124 confirmed
Bug #915124 [xfsprogs] xfsprogs: frequent misdetection of atari partition t=
ype
Added tag(s) confirmed.
> tags 293275 confirmed
Bug #293275 [xfsprogs] xfsprogs: no-op fsck.xfs doesn't allow to explicitly=
 check with shutdown -F
Bug #525132 [xfsprogs] forced fsck did not find and repair FS problems
Bug #904086 [xfsprogs] Add fsck.xfs and xfs_repair to the initramfs
Added tag(s) confirmed.
Added tag(s) confirmed.
Added tag(s) confirmed.
> tags 518637 confirmed
Bug #518637 [xfsprogs] xfsprogs: xfs_admin -c1 fails with unhelpful error m=
essage
Added tag(s) confirmed.
>
End of message, stopping processing here.

Please contact me if you need assistance.
--=20
293275: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D293275
484069: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D484069
518637: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D518637
525132: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D525132
528356: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D528356
570704: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D570704
904086: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D904086
915124: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D915124
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
