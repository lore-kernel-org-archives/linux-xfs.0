Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3348A7C8C
	for <xfs@oss.sgi.com>; Fri, 19 Feb 2016 11:50:05 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B590AAC003
	for <xfs@oss.sgi.com>; Fri, 19 Feb 2016 09:49:58 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id HGcESNmVoLWUXFnB for <xfs@oss.sgi.com>;
	Fri, 19 Feb 2016 09:31:59 -0800 (PST)
Subject: Re: [PATCH 1/3] quota: Add support for ->get_nextdqblk() for VFS quota
References: <1454596087-6814-1-git-send-email-jack@suse.cz>
	<1454596087-6814-2-git-send-email-jack@suse.cz>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56C7518E.4020204@sandeen.net>
Date: Fri, 19 Feb 2016 11:31:58 -0600
MIME-Version: 1.0
In-Reply-To: <1454596087-6814-2-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com



On 2/4/16 8:28 AM, Jan Kara wrote:
> Add infrastructure for supporting get_nextdqblk() callback for VFS
> quotas. Translate the operation into a callback to appropriate
> filesystem and consequently to quota format callback.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/super.c          |  1 +
>  fs/quota/dquot.c         | 39 +++++++++++++++++++++++++++++++++++++++
>  fs/reiserfs/super.c      |  1 +
>  include/linux/quota.h    |  3 +++
>  include/linux/quotaops.h |  3 +++
>  5 files changed, 47 insertions(+)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index f1b56ff01208..51649f442bf6 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1100,6 +1100,7 @@ static const struct dquot_operations ext4_quota_operations = {
>  	.write_info	= ext4_write_info,
>  	.alloc_dquot	= dquot_alloc,
>  	.destroy_dquot	= dquot_destroy,
> +	.get_next_id	= dquot_get_next_id,
>  };

Hi Jan, doesn't this also need to set:


+       .get_nextdqblk  = dquot_get_next_dqblk,

in ext4_qctl_sysfile_operations?

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
