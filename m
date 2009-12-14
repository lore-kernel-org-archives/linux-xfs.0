Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBEMguRr182911 for <xfs@oss.sgi.com>; Mon, 14 Dec 2009 16:42:57 -0600
Date: Mon, 14 Dec 2009 17:43:33 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: User Space Releases
Message-ID: <20091214224333.GA22678@infradead.org>
References: <404301816.1070071260483145992.JavaMail.root@mail-au.aconex.com>
	<733693069.1070091260483175291.JavaMail.root@mail-au.aconex.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <733693069.1070091260483175291.JavaMail.root@mail-au.aconex.com>
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
To: Nathan Scott <nscott@aconex.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>

On Fri, Dec 11, 2009 at 09:12:55AM +1100, Nathan Scott wrote:
> Here's the conversion to new-fangled build style for xfsdump.  Review?
> Its largely same as xfsprogs, the one slight wrinkle was the symlinked
> files in "common"... but thats sorted out with this patch too.

Thanks.  Looks good from looking over it and trying a make dist and
debian package build.  A couple of think I noticed while going over the
diffs between xfsprogs and xfsdump for the build system:

 - in xfsdump we have po/*.mo in the gitignore file, while we list the
   two translations explicitly in xfsprogs.  I'll fix this up and push
   the fix
 - installation of documentation is doc/Makefile is handled slightly
   differently.  In both cases we might be better off installing more
   documtnation (and probably get rid of the $(README) variable in
   xfsdump.  I'll look into more sensible defaults for either.
 - the source-link target in xfsdump now echos the mkdir command
   but xfsprogs doesn't.  I don't care either way but it might be a good
   idea to make it the same in both versions
 - include/builddefs.in in xfsdump now expands prefix/exec_prefix/
   datarootdir/top_builddir twice.  Just kill the second one
 - the doc/PORTING file still exist in xfsdump and should probably be
   deleted.  It doesn't get packaged either, btw.
 - the build directory in xfsdump isn't deleted yet as it is in
   xfsprogs.
 - the Makepkgs script isn't deleted yet as in xfsprogs
   build/rpm/rpm-2.rc.template
 - unlike xfsprogs the m5/lt*.m4 files don't get into the generated
   tarball.  I don't quite understand why we need them, but we should
   at least be consistant.

 - might it be a good idea to add the LHFILES/LCFILEs handling to
   xfsprogs and the install-qa handling to xfsdump include/build*
   despite beeing unused to keep them in sync?
 - probably worth updating the copyrights in either version to list
   the same years now they are the same

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
