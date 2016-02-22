Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 01B4D7CB2
	for <xfs@oss.sgi.com>; Mon, 22 Feb 2016 02:00:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6610FAC011
	for <xfs@oss.sgi.com>; Mon, 22 Feb 2016 00:00:21 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mmCH0lJOCpvR4iGd (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 22 Feb 2016 00:00:13 -0800 (PST)
Date: Mon, 22 Feb 2016 16:00:06 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: xfstests configure error with xfsprogs v4.5-rc1
Message-ID: <20160222080006.GW11419@eguan.usersys.redhat.com>
References: <20160222030304.GV11419@eguan.usersys.redhat.com>
	<20160222032450.GF14668@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160222032450.GF14668@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Mon, Feb 22, 2016 at 02:24:50PM +1100, Dave Chinner wrote:
> On Mon, Feb 22, 2016 at 11:03:04AM +0800, Eryu Guan wrote:
> > Hi,
> > 
> > After upgrading to xfsprogs v4.5-rc1 version, xfstests failed to built
> > because of configure error:
> > 
> >     checking xfs/xfs.h usability... no
> >     checking xfs/xfs.h presence... yes
> >     configure: WARNING: xfs/xfs.h: present but cannot be compiled
> >     configure: WARNING: xfs/xfs.h:     check for missing prerequisite headers?
> >     configure: WARNING: xfs/xfs.h: see the Autoconf documentation
> >     configure: WARNING: xfs/xfs.h:     section "Present But Cannot Be Compiled"
> >     configure: WARNING: xfs/xfs.h: proceeding with the compiler's result
> >     checking for xfs/xfs.h... no
> >     
> >     FATAL ERROR: cannot find a valid <xfs/xfs.h> header file.
> >     Run "make install-qa" from the xfsprogs source.
> > 
> > and config.log showed:
> > 
> >     configure:4543: checking xfs/xfs.h usability
> >     configure:4543: ccache gcc -c -g -O2  conftest.c >&5
> >     In file included from /usr/include/xfs/xfs.h:37:0,
> >     		 from conftest.c:73:
> >     /usr/include/xfs/linux.h:145:1: error: unknown type name 'off64_t'
> >      typedef off64_t  xfs_off_t;
> >      ^
> >     configure:4543: $? = 1
> 
> That would seem like a system library problem in that it doesn't
> define off64_t through stdio.h. What distro are you compiling on?

It's a RHEL7.2 box.

> Also,  if you set _GNU_SOURCE, does it then compile? e.g. see
> m4/package_libcdev.m4 for how to test whether code compiles under
> certain defines.

Okay, I'll go through the m4 files and test around.

Thanks,
Eryu

> 
> If it does compile with _GNU_SOURCE being set, then all that needs
> to be is to update the autoconf rule.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
