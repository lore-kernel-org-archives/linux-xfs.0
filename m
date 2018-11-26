Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:43797 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726176AbeKZVaO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Nov 2018 16:30:14 -0500
Date: Mon, 26 Nov 2018 18:36:19 +0800
From: PanBian <bianpan2016@163.com>
Subject: Re: [PATCH] xfs: libxfs: move xfs_perag_put late
Message-ID: <20181126103619.GA95394@bp>
Reply-To: PanBian <bianpan2016@163.com>
References: <1543052660-58625-1-git-send-email-bianpan2016@163.com>
 <20181126093139.cgojlmtubzuzdb23@hades.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181126093139.cgojlmtubzuzdb23@hades.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org

On Mon, Nov 26, 2018 at 10:31:39AM +0100, Carlos Maiolino wrote:
> On Sat, Nov 24, 2018 at 05:44:20PM +0800, Pan Bian wrote:
> > The function xfs_alloc_get_freelist calls xfs_perag_put to drop the
> > reference. In this case, pag may be released. However,
> > pag->pagf_btreeblks is read and write after the put operation. This may
> > result in a use-after-free bug. This patch moves the put operation late.
> > 
> 
> The patch looks reasonable, can you detail more how did you find it? Via code
> inspection of you hit this user-after-free in some way?

I wrote a tool to check such bugs statically. It first scans the source code 
to extract paired alloc/free functions. Equipped with such functions, it
performs an intra-procedural data flow analysis to detect mismatched
alloc/free bugs and use-after-free bugs.

Best regards,
Pan Bian
