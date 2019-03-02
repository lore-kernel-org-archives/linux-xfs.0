Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44951 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfCBJcy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Mar 2019 04:32:54 -0500
Date: Sat, 2 Mar 2019 17:32:48 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH 2/2] t_attr_corruption: fix this yet again
Message-ID: <20190302093248.GC2824@desktop>
References: <155114852926.9683.4048206997940455508.stgit@magnolia>
 <155114853550.9683.11298191063436471344.stgit@magnolia>
 <ed56f33a-5fff-1200-7353-ba411c863baa@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed56f33a-5fff-1200-7353-ba411c863baa@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Mahoney <jeffm@suse.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Feb 28, 2019 at 03:56:40PM -0500, Jeff Mahoney wrote:
> On 2/25/19 9:35 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Jeff Moyer pointed out that 'security.evm' actually has an expected
> 
> Mahoney :)

Fixed on commit :)

> 
> > value format, which breaks the test if EVM is enabled.  It turns out
> > that the 'security.evm' setxattr call in the original syzkaller report
> > was a total red herring, as this bug can be reproduced without it.
> > 
> > Fix the test case to do the minimum amount of work needed to reproduce
> > the corruption.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Otherwise, works for me in the case that failed for me previously.

Thanks for the fix and test!

Eryu
