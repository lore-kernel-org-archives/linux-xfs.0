Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B856C77B6E
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 13:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbjDLNzm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 09:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbjDLNzk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2023 09:55:40 -0400
X-Greylist: delayed 540 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 12 Apr 2023 06:55:35 PDT
Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7F46A40
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 06:55:34 -0700 (PDT)
From:   Christian Theune <ct@flyingcircus.io>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
        s=mail; t=1681307189;
        bh=VmmAQWvTf3M0/vf1bg2Ix3FaOwnqEF0xC58sRaYXIdY=;
        h=From:Subject:Date:Cc:To;
        b=Hq7CVmGJuj07Ez33kbuqIjqvLpnn5Xft9W4f/n2hQu6ka8zyzIb0SzXRcO0ShDgCx
         PRyjQeTSt8XAuijjxce94rMMVXwc33iPfyfmK9i0Lu5hHgn5NhHxk5/DHF2JYRokTI
         GHxAyG84tx+aV0MGZdEXLZIhK0HDEKGcEzhpSS8Q=
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Backport of "xfs: open code ioend needs workqueue helper" to 5.10?
Message-Id: <57B035ED-1926-4524-8063-EB0A8DB54AF7@flyingcircus.io>
Date:   Wed, 12 Apr 2023 15:46:09 +0200
Cc:     Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

afaict this was fixed in 5.13 but hasn=E2=80=99t been backported. I=E2=80=99=
ve seen one of our VMs running 5.10.169 crash with this.

Anybody willing to backport this? It=E2=80=99s only triggered a single =
time so far and we are rolling out 5.15 anyways, but maybe this was an =
oversight =E2=80=A6 ?

commit 7adb8f14e134d5f885d47c4ccd620836235f0b7f
Author: Brian Foster <bfoster@redhat.com>
Date:   Fri Apr 9 10:27:55 2021 -0700

    xfs: open code ioend needs workqueue helper
   =20
    Open code xfs_ioend_needs_workqueue() into the only remaining
    caller.
   =20
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Darrick J. Wong <djwong@kernel.org>
    Signed-off-by: Darrick J. Wong <djwong@kernel.org>


Kind regards,
Christian

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

