Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:56652 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725973AbeIAMk1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 1 Sep 2018 08:40:27 -0400
Date: Sat, 1 Sep 2018 10:32:17 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] xfs: re-enable FIBMAP on reflink; disable for swap
Message-ID: <20180901083217.GD670@lst.de>
References: <dbe27763-2e69-6e3a-f769-2528eda54940@redhat.com> <20180830163614.GA27069@lst.de> <65e818f2-885d-50a4-0d4a-7700c703c2af@sandeen.net> <20180830180204.GC2853@bfoster> <20180830182849.GA4359@magnolia> <10d35380-6f5f-22a5-7b6a-1cfb60c53cfd@sandeen.net> <20180831001106.GG5631@dastard> <7ae98d88-7cbf-1314-83b6-dc15da5124eb@sandeen.net> <20180831030542.GK5631@dastard> <19b4da59-3720-6647-e557-9d7353ed509b@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19b4da59-3720-6647-e557-9d7353ed509b@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Aug 31, 2018 at 08:08:11AM -0500, Eric Sandeen wrote:
> If you can directly read the block device hosting the files, file
> permissions of shared blocks are completely beside the point.

The point is that you should never, ever directly read blocks from
the block device, nevermind write.  And we need to make sure userspace
stops doing that instead of catering to it in any way.

> The "typical use case" is to map a file for a bootloader to /read/
> at boot, and our arbitrary restriction has broken systems in
> the real world, and burned a lot of institutional effort getting
> to the bottom of the problem and working around it.

And even that 'use case' is utterly broken.
