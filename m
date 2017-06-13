Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42654 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751801AbdFMIiU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Jun 2017 04:38:20 -0400
Date: Tue, 13 Jun 2017 16:38:17 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [xfstests PATCH v4 2/5] ext4: allow ext4 to use $SCRATCH_LOGDEV
Message-ID: <20170613083817.GD4788@eguan.usersys.redhat.com>
References: <20170612124213.14855-1-jlayton@redhat.com>
 <20170612124213.14855-3-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170612124213.14855-3-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>, tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org

On Mon, Jun 12, 2017 at 08:42:10AM -0400, Jeff Layton wrote:
> The writeback error handling test requires that you put the journal on a
> separate device. This allows us to use dmerror to simulate data
> writeback failure, without affecting the journal.
> 
> xfs already has infrastructure for this (a'la $SCRATCH_LOGDEV), so wire
> up the ext4 code so that it can do the same thing when _scratch_mkfs is
> called.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  common/rc | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 87e6ff08b18d..08807ac7c22a 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -676,6 +676,9 @@ _scratch_mkfs_ext4()
>  	local tmp=`mktemp`
>  	local mkfs_status
>  
> +	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
> +	    $mkfs_cmd -O journal_dev $SCRATCH_LOGDEV && \
> +	    mkfs_cmd="$mkfs_cmd $MKFS_OPTIONS -J device=$SCRATCH_LOGDEV"

This $MKFS_OPTIONS should be added to the first command when creating
the journal device so that journal dev has the same block size as data
dev, there's no need to update mkfs_cmd string.

The external log dev support for ext3 patch has similar issue.

Thanks,
Eryu

>  
>  	_scratch_do_mkfs "$mkfs_cmd" "$mkfs_filter" $* 2>$tmp.mkfserr 1>$tmp.mkfsstd
>  	mkfs_status=$?
> -- 
> 2.13.0
> 
