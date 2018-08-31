Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51665 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727202AbeHaKbN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 31 Aug 2018 06:31:13 -0400
Date: Fri, 31 Aug 2018 08:28:13 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] xfs: re-enable FIBMAP on reflink; disable for swap
Message-ID: <20180831062813.GA7280@lst.de>
References: <2eb759e5-2faa-67fd-5c16-c1d8edc42d02@redhat.com> <20180830162545.GA26816@lst.de> <dbe27763-2e69-6e3a-f769-2528eda54940@redhat.com> <20180830163614.GA27069@lst.de> <65e818f2-885d-50a4-0d4a-7700c703c2af@sandeen.net> <20180830180204.GC2853@bfoster> <20180830182849.GA4359@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180830182849.GA4359@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@lst.de>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Aug 30, 2018 at 11:28:49AM -0700, Darrick J. Wong wrote:
> I prefer to have FIBMAP return errors to *cough* encourage people to use
> FIEMAP.  If code are going to abuse the FI[BE]MAP interface they could
> at least abuse the one that gives it enough context to avoid fs
> corruption.  (A proper fs driver would be preferable, though very
> difficult).

I think Carlos was looking into implementing the FIBMAP ioctl
using ->fiemap.  In that case we could return sensible errors,
and centralize policy in a single place..

> Granted, grub's blocklist code doesn't seem to check for shared blocks
> when it writes grubenv.... yuck, though TBH I don't have the eye budget
> to spend on digging through grub2.  Frankly I think FIBMAP comes verrry
> close to "this API is unfixably stupid and shouldn't be enabled for new
> use cases and should go away some day".

.. and that policy should be: always return an error for the slightest
unusual file layout (shared, encrypted, inline, etc).
