Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55846 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751470AbeBBVpe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Feb 2018 16:45:34 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0F5299090D
        for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2018 21:45:34 +0000 (UTC)
Received: from tgill.bos.csb (unknown [10.18.25.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D4F557D973
        for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2018 21:45:33 +0000 (UTC)
Reply-To: tgill@redhat.com
From: Todd Gill <tgill@redhat.com>
Subject: XFS over device mapper dm-thin device
Message-ID: <147a1764-1988-4efd-4f02-e942a1001b4e@redhat.com>
Date: Fri, 2 Feb 2018 16:45:33 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org


Hi,

I'd like to be able to take a snapshot of an XFS filesystem on top of
dm-thin.

The goal for the snapshot is:

    - fast to complete (couple seconds or better)
    - independent of origin (UUID updated?)
    - read/write

To satisfy the independent goal, I'm updating the UUID on the snapshot.
Currently "xfs_admin -U xxx" takes in the ballpark of 14 seconds on my
test system.

Is there a better approach to achieve the goals?  Or can the UUID update
be changed to be faster?

I realize the filesystem can be mounted with "nouuid" option, but would
prefer to avoid the possible trouble of duplicate UUIDs.

This is a test script I've used to illustrate the time of "xfs_admin -U":

https://pastebin.com/PFA5YRuH

Thanks for any help,
Todd
