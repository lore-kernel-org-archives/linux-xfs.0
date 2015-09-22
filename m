Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6E79A7F51
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 10:51:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5AA128F8037
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 08:51:09 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id 983vMmIaC6JDGqgM (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Sep 2015 08:51:07 -0700 (PDT)
Date: Tue, 22 Sep 2015 11:51:04 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH 1/2] VFS: Kill use of O_LARGEFILE inside the kernel
Message-ID: <20150922155104.GA2296@thunk.org>
References: <20150922152450.32539.55285.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150922152450.32539.55285.stgit@warthog.procyon.org.uk>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org

On Tue, Sep 22, 2015 at 04:24:50PM +0100, David Howells wrote:
> 
>  (4) fs/open.c:  Length check in ftruncate().
> 
>  (5) fs/open.c:  Length check in generic_file_open().
> 
> All but the first two are just making length checks that are waived
> unconditionally on a 64-bit system.  Just skip the length checks, assuming
> that O_LARGEFILE is actually set.

So what this means is that on 32-bit systems, if we have a userspace
program which isn't using the Largefile-enabled, and it opens a file
which is larger than can be addressed with a 32-bit off_t, it can get
surprised and possibly cause data loss.

Is this something we are willing to live with?  After all, there was a
originally a really good reason for the O_LARGEFILE flag in the first
place, and it was primarily about making sure that a non-LARGEFILE
capable program would hard fail on the open, instead of after it had
trashed the user's data.  Granted that 32-bit systems are rarer these
days, and hopefully this isn't a situation that would come up that
often in embedded systems, but if breaking this functionality is
something that we are deliberately going to be doing, we should
discuss it explicitly, and document the decision in the commit
message.

Was there a reason that motivated this change, other than just an
clean up?

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
