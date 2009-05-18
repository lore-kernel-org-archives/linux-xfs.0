Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4IDHuoF246653 for <xfs@oss.sgi.com>; Mon, 18 May 2009 08:17:56 -0500
Received: from thunker.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BB774292513
	for <xfs@oss.sgi.com>; Mon, 18 May 2009 06:18:03 -0700 (PDT)
Received: from thunker.thunk.org (thunk.org [69.25.196.29]) by cuda.sgi.com
	with ESMTP id CRT6hdvcJwmeMtzd for <xfs@oss.sgi.com>;
	Mon, 18 May 2009 06:18:03 -0700 (PDT)
Date: Mon, 18 May 2009 09:17:55 -0400
From: Theodore Tso <tytso@mit.edu>
Subject: Re: EXT vs XFS at 80% filled filesystem
Message-ID: <20090518131755.GJ32019@mit.edu>
References: <49F9565E.40804@gslab.com> <20090430183450.GB19276@mit.edu>
	<1242651808.3339.28.camel@alhena>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1242651808.3339.28.camel@alhena>
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
To: Milind <milind@gslab.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Mon, May 18, 2009 at 06:33:28PM +0530, Milind wrote:
> Hi Theodore,
> 
> I am facing some weird problem of cross compiling libuuid sources. I
> downloaded e2fsprogs and cross-compiled them but when I do "make
> install-libs" it doesn't really install libuuid.so but installs
> libuuid.a.

The "make install" taret is designed to install what is needed to run
the e2fsprogs programs, including shared libraries; "make
install-libs" is designed to install what as needed for development
purpoes.

So running "make install" in the lib/uuid" should do what you want.

   	   	 	     	 	   	  - Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
