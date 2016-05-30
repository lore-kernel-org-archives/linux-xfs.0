Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7AB607CA7
	for <xfs@oss.sgi.com>; Sun, 29 May 2016 21:16:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3C4A58F8033
	for <xfs@oss.sgi.com>; Sun, 29 May 2016 19:16:15 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	zGEgmEl7HyEbtYRK for <xfs@oss.sgi.com>;
	Sun, 29 May 2016 19:16:12 -0700 (PDT)
Date: Mon, 30 May 2016 12:13:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 1/2] libxcmd: generalize topology functions
Message-ID: <20160530021330.GL26977@dastard>
References: <1463006717-6104-1-git-send-email-billodo@redhat.com>
	<1463006717-6104-2-git-send-email-billodo@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1463006717-6104-2-git-send-email-billodo@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Bill O'Donnell <billodo@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, May 11, 2016 at 05:45:16PM -0500, Bill O'Donnell wrote:
> Move general topology functions from xfs_mkfs to new topology
> collection in libxcmd.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>

FYI, this patch breaks 'make deb'.

I don't expect anyone to know this - the debian/rules build script
has a special hand-rolled mkfs build for the debian installer. This
new libxcmd dependency also needs to be described in that script.
I've fixed that up, but it's also pointed out a couple of other
things to do with dependencies:

> diff --git a/mkfs/Makefile b/mkfs/Makefile
> index 63ba4ec..f0e4ce1 100644
> --- a/mkfs/Makefile
> +++ b/mkfs/Makefile
> @@ -10,7 +10,7 @@ LTCOMMAND = mkfs.xfs
>  HFILES =
>  CFILES = maxtrres.c proto.c xfs_mkfs.c
>  
> -LLDLIBS += $(LIBBLKID) $(LIBXFS) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
> +LLDLIBS += $(LIBBLKID) $(LIBXFS) $(LIBUUID) $(LIBRT) $(LIBPTHREAD) $(LIBXCMD)
>  LTDEPENDENCIES += $(LIBXFS)
>  LLDFLAGS = -static-libtool-libs

mkfs.xfs also needs the build dependency on libxcmd to be expressed
in LTDEPENDENCIES. It's just lucky that other targets have already
expressed such "libxfs + libxcmd" dependencies as that ensured
libxcmd was already built before mkfs tries to link against it.
Blind luck strikes again!

Those top level build dependencies are expressed in the top level
Makefile like so:

--- a/Makefile
+++ b/Makefile
@@ -82,6 +82,7 @@ io: libxcmd libhandle
 quota: libxcmd
 repair: libxlog
 copy: libxlog
+mkfs: libxcmd
 
 ifeq ($(HAVE_BUILDDEFS), yes)
 include $(BUILDRULES)

I've fixed these problems because I need to build .deb packages to
deploy changes for testing.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
