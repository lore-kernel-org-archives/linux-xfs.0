Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4OGPSi6037173 for <xfs@oss.sgi.com>; Thu, 24 May 2012 11:25:28 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 9oYRQyK12iOQCwcF for <xfs@oss.sgi.com>;
	Thu, 24 May 2012 09:25:27 -0700 (PDT)
Message-ID: <4FBE60F6.6050709@sandeen.net>
Date: Thu, 24 May 2012 11:25:26 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfsprogs: .lai files not found
References: <alpine.LNX.2.01.1205241517400.10834@frira.zrqbmnf.qr>
In-Reply-To: <alpine.LNX.2.01.1205241517400.10834@frira.zrqbmnf.qr>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jan Engelhardt <jengelh@inai.de>
Cc: xfs@oss.sgi.com

On 5/24/12 8:45 AM, Jan Engelhardt wrote:
> 
> So I tried changing the xfsprogs package in openSUSE to build without 
> static libraries, and what I got back from the build system was a 
> warning about completely improper rpath settings.
> 
> 
> 	ERROR: RPATH "/home/abuild/rpmbuild/BUILD/xfsprogs-3.1.6/libxfs/.libs" 
> 	on 
> 	/home/abuild/rpmbuild/BUILDROOT/xfsprogs-3.1.6-0.x86_64/usr/sbin/mkfs.xfs 
> 	is not allowed
> 	[lots of these]
> 
> I therefore ripped out
> 
> 	-LTLDFLAGS += -rpath $(PKG_ROOT_LIB_DIR)
> 
> from include/buildmacros, only to find that the install procedure then 
> does not work at all anymore.
> 
> 	cd ../libhandle/.libs; ../../install-sh -o abuild -g abuild -m 755 -d /lib64; ../../install-sh -o abuild -g abuild -m 644 -T so_dot_version libhandle.lai /lib64; ../../install-sh -o abuild -g abuild -T so_dot_current libhandle.lai /lib64
> 	install-sh: Unable to find libtool library file libhandle.lai
> 	install-sh: Unable to find libtool library file libhandle.lai
> 	gmake[1]: *** [install] Error 2
> 	make: *** [libhandle-install] Error 2
> 	error: Bad exit status from /var/tmp/rpm-tmp.JjlSJb (%install)
> 
> (I frown upon using libtool directly and seek to replace it with an
> assisted version using automake. There is however __quite__ some
> cruft in the src tree.)

It's a little embarrassing to say so, but here's the hack I use in fedora for some of this stuff.

%configure \
        --enable-readline=yes   \
        --enable-blkid=yes

# Kill rpaths
sed -i 's|^hardcode_libdir_flag_spec=.*|hardcode_libdir_flag_spec=""|g' libtool
sed -i 's|^runpath_var=LD_RUN_PATH|runpath_var=DIE_RPATH_DIE|g' libtool

...

# nuke .la files, etc
rm -f $RPM_BUILD_ROOT/{%{_lib}/*.{la,a,so},%{_libdir}/*.{la,a}}

Agreed that the build system could use love, do we have a volunteer? :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
