Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6N1WK5U124231 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 20:32:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 59F76EF6D3F
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 18:32:16 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	zMynBUXl48qeKvsn for <xfs@oss.sgi.com>;
	Fri, 22 Jul 2011 18:32:16 -0700 (PDT)
Date: Fri, 22 Jul 2011 21:32:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH XFSPROGS 2/3] Build without enabling DEBUG by default
Message-ID: <20110723013214.GA22837@infradead.org>
References: <1311292237-4155-1-git-send-email-tytso@mit.edu>
	<1311292237-4155-2-git-send-email-tytso@mit.edu>
	<20110722141753.GA19681@infradead.org>
	<20110722183048.GC25092@thunk.org>
	<20110722183830.GA21744@infradead.org>
	<20110722223458.GD25092@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110722223458.GD25092@thunk.org>
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
To: Ted Ts'o <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On Fri, Jul 22, 2011 at 06:34:58PM -0400, Ted Ts'o wrote:
> Yes I needed it because I wanted to do a hermetic build; that is, I
> didn't want to depend on the version of the acl, attr, dmapi, etc.,
> shipped by the distribution.  (This is actually more important when
> building xfstests, since I wanted to make sure we used the version of
> the xfsprogs headers shipped by the very tip of xfsprogs-dev, since in
> the past I've had problems because the distro-shipped header files
> were too old.)

Given that you are on a Debian-ish environment, did you consider simply
using pbuilder?  I use that regularly to test clean package builds,
without all these weird overrides.

> The way I did that was by setting the environment CFLAGS to
> -I/kbuild/xfstests/bld/include.  And that seems to be the problem.  If
> CFLAGS is set as an environment variable, then it's set as a :=, which
> means that CFLAGS is set right away, the first time buildmacros is
> included.
> 
> How about this instead?  A patch like this so that CFLAGS can be
> remembered at configure time:
> 
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 4c8ec64..81ebfcd 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -25,6 +25,7 @@ OPTIMIZER = @opt_build@
>  MALLOCLIB = @malloc_lib@
>  LOADERFLAGS = @LDFLAGS@
>  LTLDFLAGS = @LDFLAGS@
> +CFLAGS = @CFLAGS@
>  
>  LIBRT = @librt@
>  LIBUUID = @libuuid@
> 
> Then I don't have to set an environment variable when running make; I
> just have to pass it to configure.

This looks much better, and is indeed similar to some other fixes we
recently had to put in, probably due to changing make behaviour.

If you add a signoff and a proper description I'll put it into all the
repositories.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
