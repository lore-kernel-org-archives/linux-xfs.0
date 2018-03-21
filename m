Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60400 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752527AbeCUS71 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Mar 2018 14:59:27 -0400
Subject: Re: [PATCH 5/4] misc: remove darwin, irix, and freebsd support
References: <152151529988.18312.2660325658864402943.stgit@magnolia>
 <20180321031933.GO1757@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <da8feaae-b6a3-613e-71c8-38d16981d701@redhat.com>
Date: Wed, 21 Mar 2018 13:59:26 -0500
MIME-Version: 1.0
In-Reply-To: <20180321031933.GO1757@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/20/18 10:19 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Remove these ports since they're not actively maintained:
> 
> IRIX support was partially removed last year; the OS itself hasn't had a
> release since 2006.
> 
> FreeBSD dropped XFS support in v9.3, which EOLd in January 2017.
> 
> Darwin/OSX has never supported XFS.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Probably should clean up more than just whole files, see bits & pieces
sprinkled throughout:

include/builddefs.in 
include/platform_defs.h.in
include/gnukfreebsd.h (?)
include/xfs.h 
libhandle/Makefile
quota/Makefile
io/Makefile
*/Makefile
m4/package_libcdev.m4 (AC_HAVE_GETMNTINFO)

...maybe even a wholesale removal of all references to PKG_PLATFORM at this point?

I suppose we can start with this and clean up more as we go.

> ---
>  include/darwin.h  |  315 -----------------------------------------------------
>  include/freebsd.h |  210 -----------------------------------
>  libxfs/Makefile   |    2 
>  libxfs/darwin.c   |  144 ------------------------
>  libxfs/freebsd.c  |  201 ----------------------------------
>  libxfs/irix.c     |  111 -------------------
