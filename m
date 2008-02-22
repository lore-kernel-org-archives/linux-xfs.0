Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 20:43:16 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1M4h8Qx012061
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:43:11 -0800
Message-ID: <47BE5428.6060609@sgi.com>
Date: Fri, 22 Feb 2008 15:48:40 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [GIT PULL] XFS update for 2.6.25-rc3
References: <20080222044112.9A2C658C4C0F@chook.melbourne.sgi.com>
In-Reply-To: <20080222044112.9A2C658C4C0F@chook.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

please ignore this request - sent the wrong file, see next pull request...

Lachlan McIlroy wrote:
> Please pull from the for-linus branch:
>     git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus
> 
> This will update the following files:
> 
>  fs/xfs/Kbuild             |    6 --
>  fs/xfs/Makefile           |  118 ++++++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/Makefile-linux-2.6 |  117 --------------------------------------------
>  3 files changed, 117 insertions(+), 124 deletions(-)
>  delete mode 100644 fs/xfs/Kbuild
> 
> through these commits:
> 
> commit 269cdfaf769f5cd831284cc831790c7c5038040f
> Author: Lachlan McIlroy <lachlan@redback.melbourne.sgi.com>
> Date:   Wed Nov 28 18:28:09 2007 +1100
> 
>     [XFS] Added quota targets and removed dmapi directory
>     
>     Fixes build failures introduced by bad merge to mainline.
> 
> commit 794f744b225aaf35742aac9e7b9dda96a9943413
> Author: Eric Sandeen <sandeen@sandeen.net>
> Date:   Tue Nov 27 16:59:56 2007 +1100
> 
>     [XFS] Fix up xfs out-of-tree builds. (a.k.a. external modules)
>     
>     Change -I include directives to find headers in the out-of-tree spot. This
>     allows a directory containing only xfs files to be built as:
>     
>     SGI-PV: 971186
>     SGI-Modid: xfs-linux-melb:xfs-kern:29878a
>     
>     Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>     Signed-off-by: Donald Douwsma <donaldd@sgi.com>
>     Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
> 
> commit 58b7983d15a422d9616bdc4e245d5c31dfaefbe2
> Author: Andi Kleen <ak@suse.de>
> Date:   Tue Nov 27 16:53:47 2007 +1100
> 
>     [XFS] Remove Makefile wrappers in XFS
>     
>     Makefile (and Kbuild) would include Makefile-linux-26 I doubt XFS will
>     really still compile on 2.4; so drop that. This moves Makefile-linux-26
>     into Makefile and drops Kbuild. Also having wrappers as both Kbuild and
>     Makefile seemed redundant anyways.
>     
>     The patch is relatively large because it renames a file, but no functional
>     changes.
>     
>     SGI-PV: 971050
>     SGI-Modid: xfs-linux-melb:xfs-kern:29781a
>     
>     Signed-off-by: Andi Kleen <ak@suse.de>
>     Signed-off-by: Donald Douwsma <donaldd@sgi.com>
>     Signed-off-by: Tim Shimmin <tes@sgi.com>
>     Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
