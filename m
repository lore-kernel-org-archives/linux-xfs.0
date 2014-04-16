Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 65C3D7F61
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 11:37:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 57272304062
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 09:37:47 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id hOQLax1QNLKd42y6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 16 Apr 2014 09:37:45 -0700 (PDT)
Date: Wed, 16 Apr 2014 17:37:41 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 17/19] VFS: set PF_FSTRANS while namespace_sem is held.
Message-ID: <20140416163741.GY18016@ZenIV.linux.org.uk>
References: <20140416033623.10604.69237.stgit@notabene.brown>
	<20140416040337.10604.86740.stgit@notabene.brown>
	<20140416044618.GX18016@ZenIV.linux.org.uk>
	<20140416155230.4d02e4b9@notabene.brown>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140416155230.4d02e4b9@notabene.brown>
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
To: NeilBrown <neilb@suse.de>
Cc: linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Apr 16, 2014 at 03:52:30PM +1000, NeilBrown wrote:

> So something like this?  I put that in to my testing instead.

Something like this, yes...  And TBH I would prefer the same approach
elsewhere - this kind of hidden state makes it hard to do any kind of
analysis.

Put it that way - the simplest situation is when the allocation flags
depend only on the call site.  Next one is when it's a function of
call chain - somewhat harder to review.  And the worst is when it's
a function of previous history of execution - not just the call chain,
but the things that had been called (and returned) prior to that one.

How many of those locations need to be of the third kind?  All fs/namespace.c
ones are of the first one...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
