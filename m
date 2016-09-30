Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36958 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751321AbcI3Uu6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Sep 2016 16:50:58 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8D97510550
        for <linux-xfs@vger.kernel.org>; Fri, 30 Sep 2016 20:50:58 +0000 (UTC)
Received: from Liberator.example.com (ovpn03.gateway.prod.ext.phx2.redhat.com [10.5.9.3])
        by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u8UKovsK002513
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-xfs@vger.kernel.org>; Fri, 30 Sep 2016 16:50:58 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/5] xfs_io: address various "inode" command issues
Message-ID: <9f126dc7-3b1e-a1ed-7f23-48410a76adc2@redhat.com>
Date: Fri, 30 Sep 2016 15:50:58 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

With these 5 patches the fstest I sent yesterday will
pass.

A lot of it is code re-org, but there a couple small bugs
resolved as well.
