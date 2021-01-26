Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC31DC4332D
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 05:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B187230FA
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 05:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731837AbhAZFTb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:19:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbhAZDMt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jan 2021 22:12:49 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4B0C06174A
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 19:12:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
        :CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
        Content-ID:Content-Description:In-Reply-To;
        bh=UT1gHfmBINRvRQwnbKGJDhS/ItnkExDczpWe7GNFNoc=; b=dAsWA2/DpmWIFJ0O4NRom5A6Z1
        48nidtD0I0q+X9yGXRd8LB8V9xLfxt6swI0KvfRbto+dkwkhACz4G/sytrrr3756PP1QRJwimW2p+
        kTfCFuMOzkPwQ2LMaJ/W/Z3SLE4pbFj+HxrlxhyvDlUFlTbsMsOgAHVSE6hcOPr3Fe1WRYtSo4/IQ
        Yg+LqFL5tuBPvKnn0MV5v34OQC1tmHzUl5r1Tb2gghGq/hZOqCWXTzxxPGZqHO+W+kZ0fcM0fiarD
        E5GP0rfjTd+eHsjXTLpotsJQkaMKZTc5Et4jph8XHOjlqK2w3DnOJioW8EjTdu5DkYRf8cHfCPRWi
        NItYDl2Q==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1l4Elw-0004kz-0F; Tue, 26 Jan 2021 03:12:04 +0000
X-Loop: owner@bugs.debian.org
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
Content-Type: text/plain; charset=utf-8
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Andreas Beckmann <anbe@debian.org>
CC:     anarcat@debian.org, linux-xfs@vger.kernel.org,
        pkg-fonts-devel@lists.alioth.debian.org
Subject: Processed: tagging 973061, found 981009 in 4.1.2-1, tagging 890716
Message-ID: <handler.s.C.161163051216392.transcript@bugs.debian.org>
References: <1611630509-462-bts-anbe@debian.org>
X-Debian-PR-Package: charybdis src:xfsprogs src:nototools
X-Debian-PR-Source: charybdis nototools xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date:   Tue, 26 Jan 2021 03:12:03 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Processing commands for control@bugs.debian.org:

> tags 973061 + patch
Bug #973061 [src:nototools] nototools: FTBFS: dpkg-buildpackage: error: dpk=
g-source -b . subprocess returned exit status 2
Added tag(s) patch.
> found 981009 4.1.2-1
Bug #981009 [charybdis] charybdis abandoned upstream, do not ship in bullse=
ye
Marked as found in versions charybdis/4.1.2-1.
> tags 890716 + buster bullseye sid
Bug #890716 {Done: Bastian Germann <bastiangermann@fishpost.de>} [src:xfspr=
ogs] xfsprogs: FTBFS with glibc 2.27: error: conflicting types for 'copy_fi=
le_range'
Added tag(s) bullseye, sid, and buster.
> thanks
Stopping processing here.

Please contact me if you need assistance.
--=20
890716: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D890716
973061: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D973061
981009: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D981009
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
