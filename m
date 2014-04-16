Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1B24F7F4E
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 21:55:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E818A30407E
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 19:55:23 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id b3t0WzI8hlhiHiaM (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 19:55:22 -0700 (PDT)
Date: Tue, 15 Apr 2014 22:55:21 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3 v2] fs: move falloc collapse range check into the
	filesystem methods
Message-ID: <20140416025521.GC21807@thunk.org>
References: <1397580076-19826-1-git-send-email-lczerner@redhat.com>
	<1397580076-19826-3-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397580076-19826-3-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Tue, Apr 15, 2014 at 06:41:16PM +0200, Lukas Czerner wrote:
> Currently in do_fallocate in collapse range case we're checking whether
> offset + len is not bigger than i_size. However there is nothing which
> would prevent i_size from changing so the check is pointless. It should
> be done in the file system itself and the file system needs to make sure
> that i_size is not going to change. The i_size check for the other
> fallocate modes are also done in the filesystems.
> 
> As it is now we can easily crash kernel by having two processes doing
> truncate and fallocate collapse range at the same time. This can be
> reproduced on ext4 and it is theoretically possible on xfs even though I
> was not able to trigger it with this simple test.
> 
> This commit removes the check from do_fallocate and adds it to the file
> system.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Acked-by: Dave Chinner <david@fromorbit.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks, updated.

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
