Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EA0387F4E
	for <xfs@oss.sgi.com>; Mon,  6 Oct 2014 15:30:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8448DAC004
	for <xfs@oss.sgi.com>; Mon,  6 Oct 2014 13:30:32 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	k3YDzrROjKUqto1h for <xfs@oss.sgi.com>;
	Mon, 06 Oct 2014 13:30:30 -0700 (PDT)
Date: Tue, 7 Oct 2014 07:30:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/12] xfs: Set allowed quota types
Message-ID: <20141006203028.GB2301@dastard>
References: <1412191894-9113-1-git-send-email-jack@suse.cz>
	<1412191894-9113-4-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1412191894-9113-4-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com

On Wed, Oct 01, 2014 at 09:31:25PM +0200, Jan Kara wrote:
> We support user, group, and project quotas. Tell VFS about it.
> 
> CC: xfs@oss.sgi.com
> CC: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/xfs/xfs_super.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index b194652033cd..b32e998e8cbc 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1419,6 +1419,8 @@ xfs_fs_fill_super(
>  	sb->s_export_op = &xfs_export_operations;
>  #ifdef CONFIG_XFS_QUOTA
>  	sb->s_qcop = &xfs_quotactl_operations;
> +	sb->s_dquot.allowed_types = (1 << USRQUOTA) | (1 << GRPQUOTA) |
> +				    (1 << PRJQUOTA);

Would it be better to define masks for these rather than open
coding these shifts everywhere?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
