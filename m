Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58742 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfBVCvX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Feb 2019 21:51:23 -0500
Subject: Re: [LSF/MM TOPIC] More async operations for file systems - async discard?
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <92ab41f7-35bc-0f56-056f-ed88526b8ea4@gmail.com>
        <20190217210948.GB14116@dastard>
        <46540876-c222-0889-ddce-44815dcaad04@gmail.com>
        <20190220234723.GA5999@localhost.localdomain>
Date: Thu, 21 Feb 2019 21:51:12 -0500
In-Reply-To: <20190220234723.GA5999@localhost.localdomain> (Keith Busch's
        message of "Wed, 20 Feb 2019 16:47:24 -0700")
Message-ID: <yq18sy8ili7.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Keith Busch <keith.busch@intel.com>
Cc: Ric Wheeler <ricwheeler@gmail.com>, Dave Chinner <david@fromorbit.com>, lsf-pc@lists.linux-foundation.org, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-block@vger.kernel.org


Keith,

> With respect to fs block sizes, one thing making discards suck is that
> many high capacity SSDs' physical page sizes are larger than the fs
> block size, and a sub-page discard is worse than doing nothing.

That ties into the whole zeroing as a side-effect thing.

The devices really need to distinguish between discard-as-a-hint where
it is free to ignore anything that's not a whole multiple of whatever
the internal granularity is, and the WRITE ZEROES use case where the end
result needs to be deterministic.

-- 
Martin K. Petersen	Oracle Linux Engineering
