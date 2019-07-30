Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33088 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728845AbfG3AtW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jul 2019 20:49:22 -0400
Date: Mon, 29 Jul 2019 17:49:17 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/4] xfs: fixes and new tests for bulkstat v5
Message-ID: <20190730004917.GB2345316@magnolia>
References: <156394159426.1850833.16316913520596851191.stgit@magnolia>
 <20190728112635.GN7943@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190728112635.GN7943@desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Sun, Jul 28, 2019 at 07:26:35PM +0800, Eryu Guan wrote:
> Hi XFS folks,
> 
> On Tue, Jul 23, 2019 at 09:13:14PM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > Fix some problems introduced by the creation of the V5 bulkstat ioctl,
> > and then add some new tests to make sure the new libxfrog bulkstat
> > wrappers work fine with both the new v5 ioctl and emulating it with the
> > old v1 ioctl.
> 
> I may need some help on reviewing this patchset, especially the new
> bulkstat tests :) Thanks in advance!

Let me know if you have any questions. :)

> But I'd suggest split the last patch into two patches, one introduces &
> uses the new helper, the other one adds new tests. Also, it misses a new
> entry in .gitignore file.

Oops, will fix.

--D

> Thanks,
> Eryu
> 
> > 
> > If you're going to start using this mess, you probably ought to just
> > pull from my git trees, which are linked below.
> > 
> > This is an extraordinary way to destroy everything.  Enjoy!
> > Comments and questions are, as always, welcome.
> > 
> > --D
> > 
> > kernel git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=bulkstat-v5
> > 
> > xfsprogs git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=bulkstat-v5
> > 
> > fstests git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=bulkstat-v5
