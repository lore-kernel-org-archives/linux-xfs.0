Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34086 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753764AbdIDPoH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Sep 2017 11:44:07 -0400
Date: Mon, 4 Sep 2017 23:44:04 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] generic: reserve correct indirect blocks for delalloc
 write path
Message-ID: <20170904154404.GB27835@eguan.usersys.redhat.com>
References: <20170904093819.28708-1-eguan@redhat.com>
 <20170904151440.GE4671@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170904151440.GE4671@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, Sep 04, 2017 at 08:14:40AM -0700, Darrick J. Wong wrote:
> On Mon, Sep 04, 2017 at 05:38:19PM +0800, Eryu Guan wrote:
> > Test that XFS reserves reasonable indirect blocks for delalloc and
> > speculative allocation, and doesn't cause any fdblocks corruption.
> > 
> > This was inspired by an XFS but that too large 'indlen' was returned by
> > xfs_bmap_worst_indlen() which can't fit in a 17 bits value
> > (STARTBLOCKVALBITS is defined as 17), then leaked 1 << 17 blocks in
> > sb_fdblocks.
> > 
> > This was only seen on XFS with rmapbt feature enabled, but nothing
> > prevents the test from being a generic test.
> > 
> > Signed-off-by: Eryu Guan <eguan@redhat.com>
> > ---
> > 
> > This reproduces sb_fdblocks corruption issue for me with 1k block size
> > rmapbt enabled XFS on x86_64 and ppc64 hosts. Other block size XFS pass
> > the test now.
> 
> Looks reasonable; does the revert patch (posted earlier) fix it?

Yes, I just confirmed that the revert patch did fix the bug for me.

Thanks,
Eryu
