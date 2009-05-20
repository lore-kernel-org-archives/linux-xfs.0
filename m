Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4K5hSbt090893 for <xfs@oss.sgi.com>; Wed, 20 May 2009 00:43:29 -0500
Received: from padma.gslab.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 692CA299FCD
	for <xfs@oss.sgi.com>; Tue, 19 May 2009 22:43:36 -0700 (PDT)
Received: from padma.gslab.com (padma.gslab.com [59.163.66.102]) by
	cuda.sgi.com with SMTP id l6PdIVegFNgrpRrw for
	<xfs@oss.sgi.com>; Tue, 19 May 2009 22:43:36 -0700 (PDT)
Subject: Re: EXT vs XFS at 80% filled filesystem
From: Milind <milind@gslab.com>
In-Reply-To: <20090518131755.GJ32019@mit.edu>
References: <49F9565E.40804@gslab.com> <20090430183450.GB19276@mit.edu>
	<1242651808.3339.28.camel@alhena>  <20090518131755.GJ32019@mit.edu>
Date: Wed, 20 May 2009 11:13:30 +0530
Message-Id: <1242798210.3457.4.camel@alhena>
Mime-Version: 1.0
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
To: Theodore Tso <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

I am building xfsprogs to add it to my toolchain and want xfsprogs to
refer to my toolchain's libuuid. So I need libuuid.so in my toolchain.
But building e2fsprogs from sources doesn't build libuuid as .so (builds
as .a). Could you please give some pointers on building libuuid as .so?

Do I have to change Makefiles? How do you do it for ubuntu/debian
packages that you maintain?

Thanks in advance
-Miline

On Mon, 2009-05-18 at 09:17 -0400, Theodore Tso wrote:
> On Mon, May 18, 2009 at 06:33:28PM +0530, Milind wrote:
> > Hi Theodore,
> > 
> > I am facing some weird problem of cross compiling libuuid sources. I
> > downloaded e2fsprogs and cross-compiled them but when I do "make
> > install-libs" it doesn't really install libuuid.so but installs
> > libuuid.a.
> 
> The "make install" taret is designed to install what is needed to run
> the e2fsprogs programs, including shared libraries; "make
> install-libs" is designed to install what as needed for development
> purpoes.
> 
> So running "make install" in the lib/uuid" should do what you want.
> 
>    	   	 	     	 	   	  - Ted
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
