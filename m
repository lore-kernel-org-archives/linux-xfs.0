Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C41C4167B
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Nov 2023 17:46:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbjKJRqb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Nov 2023 12:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234766AbjKJRpe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Nov 2023 12:45:34 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1618F6F81;
        Thu,  9 Nov 2023 22:23:31 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id F1E8068AA6; Fri, 10 Nov 2023 07:23:25 +0100 (CET)
Date:   Fri, 10 Nov 2023 07:23:25 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     John Garry <john.g.garry@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, kbusch@kernel.org,
        sagi@grimberg.me, jejb@linux.ibm.com, martin.petersen@oracle.com,
        djwong@kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org,
        chandan.babu@oracle.com, dchinner@redhat.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-api@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH 01/21] block: Add atomic write operations to
 request_queue limits
Message-ID: <20231110062325.GB26516@lst.de>
References: <20230929102726.2985188-1-john.g.garry@oracle.com> <20230929102726.2985188-2-john.g.garry@oracle.com> <20231109151013.GA32432@lst.de> <b7f1b93a-08ea-07c8-d1da-5c2a31d1be80@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7f1b93a-08ea-07c8-d1da-5c2a31d1be80@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 09, 2023 at 05:01:10PM +0000, John Garry wrote:
> Generally they come from the same device property. Then since 
> atomic_write_unit_max_bytes must be a power-of-2 (and 
> atomic_write_max_bytes may not be), they may be different.

How much do we care about supporting the additional slack over the
power of two version?  

> In addition, 
> atomic_write_unit_max_bytes is required to be limited by whatever is 
> guaranteed to be able to fit in a bio.

The limit what fits into a bio is UINT_MAX, not sure that matters :)

> atomic_write_max_bytes is really only relevant for merging writes. Maybe we 
> should not even expose via sysfs.

Or we need to have a good separate discussion on even supporting any
merges.  Willy chimed in that supporting merges was intentional,
but I'd really like to see numbers justifying it.

