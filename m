Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41130 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750747AbeDDE3W (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Apr 2018 00:29:22 -0400
Subject: Re: [PATCH] xfs: factor out xfs_dquot_verify_crc for use in
 quotacheck rebuild
References: <42e7adc1-9fa5-e606-000e-f8a89494c97c@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7578ff12-6f63-bf8b-f1fd-fbb114d5faa6@sandeen.net>
Date: Tue, 3 Apr 2018 23:29:19 -0500
MIME-Version: 1.0
In-Reply-To: <42e7adc1-9fa5-e606-000e-f8a89494c97c@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 4/3/18 5:19 PM, Eric Sandeen wrote:
> Today, if a quota block has a bad UUID or CRC, it will never get
> rebuilt or repaired.
> 
> xfs_repair does not check or validate quota blocks, leaving that task
> to in-kernel quotacheck.  In-kernel quotacheck does not validate the
> UUID or CRC.  So the problem remains indefinitely.
> 
> To remedy this:
> 
> * Factor out xfs_dquot_verify_crc from xfs_dquot_buf_verify_crc
> * Call this new function from xfs_qm_reset_dqcounts for V5 fs
> 
> If an invalid UUID or CRC is found, this will trigger xfs_dquot_repair
> which rewrites them.
> 
> Also, since xfs_dquot_repair() operates on the disk block, just
> send that in directly since we have it handy.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Actually don't bother with this one just yet, working on a V2 that
deals with UUIDs directly and doesn't wrap it up in the CRC check
(which doesn't quite make sense logically ... I think)

-Eric
