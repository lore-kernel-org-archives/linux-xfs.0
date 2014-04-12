Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 50A367F55
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 09:06:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D8994AC001
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 07:06:43 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id J3WBvL6K4J5YTnab (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 12 Apr 2014 07:06:39 -0700 (PDT)
Date: Sat, 12 Apr 2014 10:06:33 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] fs: Disallow all fallocate operation on active
	swapfile
Message-ID: <20140412140633.GD13837@thunk.org>
References: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
	<1397242665-2183-4-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397242665-2183-4-git-send-email-lczerner@redhat.com>
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
Cc: linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Fri, Apr 11, 2014 at 08:57:45PM +0200, Lukas Czerner wrote:
> Currently some file system have IS_SWAPFILE check in their fallocate
> implementations and some does not. However we should really prevent any
> fallocate operation on swapfile so move the check to vfs and remove the
> redundant checks from the file systems fallocate implementations.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/ceph/file.c    | 3 ---
>  fs/ext4/extents.c | 5 -----
>  fs/ext4/inode.c   | 5 -----
>  fs/open.c         | 7 +++++++
>  4 files changed, 7 insertions(+), 13 deletions(-)

Thanks, applied.  Again, if anyone has an objections with my carrying
these patches in the ext4 tree and pushing them to Linus shortly after
-rc1, please let me know.

					- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
