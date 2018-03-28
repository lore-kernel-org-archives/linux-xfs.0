Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:57195 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753047AbeC1UH6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Mar 2018 16:07:58 -0400
Date: Wed, 28 Mar 2018 23:07:52 +0300
From: Baruch Siach <baruch@tkos.co.il>
Subject: Re: [PATCH] xfs_scrub: fix build with older kernel headers
Message-ID: <20180328200752.p7ckzne2lugh7jir@tarshish>
References: <7ea1df02d0f2549b6249c8bee1f6ae02bf1251a9.1521925697.git.baruch@tkos.co.il>
 <20180326180946.GT4818@magnolia>
 <f48bedc9-b532-3e1f-f434-2409a5d93469@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f48bedc9-b532-3e1f-f434-2409a5d93469@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

Hi Eric,

On Mon, Mar 26, 2018 at 08:44:46PM -0500, Eric Sandeen wrote:
> On 3/26/18 1:09 PM, Darrick J. Wong wrote:
> > On Sun, Mar 25, 2018 at 12:08:17AM +0300, Baruch Siach wrote:
> >> The OVERRIDE_SYSTEM_FSXATTR macro in include/linux.h is meant to
> >> override the linux/fs.h kernel header provided struct fsxattr for
> >> kernels older than v4.7. A few source files include linux/fs.h before
> >> the local linux.h, making this override ineffective. Remove these header
> >> includes from the source files, and rely on the linux.h include alone.
> >>
> >> This fixes the following build failures:
> >>
> >> In file included from ../include/xfs.h:37:0,
> >>                  from disk.c:40:
> >> ../include/xfs/linux.h:185:8: error: redefinition of 'struct fsxattr'
> >>  struct fsxattr {
> >>         ^~~~~~~
> >>
> >> In file included from ../include/xfs.h:37:0,
> >>                  from ../include/project.h:22,
> >>                  from ../include/input.h:24,
> >>                  from phase1.c:38:
> >> ../include/xfs/linux.h:185:8: error: redefinition of 'struct fsxattr'
> >>  struct fsxattr {
> >>         ^~~~~~~
> >>
> >> Cc: Darrick J. Wong <darrick.wong@oracle.com>
> >> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> > 
> > Looks ok, but I think this is already fixed by commit a440f8773794
> > ("xfs_scrub: fix #include ordering to avoid build failure") in for-next.
> 
> Agreed, it looks like this is against master & not for-next;
> Baruch, can you check out for-next and confirm that it's ok?

Yes. I verified that commit a440f8773794 (slightly modified to apply to 
v4.15.1) fixes build with the affected toolchain.

Thanks,
baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
