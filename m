Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1IMUxMo194847 for <xfs@oss.sgi.com>; Sat, 18 Feb 2012 16:30:59 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	O4pG3xc2LxSfkgAW for <xfs@oss.sgi.com>;
	Sat, 18 Feb 2012 14:30:57 -0800 (PST)
Date: Sun, 19 Feb 2012 09:30:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Fatal Error doing make for xfsdump
Message-ID: <20120218223054.GA5726@dastard>
References: <33349727.post@talk.nabble.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <33349727.post@talk.nabble.com>
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
To: rlinsurf <jellis@dhnet.us>
Cc: xfs@oss.sgi.com

On Sat, Feb 18, 2012 at 01:46:08PM -0800, rlinsurf wrote:
> 
> I'm getting the following when I try to make:
> 
> FATAL ERROR: attributes.h does not exist.
> Install the extended attributes (attr) development package.
> Alternatively, run "make install-dev" from the attr source.
> make: *** [include/builddefs] Error 1
> 
> I can't figure out how to make this not happen. I've tried doing an apt-get
> install attr, and that succeeded, and doing the make install-dev from the
> attr source, and that succeeded, but the error doesn't go away.

The libattr1 package only contains the binaries, not the environment
for building code that links against the libraries. install the -dev
package as well.

$ apt-cache search libattr1
libattr1 - Extended attribute shared library
libattr1-dev - Extended attribute static libraries and headers
$

or:

$ apt-file search /usr/include/attr/attributes.h
libattr1-dev: /usr/include/attr/attributes.h
$

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
