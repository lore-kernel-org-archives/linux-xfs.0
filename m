Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MMZ41r109254 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 17:35:04 -0500
Received: from test.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2CE2FEF746F
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 15:35:02 -0700 (PDT)
Received: from test.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id NJBklMUdimQHcyXp for
	<xfs@oss.sgi.com>; Fri, 22 Jul 2011 15:35:02 -0700 (PDT)
Date: Fri, 22 Jul 2011 18:34:58 -0400
From: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH XFSPROGS 2/3] Build without enabling DEBUG by default
Message-ID: <20110722223458.GD25092@thunk.org>
References: <1311292237-4155-1-git-send-email-tytso@mit.edu>
	<1311292237-4155-2-git-send-email-tytso@mit.edu>
	<20110722141753.GA19681@infradead.org>
	<20110722183048.GC25092@thunk.org>
	<20110722183830.GA21744@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110722183830.GA21744@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On Fri, Jul 22, 2011 at 02:38:30PM -0400, Christoph Hellwig wrote:
> 
> You can get most of this by simply using make V=1, not just in xfsprogs,
> but in most projects using silent make output (including those using
> automake)

Yeah, I know about V=1 (and I have been using it), but I wanted to
know which of the many Makefile variables which finally make up
$(CFLAGS) was getting set to which value, and V=1 doesn't do this.

> for me.  The biggest thing is that you have another directory in your
> include path.  How did you add that one? Did you add anything else
> special to the ./configure or make command lines?

Yes I needed it because I wanted to do a hermetic build; that is, I
didn't want to depend on the version of the acl, attr, dmapi, etc.,
shipped by the distribution.  (This is actually more important when
building xfstests, since I wanted to make sure we used the version of
the xfsprogs headers shipped by the very tip of xfsprogs-dev, since in
the past I've had problems because the distro-shipped header files
were too old.)

The way I did that was by setting the environment CFLAGS to
-I/kbuild/xfstests/bld/include.  And that seems to be the problem.  If
CFLAGS is set as an environment variable, then it's set as a :=, which
means that CFLAGS is set right away, the first time buildmacros is
included.

How about this instead?  A patch like this so that CFLAGS can be
remembered at configure time:

diff --git a/include/builddefs.in b/include/builddefs.in
index 4c8ec64..81ebfcd 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -25,6 +25,7 @@ OPTIMIZER = @opt_build@
 MALLOCLIB = @malloc_lib@
 LOADERFLAGS = @LDFLAGS@
 LTLDFLAGS = @LDFLAGS@
+CFLAGS = @CFLAGS@
 
 LIBRT = @librt@
 LIBUUID = @libuuid@

Then I don't have to set an environment variable when running make; I
just have to pass it to configure.

							- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
