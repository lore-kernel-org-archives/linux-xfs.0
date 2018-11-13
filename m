Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50144 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725748AbeKNF46 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Nov 2018 00:56:58 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 85EA9308214B
        for <linux-xfs@vger.kernel.org>; Tue, 13 Nov 2018 19:57:19 +0000 (UTC)
Received: from tgill.bos.csb (unknown [10.18.25.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 29C641DA
        for <linux-xfs@vger.kernel.org>; Tue, 13 Nov 2018 19:57:19 +0000 (UTC)
Reply-To: tgill@redhat.com
From: Todd Gill <tgill@redhat.com>
Subject: file write that exceeds thin device capacity
Message-ID: <18125274-1c2e-6171-a597-4e2ffb165162@redhat.com>
Date: Tue, 13 Nov 2018 14:57:18 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

This script creates a 1 TB thin device (device mapper)  backed by 1 GB
of physical space.  The script then writes more than 1 GB via
$BLOCK_SIZE files to XFS.  I'm testing to see if recovery can be
automated.

https://paste.fedoraproject.org/paste/ropelNyOQWCjk3hfK0jltA

When the $BLOCK_SIZE passed to dd is 4k - dd gets an error on the file
write that exceeds the physical capacity that backs the thin device.
XFS doesn't indicate any problems.

If I set the $BLOCK_SIZE to 32k - I see entries in the system log that
indicate XFS loops retrying the writes.

Is that expected?  Is it just more likely to happen with larger block
sizes?

I’m looking to understand how to recover when a thin device runs out of
space under XFS.

Example system log entries:

[  +5.048997] XFS (dm-3): metadata I/O error: block 0xf0000
("xfs_buf_iodone_callback_error") error 28 numblks 32
[  +1.376913] XFS: Failing async write: 1164 callbacks suppressed
[  +0.000004] XFS (dm-3): Failing async write on buffer block 0xf0020.
Retrying async write.

Thanks for any help,
Todd
