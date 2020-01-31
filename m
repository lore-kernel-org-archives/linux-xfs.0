Return-Path: <SRS0=/Bg7=3U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F148AC33C9E
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Jan 2020 02:11:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA5DC206F0
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Jan 2020 02:11:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbgAaCLV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jan 2020 21:11:21 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:55830 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727722AbgAaCLV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jan 2020 21:11:21 -0500
Received: from dread.disaster.area (pa49-195-111-217.pa.nsw.optusnet.com.au [49.195.111.217])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7442B3A197F;
        Fri, 31 Jan 2020 13:11:18 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ixLm8-0006Od-F5; Fri, 31 Jan 2020 13:11:16 +1100
Date:   Fri, 31 Jan 2020 13:11:16 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/11] xfsprogs: remove unneeded #includes
Message-ID: <20200131021116.GS18610@dread.disaster.area>
References: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
 <20190620220614.GE26375@dread.disaster.area>
 <58a0f2df-988d-ce88-9c53-fd39ff703661@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58a0f2df-988d-ce88-9c53-fd39ff703661@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=0OveGI8p3fsTA6FL6ss4ZQ==:117 a=0OveGI8p3fsTA6FL6ss4ZQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=Jdjhy38mL1oA:10
        a=7-415B0cAAAA:8 a=I1NHBd81dECv69zq8_oA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 30, 2020 at 10:59:22AM -0600, Eric Sandeen wrote:
> On 6/20/19 5:06 PM, Dave Chinner wrote:
> > On Thu, Jun 20, 2019 at 04:29:23PM -0500, Eric Sandeen wrote:
> >> This is the result of a mechanical process and ... may have a few
> >> oddities, for example removing "init.h" from some utils made me
> >> realize that we inherit it from libxfs and also have it in local
> > 
> > We do? That'd be really, really broken if we did - including local
> > header files from a global header files is not a good idea.
> > 
> > /me goes looking, can't find where libxfs.h includes init.h
> > 
> > libxfs/init.h is private to libxfs/, it's not a global include file,
> > and it is included directly in all the libxfs/*.c files that need
> > it, which is 3 files - init.c, rdwr.c and util.c. 
> > 
> >> headers; libxfs has a global but so does scrub, etc.  So that stuff
> >> can/should be fixed up, but in the meantime, this zaps out a ton
> >> of header dependencies, and seems worthwhile.
> > 
> > IMO, this doesn't improve the tangle of header files in userspace.
> > All it does is make the include patterns inconsistent across files
> > because of the tangled mess of the libxfs/ vs include/ header files
> > that was never completely resolved when libxfs was created as a
> > shared kernel library....
> > 
> > IOWs, the include pattern I was originally aiming for with the
> > libxfs/ shared userspace/kernel library was:
> > 
> > #include "libxfs_priv.h"
> > <include shared kernel header files>
> > 
> > And for things outside libxfs/ that use libxfs:
> > 
> > #include "libxfs.h"
> > <include local header files>
> > 
> > IOWs, "libxfs_priv.h" contained the includes for all the local
> > userspace libxfs includes and defines and non-shared support
> > structures, and it would export on build all the header files that
> > external code needs to build into include/ via symlinks. This is
> > incomplete - stuff like include/xfs_mount.h, xfs_inode.h, etc needs
> > to move into libxfs as private header files (similar to how they are
> > private in the kernel) and then exported at build time.
> > 
> > Likewise, "libxfs.h" should only contain global include files and
> > those exported from libxfs, and that's all the external code should
> > include to use /anything/ from libxfs. i.e.  a single include forms
> > the external interface to libxfs.
> > 
> > AFAIC, nothing should be including platform or build dependent
> > things like platform_defs.h, because that should be pulled in by
> > libxfs.h or libxfs_priv.h. And nothing external should need to pull
> > in, say, xfs_format.h or xfs_mount.h, because they are all pulled in
> > by include/libxfs.h (which it mostly does already).
> > 
> > Hence I'd prefer we finish untangling the header file include mess
> > before we cull unneceesary includes. Otherwise we are going to end
> > up culling the wrong includes and then have to clean up that mess as
> > well to bring the code back to being clean and consistent....
> 
> Dave, what if I reworked this to only remove unneeded system include files
> for now.  Would you be more comfortable with that?  I assume there's no
> argument with i.e.
> 
> diff --git a/estimate/xfs_estimate.c b/estimate/xfs_estimate.c
> index 9e01cce..189bb6c 100644
> --- a/estimate/xfs_estimate.c
> +++ b/estimate/xfs_estimate.c
> @@ -10,7 +10,6 @@
>   * XXX: assumes dirv1 format.
>   */
>  #include "libxfs.h"
> -#include <sys/stat.h>
>  #include <ftw.h>
> 
> right?

*nod*

That sort of thing can easily be cleaned up.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
