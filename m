Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53754 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752116AbdHASDJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Aug 2017 14:03:09 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 93212317E31
        for <linux-xfs@vger.kernel.org>; Tue,  1 Aug 2017 18:03:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 846597B5BF
        for <linux-xfs@vger.kernel.org>; Tue,  1 Aug 2017 18:03:09 +0000 (UTC)
Received: from zmail17.collab.prod.int.phx2.redhat.com (zmail17.collab.prod.int.phx2.redhat.com [10.5.83.19])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 768D11800C82
        for <linux-xfs@vger.kernel.org>; Tue,  1 Aug 2017 18:03:09 +0000 (UTC)
Date: Tue, 1 Aug 2017 14:03:09 -0400 (EDT)
From: Carlos Eduardo Maiolino <cmaiolin@redhat.com>
Message-ID: <279145482.64195202.1501610589350.JavaMail.zimbra@redhat.com>
In-Reply-To: <1623985894.64195188.1501610564587.JavaMail.zimbra@redhat.com>
Subject: kexec / crash tool buggy with 4.13
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

just in case it can save some time from anybody else trying to work on a vmcore from kernel 4.13

Kexec and crash tools are not able to handle kernel 4.13 now due a change in kernel that affected kdump and its relatives.

Cheers.

-- 
--Carlos
