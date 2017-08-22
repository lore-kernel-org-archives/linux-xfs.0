Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55684 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751145AbdHVVLZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 Aug 2017 17:11:25 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B523281DF6
        for <linux-xfs@vger.kernel.org>; Tue, 22 Aug 2017 21:11:25 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 87C23614D3
        for <linux-xfs@vger.kernel.org>; Tue, 22 Aug 2017 21:11:25 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/3] libxfs: tidy up cvtnum junk
Message-ID: <2b5a5742-5343-671f-8b89-9d1dc9841c17@redhat.com>
Date: Tue, 22 Aug 2017 16:11:24 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

We have many many patterns like:

int	blocksize, sectorsize;

cvtnum_init(&blocksize, &sectorsize);
cvtnum(blocksize, sectorsize, arg);

where cvtnum_init simply copies filesystem geometry
into those 2 local vars.

Instead, I propose a new wrapper, io_cvtnum(arg) which
just looks to the global file->geom to get these values.
