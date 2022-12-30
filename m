Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06905C10F1B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 21:14:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235566AbiL3VO3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 16:14:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbiL3VO2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 16:14:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965911C40D;
        Fri, 30 Dec 2022 13:14:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53688B81B92;
        Fri, 30 Dec 2022 21:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E344C433EF;
        Fri, 30 Dec 2022 21:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672434865;
        bh=1BI7e5iCN+fE/llwnMT6wLlx2hfwSAiAWz+JVHB5au4=;
        h=Date:From:To:Cc:Subject:From;
        b=OMAjaCY1sFXw7qlvP48R1hiMgZr1CUslUMSVTf4OQWLZXSV5G04joTun9SrNhphN0
         xxJqHAJ4tSnXfMdC0lrohHxZUbf4QwlErLH7sfKmEvRqs8WE52NvXywoEgiJ4Kb+J5
         SEOCgaaJVj2YS0UNRMVAXretJAkCYGSsy9yM9u2EKUc2OuGyOTNO5TK/U8ytGTX4N8
         T4x5ulmoCrqW6+bFO+ktb5TJlDTz+bMTnNQCBE0fHKvCRUguIsvxkm6yLZIxMZETpd
         x2u96zWUomi8/8s8hhmFVF9z7JzIDfDVvP4Urg0tuMMbfxu8beaBHikNhLnH+wv06V
         AkUtUAJY7Do2Q==
Date:   Fri, 30 Dec 2022 13:14:24 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
Subject: [NYE DELUGE 3/4] xfs: modernize the realtime volume
Message-ID: <Y69UsO7tDT3HcFri@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This third patchset deluge is for the realtime modernization project.
There are five main parts to this effort -- adding a metadata directory
tree; sharding the realtime volume into allocation groups to reduce
metadata lock contention; adding reverse mapping; adding reflink; and
adding the one piece needed to make quotas work on realtime.  This
brings the robustness of the realtime volume up to par with the data
volume.

Originally, the modernization effort was a side project that was
intended to match XFS up to the proliferation of persistent memory.  The
data device would store metadata on cheap(er) flash storage, and the
realtime volume would be used to map persistent memory to files and take
advantage of the ability to do PMD-aligned allocations.  It's now less
clear how much of that will actually happen (CXL?), but the code's
finished, reasonably well tested, and ready for review.

NOTE: I hacked up metadump to support saving the metadata contents of
external logs and realtime devices so that I could run fuzz testing in
the least thoughtful way possible.  Chandan is working on improving the
deployment image story for our customers, and will likely produce
something better than my rush job.

As a warning, the patches will likely take several days to trickle in.

--D
