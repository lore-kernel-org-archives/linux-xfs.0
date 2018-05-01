Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41786 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751441AbeEAXEe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 May 2018 19:04:34 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id A141232541C
        for <linux-xfs@vger.kernel.org>; Tue,  1 May 2018 18:03:20 -0500 (CDT)
Subject: Re: [PATCH 3/5] xfs: move xfs_scrub_checkpoint_log to
 xfs_log_checkpoint for general use
From: Eric Sandeen <sandeen@sandeen.net>
References: <eb592fc3-3165-5ec7-3896-b798fc7f6502@redhat.com>
 <c57f7f1e-f5f5-56f3-b85c-4c8f6edfba0c@sandeen.net>
Message-ID: <3687ef75-3895-8f60-5342-f90e33c238f1@sandeen.net>
Date: Tue, 1 May 2018 18:04:33 -0500
MIME-Version: 1.0
In-Reply-To: <c57f7f1e-f5f5-56f3-b85c-4c8f6edfba0c@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

On 4/30/18 10:45 AM, Eric Sandeen wrote:
> The upcoming online label patch will require forcing the superblock
> change from the log to the actual on-disk superblock, so move this log
> checkpoint function out for general use.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

self-nak / drop this one, not needed now.

-Eric
