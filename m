Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E90ACA9EA0
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 09:17:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FF16204FD
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 09:17:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="U9x61/dh";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Qxy8n+X1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731330AbfJ1JRN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 05:17:13 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:48913 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727664AbfJ1JRN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 05:17:13 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 5901E3D1;
        Mon, 28 Oct 2019 05:17:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 28 Oct 2019 05:17:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:content-type:mime-version
        :content-transfer-encoding; s=fm1; bh=CI9R3qxJOOQM/goHpbsUj4REKR
        FcLBM7UPQvsSV6Eog=; b=U9x61/dhHrZ92eS0JOhpskWwwQZm8iuZsSLikfhana
        LVEDxvlcXYm+LJoxQ4UFRZrpPlJbkO/9ihRJfWLBZFyAEEyeaIjSt1opcWdEFljq
        EQRsj48nop+JKYbQ6JOvfLk4whR/lsgo0S/R6e1Zm2WKwOUvCM6tuuS4NaW7NWA5
        mHxNYrI+Fhx8bw50F/OZ1nj8hLLjMAUx9hbWB0W1OzKtXDuAXeh8spD4vwLvarHz
        EZbPab3waAaoJS5TS3f/RhwkYd7l6E33KhK8AXTF4ZqARCPUSO5icrefhrkoRsAv
        IeHAmUIDgMR3hDjd2fW7EKjZaIc/hC8rvwBCyVIdXDIg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=CI9R3q
        xJOOQM/goHpbsUj4REKRFcLBM7UPQvsSV6Eog=; b=Qxy8n+X1IIJeqZdOKePCia
        YJOsPiEE6y6EOOxf53BF/3QjyIG0JQNuID2HGwn/yG3zAPZkdMLv2+9a7/2GDaN2
        ALdRCIihE5HKVQ1GT4E3uSI2UCr1ThP38d/ZlL7n2Zs1M8I3gnHMVB7gLOUSlE9l
        4rQ9h+8phFEn8WEi6t2pW2jWSo5gwIG/2Q2Iysdfxp+svT0tA4rGtgdCAW0Uo2mA
        nLrd7uGSy7rARC6q7JcD5R+bUC202xdNmiItHdV1HjcB3FZthLhWKFLdDs8m+DZv
        qFQemwr046Be7AvJihEeqgbwjhgcGlKEsokohu4ZfvqZSy063o+jRw+wzWQ3iteA
        ==
X-ME-Sender: <xms:F7K2XShwpd8sXetWBw92c1v9Eu0HrSwZ2b5ObvE_VLJfyo4KZiN5wA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrleelgddtvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvffftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfmvghn
    thcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdekrdduke
    ejrdefvdenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgifrdhn
    vghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:F7K2XSPM38B-IcUCEwwakNlI1fMb4YJPBq-GZJ1bK6Kel6OFkq1dQg>
    <xmx:F7K2XczHJnjAik6j2ICEkZmBFMkTkdrlvhyArP4fN7TZksXjq7uhYw>
    <xmx:F7K2XUqTZeBrytMQatjb8gRIaHUAzOjaHUjcvQU6KwB9oSbfcpHH7w>
    <xmx:F7K2Xd4tm4gRWa81C7-DVvNzUdvHiNn0O9hA7_kzJRtCH_SUcQG0rQ>
Received: from mickey.themaw.net (unknown [118.208.187.32])
        by mail.messagingengine.com (Postfix) with ESMTPA id D291980059;
        Mon, 28 Oct 2019 05:17:09 -0400 (EDT)
Message-ID: <1d94634d5c990dc0d21673ff2596bd276b728ab1.camel@themaw.net>
Subject: About xfstests generic/361
From:   Ian Kent <raven@themaw.net>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 28 Oct 2019 17:17:05 +0800
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

Unfortunately I'm having a bit of trouble with my USB keyboard
and random key repeats, I lost several important messages this
morning due to it.

Your report of the xfstests generic/361 problem was one of them
(as was Christoph's mail about the mount code location, I'll post
on that a bit later). So I'm going to have to refer to the posts
and hope that I can supply enough context to avoid confusion.

Sorry about this.

Anyway, you posted:

"Dunno what's up with this particular patch, but I see regressions on
generic/361 (and similar asserts on a few others).  The patches leading
up to this patch do not generate this error."

I've reverted back to a point more or less before moving the mount
and super block handling code around and tried to reproduce the problem
on my test VM and I din't see the problem.

Is there anything I need to do when running the test, other have
SCRATCH_MNT and SCRATCH_DEV defined in the local config, and the
mount point, and the device existing?

This could have been a problem with the series I posted because
I did have some difficulty resolving some conflicts along the
way and may have made mistakes, hence reverting to earlier patches
(but also keeping the recent small pre-patch changes).

Ian

