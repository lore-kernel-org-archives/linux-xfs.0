Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40731 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727984AbfHHDqa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Aug 2019 23:46:30 -0400
Received: by mail-pf1-f196.google.com with SMTP id p184so43274980pfp.7
        for <linux-xfs@vger.kernel.org>; Wed, 07 Aug 2019 20:46:29 -0700 (PDT)
Date: Thu, 8 Aug 2019 11:46:21 +0800
From: Murphy Zhou <jencce.kernel@gmail.com>
Subject: Re: [LTP] [PATCH v7 3/3] syscalls/copy_file_range02: increase
 coverage and remove EXDEV test
Message-ID: <20190808034621.e7pqwazdqtsed2ew@XZHOUW.usersys.redhat.com>
References: <20190730110555.GB7528@rei.lan>
 <1564569629-2358-1-git-send-email-xuyang2018.jy@cn.fujitsu.com>
 <1564569629-2358-3-git-send-email-xuyang2018.jy@cn.fujitsu.com>
 <20190805065832.ti6vpoviykfaxcj7@XZHOUW.usersys.redhat.com>
 <5D47D6B9.9090306@cn.fujitsu.com>
 <20190805102211.pvyufepn6xywi7vm@XZHOUW.usersys.redhat.com>
 <20190806162703.GA1333@dell5510>
 <20190807101742.mt6tgowsh4xw5hyt@XZHOUW.usersys.redhat.com>
 <20190807121212.GM7777@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807121212.GM7777@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Murphy Zhou <jencce.kernel@gmail.com>, Petr Vorel <pvorel@suse.cz>, Yang Xu <xuyang2018.jy@cn.fujitsu.com>, chrubis@suse.cz, ltp@lists.linux.it, linux-xfs@vger.kernel.org

On Wed, Aug 07, 2019 at 10:12:12PM +1000, Dave Chinner wrote:
> On Wed, Aug 07, 2019 at 06:17:42PM +0800, Murphy Zhou wrote:
> > ccing linux-xfs@vger.kernel.org
> > 
> > Hi,
> > 
> > Tracked down this to be a xfs specific issue:
> > 
> > If we call copy_file_range with a large offset like this:
> > 
> > 	loff_t off = 9223372036854710270; // 2 ** 63
> > 	ret = copy_file_range(fd_in, 0, fd_out, &off, 65537, 0);
> 
> That's not 2**63:

Ya! I was looking too roughly.

> 
> $ echo $((9223372036854710270 + 65537))
> 9223372036854775807
> 
> $ echo $((2**63 - 1))
> 9223372036854775807
> 
> i.e. it's LLONG_MAX, not an overflow. XFS sets sb->s_maxbytes in
> xfs_max_file_offset to:
> 
> 	(1 << BITS_PER_LONG - 1) - 1 = 2**63 - 1 = LLONG_MAX.
> 
> So no matter how we look at it, this operation should not return
> EFBIG on XFS.
> 
> > (test programme cfrbig.c attached)
> > 
> > xfs has it done successfully, while ext4 returns EFBIG.
> 
> ext4 has a max file size of 2**32 * blocksize, so it doesn't support
> files larger than 16TB. So it will give EFBIG on this test.
> 
> /me compiles and runs the test program on his workstation:
> 
> $ ls -l foobar
> -rw------- 1 dave dave 10737418240 Apr 12 14:46 foobar
> $ ./a.out foobar bar
> ret 65537
> $ ls -l bar
> -rw-r--r-- 1 dave dave 9223372036854775807 Aug  7 22:11 bar
> $
> 
> That looks like a successful copy to me, not EINVAL or EFBIG...

Thanks Dave for the confirmation! This testcase needs some fix.

Murphy

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
