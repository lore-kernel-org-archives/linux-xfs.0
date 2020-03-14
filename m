Return-Path: <SRS0=0KAm=5A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=3.0 tests=DATE_IN_PAST_12_24,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40A30C0044D
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Mar 2020 03:36:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE77D20722
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Mar 2020 03:36:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=firstfloor.org header.i=@firstfloor.org header.b="q8xBibNa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgCODgR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 14 Mar 2020 23:36:17 -0400
Received: from one.firstfloor.org ([193.170.194.197]:51632 "EHLO
        one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbgCODgR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Mar 2020 23:36:17 -0400
X-Greylist: delayed 4197 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Mar 2020 23:36:16 EDT
Received: by one.firstfloor.org (Postfix, from userid 503)
        id F1E6D8684B; Sat, 14 Mar 2020 14:31:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=firstfloor.org;
        s=mail; t=1584192671;
        bh=C2RNaFhCHgKZpE/OjgJh9gA9hkLbcFUSj2UYtde6eb8=;
        h=Date:From:To:Subject:From;
        b=q8xBibNaDl1NkDj5foIvjjjtJQpUZhoNlgg55KJYDpqXF6n2YdXNBKVG7wQhVRQTM
         pdarqevWbSAMCd4jiowFTXm9wQY+SYemGzExE3GjoqrIRXsFuPxju81j6O+yZpXvjs
         /lD9nTOuBGL/0CNLunBpwOcL4IqowWeRAubgyCp4=
Date:   Sat, 14 Mar 2020 06:31:10 -0700
From:   Andi Kleen <andi@firstfloor.org>
To:     linux-xfs@vger.kernel.org
Subject: Shutdown preventing umount
Message-ID: <20200314133107.4rv25sp4bvhbjjsx@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


Hi,

I had a cable problem on a USB connected XFS file system, triggering 
some IO errors, and the result was that any access to the mount point
resulted in EIO. This prevented unmounting the file system to recover
from the problem. 

I also tried xfs_io with shutdown -f, but it had the same problem
because xfs_io couldn't access anything on the file system.

How is that supposed to work? Having to reboot just to recover
from IO errors doesn't seem to be very available.

I don't think shutdown should prevent unmounting.

From googling I found some old RHEL bugzilla that such a problem
was fixed in some RHEL release. Is that a regression? 

This was on a 5.4.10 kernel.

I got lots of:

 XFS (...): metadata I/O error in "xfs_trans_read_buf_map" at daddr
 0x4a620288 len 8 error 5

Then some

XFS (...): writeback error on sector 7372099184

And finally:

XFS (...): log I/O error -5
 XFS (...): xfs_do_force_shutdown(0x2)
called from line 1250 of file fs/xfs/xfs_log.c. Return address =
00000000f7956130
XFS (...): Log I/O Error Detected.
Shutting down filesystem
XFS (...): Please unmount the filesystem
and rectify the problem(s)

(very funny XFS!)

XFS (...): log I/O error -5

scsi 7:0:0:0: rejecting I/O to dead device

-Andi
