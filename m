Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:50638 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbfEFSYZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 May 2019 14:24:25 -0400
Date: Mon, 6 May 2019 11:24:13 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/4] xfsdump: update to use fallocate
Message-ID: <20190506182413.GS5207@magnolia>
References: <155085403848.5141.1866278990901950186.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155085403848.5141.1866278990901950186.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>

Uh, ping? :)

--D

On Fri, Feb 22, 2019 at 08:47:18AM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> This is a series to update the "create file and preallocate blocks"
> code in xfs_restore.
> 
> The first patch refactors the existing copy-pasta into a single helper
> function to create and preallocate space in files, as well as removing
> the totally broken ALLOCSP code.
> 
> The next two patches fix unchecked return values and insufficient
> unsupported-ioctl code.
> 
> The final patch upgrades xfs_restore to try fallocate before RESVSP
> simply because it is the newer API.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
