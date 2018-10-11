Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60244 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726700AbeJKXip (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Oct 2018 19:38:45 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4567B83F3C
        for <linux-xfs@vger.kernel.org>; Thu, 11 Oct 2018 16:10:53 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 54405912AC
        for <linux-xfs@vger.kernel.org>; Thu, 11 Oct 2018 16:10:52 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/2] xfsprogs: enable sparse checking with "make C=[12]"
Message-ID: <5b155482-78db-b58d-13d3-a478f79b1558@redhat.com>
Date: Thu, 11 Oct 2018 11:10:51 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Ok one more pass at this, trying to mimic kernel behavior for C=1 & C=2
