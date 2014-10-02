Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 97BC37F63
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2014 05:42:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 77C298F8033
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2014 03:42:20 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KWJVyOcwqPLxkAan (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Oct 2014 03:42:19 -0700 (PDT)
Message-ID: <542D2BD7.8020704@redhat.com>
Date: Thu, 02 Oct 2014 11:41:27 +0100
From: Steven Whitehouse <swhiteho@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 02/12] gfs2: Set allowed quota types
References: <1412191894-9113-1-git-send-email-jack@suse.cz>
	<1412191894-9113-3-git-send-email-jack@suse.cz>
In-Reply-To: <1412191894-9113-3-git-send-email-jack@suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hi,

On 01/10/14 20:31, Jan Kara wrote:
> We support user and group quotas. Tell vfs about it.
>
> CC: Steven Whitehouse <swhiteho@redhat.com>
> CC: cluster-devel@redhat.com
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>   fs/gfs2/ops_fstype.c | 1 +
>   1 file changed, 1 insertion(+)
Acked-by: Steven Whitehouse <swhiteho@redhat.com>

Steve.

> diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
> index d3eae244076e..3032e6d069b5 100644
> --- a/fs/gfs2/ops_fstype.c
> +++ b/fs/gfs2/ops_fstype.c
> @@ -1083,6 +1083,7 @@ static int fill_super(struct super_block *sb, struct gfs2_args *args, int silent
>   	sb->s_xattr = gfs2_xattr_handlers;
>   	sb->s_qcop = &gfs2_quotactl_ops;
>   	sb_dqopt(sb)->flags |= DQUOT_QUOTA_SYS_FILE;
> +	sb_dqopt(sb)->allowed_types = (1 << USRQUOTA) | (1 << GRPQUOTA);
>   	sb->s_time_gran = 1;
>   	sb->s_maxbytes = MAX_LFS_FILESIZE;
>   

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
