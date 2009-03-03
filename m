Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n23Fx8sI021146 for <xfs@oss.sgi.com>; Tue, 3 Mar 2009 09:59:09 -0600
Date: Tue, 3 Mar 2009 10:53:41 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] fix parallel build failures in xfsprogs-3.0.0
Message-ID: <20090303155341.GB26376@infradead.org>
References: <200902240010.25434.vapier@gentoo.org>
	<200902261817.02604.agruen@suse.de> <49A794D3.2000904@sgi.com>
	<200902271055.51564.agruen@suse.de> <49A9E555.7040607@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49A9E555.7040607@sgi.com>
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
To: Greg Banks <gnb@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>, Mike Frysinger <vapier@gentoo.org>

On Sun, Mar 01, 2009 at 12:31:01PM +1100, Greg Banks wrote:
> If the point here is to reduce the workload and potential errors
> involved in making a release, you could add a release: target to the
> Makefile to do the release procedure.  That target only needs to work
> for the maintainer, so it's relatively easy.  You could do the stored
> version bump, the tagging, the autotools futzing, and release tarball
> building in there.

The xfs tools (and acl/attr which use the same buildsystem) have a
Makepkgs script that's supposed to do this with some help from the
built system.

I'm not sure we should add generating the tags and updating doc/CHANGES
to it, but everything else is automated iff we actually use it. 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
