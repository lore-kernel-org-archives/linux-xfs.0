Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36473 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfG1L0m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Jul 2019 07:26:42 -0400
Date: Sun, 28 Jul 2019 19:26:35 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH 0/4] xfs: fixes and new tests for bulkstat v5
Message-ID: <20190728112635.GN7943@desktop>
References: <156394159426.1850833.16316913520596851191.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156394159426.1850833.16316913520596851191.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Hi XFS folks,

On Tue, Jul 23, 2019 at 09:13:14PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Fix some problems introduced by the creation of the V5 bulkstat ioctl,
> and then add some new tests to make sure the new libxfrog bulkstat
> wrappers work fine with both the new v5 ioctl and emulating it with the
> old v1 ioctl.

I may need some help on reviewing this patchset, especially the new
bulkstat tests :) Thanks in advance!

But I'd suggest split the last patch into two patches, one introduces &
uses the new helper, the other one adds new tests. Also, it misses a new
entry in .gitignore file.

Thanks,
Eryu

> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=bulkstat-v5
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=bulkstat-v5
> 
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=bulkstat-v5
