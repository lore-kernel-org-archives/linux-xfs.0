Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DF66C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Dec 2022 01:53:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236915AbiLNBxB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 20:53:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiLNBw7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 20:52:59 -0500
X-Greylist: delayed 363 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 13 Dec 2022 17:52:57 PST
Received: from newman.eecs.umich.edu (newman.eecs.umich.edu [141.212.113.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB1FC19021
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 17:52:56 -0800 (PST)
Received: from email.eecs.umich.edu (email.eecs.umich.edu [141.212.113.99] (may be forged))
        by newman.eecs.umich.edu (8.15.2/8.14.4) with ESMTPS id 2BE1kah22792538
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Tue, 13 Dec 2022 20:46:36 -0500
Received: from email.eecs.umich.edu (localhost [127.0.0.1])
        by email.eecs.umich.edu (8.15.2/8.13.0) with ESMTP id 2BE1kaaW1182360;
        Tue, 13 Dec 2022 20:46:36 -0500
Received: from localhost (tpkelly@localhost)
        by email.eecs.umich.edu (8.15.2/8.14.4/Submit) with ESMTP id 2BE1kauG1182357;
        Tue, 13 Dec 2022 20:46:36 -0500
Date:   Tue, 13 Dec 2022 20:46:36 -0500 (EST)
From:   Terence Kelly <tpkelly@eecs.umich.edu>
To:     "Darrick J. Wong" <djwong@kernel.org>
cc:     Suyash Mahar <smahar@ucsd.edu>, linux-xfs@vger.kernel.org,
        Suyash Mahar <suyash12mahar@outlook.com>
Subject: Re: XFS reflink overhead, ioctl(FICLONE)
In-Reply-To: <Y5i0ALbAdEf4yNuZ@magnolia>
Message-ID: <alpine.DEB.2.22.394.2212132042320.1163435@email.eecs.umich.edu>
References: <CACQnzjuhRzNruTm369wVQU3y091da2c+h+AfRED+AtA-dYqXNQ@mail.gmail.com> <Y5i0ALbAdEf4yNuZ@magnolia>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



Hi Darrick,

Thanks for your quick and detailed reply.

The thing that really puzzled me when I re-ran Suyash's experiments on a 
DRAM-backed file system is that the ioctl(FICLONE) calls were still very 
very slow.  A slow block storage device can't be blamed, because there 
wasn't a slow block storage device anywhere in the picture; the slowness 
came from software.

Suyash, can you send those results?

-- Terence Kelly



On Tue, 13 Dec 2022, Darrick J. Wong wrote:

> FICLONE (at least on XFS) persists dirty pagecache data to disk, and 
> then duplicates all written-space mapping records from the source file 
> to the destination file.  It skips preallocated mappings created with 
> fallocate.
> 
> So yes, the plot is exactly what I was expecting.
