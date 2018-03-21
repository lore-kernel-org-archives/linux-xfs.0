Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51446 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752637AbeCUTwn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Mar 2018 15:52:43 -0400
Subject: Re: [PATCH 6/4] libfrog: absorb platform specific code
References: <152151529988.18312.2660325658864402943.stgit@magnolia>
 <20180321032000.GP1757@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <96f71004-85c2-27a5-91a8-45e30a93daa8@sandeen.net>
Date: Wed, 21 Mar 2018 14:52:42 -0500
MIME-Version: 1.0
In-Reply-To: <20180321032000.GP1757@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 3/20/18 10:20 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the linux support code to libfrog, which should remove the final
> dependency of libfrog on libxfs.  libfrog is the runtime support library
> anyway.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

sorry, my patch 5.5/4 probably kinda blew this up.

We can fold it in, or whatever ...

> ---
>  libfrog/Makefile |    4 +
>  libfrog/linux.c  |  265 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  libxfs/Makefile  |    3 -
>  libxfs/linux.c   |  265 ------------------------------------------------------
>  4 files changed, 269 insertions(+), 268 deletions(-)
>  create mode 100644 libfrog/linux.c
>  delete mode 100644 libxfs/linux.c
> 
> diff --git a/libfrog/Makefile b/libfrog/Makefile
> index 230b08f..e3065e6 100644
> --- a/libfrog/Makefile
> +++ b/libfrog/Makefile
> @@ -22,6 +22,10 @@ topology.c \
>  util.c \
>  workqueue.c
>  
> +CFILES += $(PKG_PLATFORM).c
> +PCFILES = linux.c
> +LSRCFILES = $(shell echo $(PCFILES) | sed -e "s/$(PKG_PLATFORM).c//g")

Ok so this doesn't really do anything at this point :)
(LSRCFILES will always be empty)

Just add linux.c to the main CFILES list and delete this

The rest makes sense, I think, unless quota/linux.c should get the same
treatment.  Probably not.

-Eric
