Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from scorn.kernelslacker.org ([45.56.101.199]:49690 "EHLO
        scorn.kernelslacker.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751973AbdH3RR3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 13:17:29 -0400
Date: Wed, 30 Aug 2017 13:17:28 -0400
From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: iov_iter_pipe warning.
Message-ID: <20170830171728.cwe34lhjnkwafe3z@codemonkey.org.uk>
References: <20170421175430.GT29622@ZenIV.linux.org.uk>
 <20170428152955.mafs3f22srmm34aw@codemonkey.org.uk>
 <20170428164313.GK29622@ZenIV.linux.org.uk>
 <20170428165024.ofyl2atpjwohekqa@codemonkey.org.uk>
 <20170428172024.GL29622@ZenIV.linux.org.uk>
 <20170807201818.kykqzexce6ap6aik@codemonkey.org.uk>
 <20170828203130.y6dq5fqovev6wmrv@codemonkey.org.uk>
 <20170829042542.GO4757@magnolia>
 <20170830170523.a4bysufgifdhtm43@codemonkey.org.uk>
 <20170830171343.GT4757@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170830171343.GT4757@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org

On Wed, Aug 30, 2017 at 10:13:43AM -0700, Darrick J. Wong wrote:


 > > I reverted the debug patches mentioned above, and ran trinity for a while again,
 > > and got this which smells really suspiciously related
 > > 
 > > WARNING: CPU: 1 PID: 10380 at fs/iomap.c:993 iomap_dio_rw+0x825/0x840
 > > RAX: 00000000fffffff0 RBX: ffff88046a64d0e8 RCX: 0000000000000000
 > > 
 > > 
 > > 
 > > That's this..
 > > 
 > >  987         ret = filemap_write_and_wait_range(mapping, start, end);
 > >  988         if (ret)
 > >  989                 goto out_free_dio;
 > >  990 
 > >  991         ret = invalidate_inode_pages2_range(mapping,
 > >  992                         start >> PAGE_SHIFT, end >> PAGE_SHIFT);
 > >  993         WARN_ON_ONCE(ret);
 > > 
 > > 
 > > Plot thickens..
 > 
 > Hm, that's the WARN_ON that comes from a failed pagecache invalidation
 > prior to a dio operation, which implies that something's mixing buffered
 > and dio?

Plausible. Judging by RAX, we got -EBUSY

 > Given that it's syzkaller it wouldn't surprise me to hear that it's
 > doing that... :)

s/syzkaller/trinity/, but yes.

	Dave
