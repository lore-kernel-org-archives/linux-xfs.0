Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B6CBF7F55
	for <xfs@oss.sgi.com>; Sun,  3 Aug 2014 21:20:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A478C8F8040
	for <xfs@oss.sgi.com>; Sun,  3 Aug 2014 19:20:11 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	HLSjFeOMLWEkwEz8 for <xfs@oss.sgi.com>;
	Sun, 03 Aug 2014 19:20:09 -0700 (PDT)
Date: Mon, 4 Aug 2014 12:20:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Is jdm_delete_filehandle part of a public API?
Message-ID: <20140804022005.GV20518@dastard>
References: <53D7DA7F.2040706@redhat.com>
	<20140801135305.GA31894@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140801135305.GA31894@infradead.org>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Aug 01, 2014 at 06:53:05AM -0700, Christoph Hellwig wrote:
> Talking about libhandle: this one has been a bit bitrotted.  Maybe it's
> a good time to move everything over to the kernel by handle syscalls
> and deprecated it?

First you need to make the kernel by-handle interfaces handle the
sae functionality as the XFS by-handle ioctls.

	1. O_NOCMTIME doesn't exist, and so there's no way to do
	   invisible IO on files.
	2. Can we construct VFs filehandles in userspace from
	   bulkstat information (dump, xfs_fsr and others rely on
	   this capability)?
	3. The kernel by-handle interfaces cannot manipulate
	   attributes at all (i.e. attr-list, attr-multi
	   functionality).

So until the VFS by-handle interfaces can do these things, we can't
change libhandle over to use the newer kernel interfaces.

I'm also pretty sure the incompatible handle format would mean
big problems if someone were to be storing file handles in userspace
and they upgrade their version of libhandle. i.e. such a library
implementation change is not forwards or backwards compatible with
existing applications, but bumping the major shared library version
should solve that problem.

However, these are all solvable problems. It's definitely a low
priority for me to do this, but if you want to do it patches will
definitely be accepted ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
