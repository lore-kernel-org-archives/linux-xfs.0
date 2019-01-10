Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt1-f174.google.com ([209.85.160.174]:41702 "EHLO
        mail-qt1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728843AbfAJOaD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Jan 2019 09:30:03 -0500
Message-ID: <1547130601.20294.152.camel@intricatesoftware.com>
Subject: Block device flush ordering
From: Kurt Miller <kurt@intricatesoftware.com>
Date: Thu, 10 Jan 2019 09:30:01 -0500
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

For a well behaved block device that has a writeback cache,
what is the proper behavior of flush when there are more
then one outstanding flush operations? Is it;

Flush all writes seen since the last flush.
or
Flush all writes received prior to the flush including
those before any prior flush.

For example take the following order of requests presented
to the block device:

	writes 1-5
	flush 1
	write 6
	flush 2

Can flush 2 finish with success as soon as write 6 is flushed
(which may be before flush 1 success)? Or must it wait for
all prior write operations to flush (writes 1-6)?

This question has come up in our implementation of an NBD
user-space block device and have not found a definitive answer
on which behavior is correct for us to conform to. We want to
ensure we behave as required for file-system commit write
ordering.

Best,
-Kurt
