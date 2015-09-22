Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 15E687F37
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 16:45:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B1C7CAC00E
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 14:45:12 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	iRFiaSaUT5TzIz5b for <xfs@oss.sgi.com>;
	Tue, 22 Sep 2015 14:45:10 -0700 (PDT)
Date: Wed, 23 Sep 2015 07:45:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 1/2] VFS: Kill use of O_LARGEFILE inside the kernel
Message-ID: <20150922214507.GK19114@dastard>
References: <20150922155104.GA2296@thunk.org>
	<20150922152450.32539.55285.stgit@warthog.procyon.org.uk>
	<1458.1442938362@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1458.1442938362@warthog.procyon.org.uk>
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
To: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, viro@zeniv.linux.org.uk, xfs@oss.sgi.com

On Tue, Sep 22, 2015 at 05:12:42PM +0100, David Howells wrote:
> Theodore Ts'o <tytso@mit.edu> wrote:
> 
> > So what this means is that on 32-bit systems, if we have a userspace
> > program which isn't using the Largefile-enabled, and it opens a file
> > which is larger than can be addressed with a 32-bit off_t, it can get
> > surprised and possibly cause data loss.
> 
> Good point.  I was initially thinking that 32-bit userspace on a 64-bit system
> would have O_LARGEFILE automatically enabled - but I guess it'll trap through
> the compat entry points which avoid that.
> 
> That said, fanotify and xfs_open_by_handle() will both automatically set
> O_LARGEFILE irrespectively of the 32-bitness of the original caller.

Any binaries that use xfs_open_by_handle() and then don't support
greater than 32bit file offsets are simply broken. No ifs or buts -
if you are using low level XFS specific file access ioctls, you need
to build binaries that support 64 bit offsets.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
