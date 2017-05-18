Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36168 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754347AbdEROWC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 May 2017 10:22:02 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6788D3D962
        for <linux-xfs@vger.kernel.org>; Thu, 18 May 2017 14:22:02 +0000 (UTC)
Received: from eorzea.usersys.redhat.com (ovpn-204-238.brq.redhat.com [10.40.204.238])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CC5C2187BA
        for <linux-xfs@vger.kernel.org>; Thu, 18 May 2017 14:22:01 +0000 (UTC)
Date: Thu, 18 May 2017 16:21:59 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Do we need a way to force xfsaild to run?
Message-ID: <20170518142159.gkr6be4dralc6xiq@eorzea.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

This is something I was thinking while working on that buffer retry stuff.

Currently, we have no way to force xfsaild to run, and I was wondering if
somebody has any opinion if it would be useful to create a new xfsctl, to start
xfsaild for debugging purposes, using xfs_io to trigger it.

My specific use case is while testing the code I've been working on for the
buffer retry stuff, where, I need to wait xfsaild to run to trigger the bug,
adding a way to force it, in this case at least, would be useful for me, I could
work on that, but only if somebody else can actually think this to be
interesting, adding a new xfsctl just for 'me' does not sound worth the time :)

Anybody else might have interest on it or maybe this is just a waste of time?

Cheers

-- 
Carlos
