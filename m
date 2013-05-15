Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BFDB77F3F
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 16:51:38 -0500 (CDT)
Date: Wed, 15 May 2013 16:51:37 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [ANNOUNCE] xfsdump v3.1.3
Message-ID: <20130515215137.GV29359@sgi.com>
References: <518AA3CE.9000702@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <518AA3CE.9000702@sgi.com>
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
To: xfs@oss.sgi.com
Cc: Rich Johnston <rjohnston@sgi.com>, David Kaylor <dpkaylor@gmail.com>

Hey,

On Wed, May 08, 2013 at 02:13:18PM -0500, Rich Johnston wrote:
> Version 3.1.3 of xfsdump has been released.
> 
> The source code can be accessed via git using this URL:
> 
>     git://oss.sgi.com/xfs/cmds/xfsdump.git
> 
> A gzipped-tar archive of the source code is available here:
> 
>     ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsdump-3.1.3.tar.gz

David Kaylor pointed out that the posted signature for this tarball
fails verification.  I tracked this down to the fact that I ran 'make
deb' after running the release script but before posting the tarball.
'make deb' regenerated the tar.gz and gzip put an updated timestamp in
the header so the tarball no longer matched the signature.  However the
contents of the tarballs are otherwise identical, so I've moved the old
.sig out of the way, signed the tarball that was posted, and uploaded
the new .sig.

It might be nice for 'make dist' to create an identical .tar.gz for
identical inputs.  gzip can be told not to update it's timestamp with
the -n option, but our current method of generating the tarball relies
upon .gitcensus being created on each run and this is currently
$(_FORCE) and required for the 'make deb' target.  I don't have a
solution at this time, so for the time being 'make dist' is creating
non-identical tarballs for identical inputs at each invocation.
Suggestions are welcome.

Thanks to David for his attention to detail.

Regards,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
