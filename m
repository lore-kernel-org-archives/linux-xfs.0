Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3F32C433FE
	for <linux-xfs@archiver.kernel.org>; Sat,  7 May 2022 05:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445709AbiEGFbA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 7 May 2022 01:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445664AbiEGFax (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 7 May 2022 01:30:53 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505504FC5D;
        Fri,  6 May 2022 22:26:53 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 827FD68AFE; Sat,  7 May 2022 07:26:49 +0200 (CEST)
Date:   Sat, 7 May 2022 07:26:49 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     dsterba@suse.cz, Christoph Hellwig <hch@lst.de>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: reduce memory allocation in the btrfs direct I/O path
Message-ID: <20220507052649.GA28014@lst.de>
References: <20220504162342.573651-1-hch@lst.de> <20220505155529.GY18596@suse.cz> <20220506171803.GA27137@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506171803.GA27137@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 06, 2022 at 10:18:03AM -0700, Darrick J. Wong wrote:
> > The series is reasonably short so I'd like to add it to 5.20 queue,
> > provided that the iomap patches get acked by Darrick. Any fixups I'd
> > rather fold into my local branch, no need to resend unless there are
> > significant updates.
> 
> Hm.  I'm planning on pushing out a (very late) iomap-5.19-merge branch,
> since (AFAICT) these changes are mostly plumbing.  Do you want me to
> push the first three patches of this series for 5.19?

Given that we have no conflicts it might be easiest to just merge the
whole series through the btrfs tree.
