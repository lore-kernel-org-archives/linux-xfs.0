Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56236 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfBWCtu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Feb 2019 21:49:50 -0500
Date: Fri, 22 Feb 2019 18:49:36 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [ANNOUNCE] xfsprogs v4.20.0 released
Message-ID: <20190223024936.GV6503@magnolia>
References: <59a16d27-0370-12c3-4590-071f88a9d3fb@sandeen.net>
 <5C70AC01.3060306@tlinx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5C70AC01.3060306@tlinx.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: L A Walsh <xfs@tlinx.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Feb 22, 2019 at 06:12:17PM -0800, L A Walsh wrote:
> On 2/22/2019 10:33 AM, Eric Sandeen wrote:
> >         - xfs_scrub: move all executables to /usr/sbin (Darrick Wong)
> >   
> ---
>     How does moving executables to /usr/sbin pertain to cleaning
> metadata?

I think we have a misunderstanding here.  "Move all executables" means I
changed where the xfsprogs package puts the binary when installing the
package.  xfs_scrub does not itself move binaries (or any file) around
when it is running.

The reason for changing the packaging is that xfs_scrub depends on
libraries in /usr, so it makes no sense to have xfs_scrub in /sbin.

> What happens if /usr is not mounted or not created and the user is
> running the xfs utils out of /sbin??

If /usr is broken and won't mount, use xfs_repair to make it mountable,
just like we have always done.

xfs_scrub is only meant to be used as a background process on a system
once it has come completely up.  xfs_repair's role has not changed -- it
is still the intended tool to fix filesystems that will not mount or
that cannot be fixed while online.

> For that matter, if the tools are run out of /sbin, are you saying
> xfs_scrub will move them all off of the root partition onto the /usr
> partition?

No.

>     If you are moving the executables, are you also moving all of their
> linked libraries?  It seems if you are wanting safety, moving the libraries
> and executables to the same directory would be prudent, otherwise,
> why move them to to /usr/sbin?
> >         - Merge libxfs from kernel 4.20 
> >   
> What is libxfs being merged with?

Merging bug fixes from the kernel into xfsprogs.

--D

> Thanks!
> 
> 
> 
