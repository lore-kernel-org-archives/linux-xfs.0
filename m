Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D20477F54
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 18:09:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6DA05AC003
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 16:09:07 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	jdkfzuogJjKxeJM5 for <xfs@oss.sgi.com>;
	Wed, 16 Apr 2014 16:09:05 -0700 (PDT)
Date: Thu, 17 Apr 2014 09:03:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] renameat2 syscall: check plain rename
Message-ID: <20140416230315.GF31578@dastard>
References: <1397231517-4641-1-git-send-email-miklos@szeredi.hu>
	<1397231517-4641-2-git-send-email-miklos@szeredi.hu>
	<20140414023020.GJ27694@dastard>
	<20140416141825.GA32449@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140416141825.GA32449@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, Miklos Szeredi <mszeredi@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Apr 16, 2014 at 07:18:25AM -0700, Christoph Hellwig wrote:
> On Mon, Apr 14, 2014 at 12:30:20PM +1000, Dave Chinner wrote:
> > IOWs, XFS is returning EEXIST rather than ENOTEMPTY for several of
> > these rename tests. The rename man page says this about the errors:
> > 
> >        ENOTEMPTY or EEXIST
> >               newpath is a nonempty directory, that is, contains
> > 	      entries other than "." and "..".
> > 
> > Which implies that both errors are valid and so the test should pass
> > in either case. Can you send a patch to handle these
> > different-but-valid error returns?
> 
> I would much prefer if all Linux filesystems behaved uniformly here.
> 
> While EEXIST sounds much more logical to me in this case I suspect most
> other filesystems have copy & pasted from ext2, and we should switch to
> ENOTEMPTY as well.

Send patches, please.

But from an xfstests perspective, we still have to support kernels
and filesystems that return EEXIST for this function, as it is
valid for them to do so....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
