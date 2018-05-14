Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48486 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752754AbeENRah (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 May 2018 13:30:37 -0400
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.25])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4ACD230024D5
        for <linux-xfs@vger.kernel.org>; Mon, 14 May 2018 17:30:37 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 186EC20D8804
        for <linux-xfs@vger.kernel.org>; Mon, 14 May 2018 17:30:37 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2 0/5] xfs: online label
Message-ID: <5957a0ff-0fd7-c1f3-2d44-86b825c2eb3b@redhat.com>
Date: Mon, 14 May 2018 12:30:36 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

resend of the whole series; broke out btrfs changes from vfs change
(can send btrfs changes (much) later), made my own backup super update
function to just avoid collision with dchinner, and changed the max length
handling a bit so we don't have 256-byte arrays on the stack.

xfs list only for now 'cause I probably did something wrong in xfs land
and don't want to subject everyone else to it.  ;)

Thanks,
-Eric
