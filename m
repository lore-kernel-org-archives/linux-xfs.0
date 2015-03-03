Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0BC487F47
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 14:39:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EED0C8F804C
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 12:39:47 -0800 (PST)
Received: from smtprelay.hostedemail.com (smtprelay0214.hostedemail.com
	[216.40.44.214]) by cuda.sgi.com with ESMTP id gVXG3sqsEqtkSy0i
	for <xfs@oss.sgi.com>; Tue, 03 Mar 2015 12:39:46 -0800 (PST)
Message-ID: <1425415182.17273.59.camel@perches.com>
Subject: Re: [PATCH 1/1 linux-next] xfs: use bool instead of int for new_parent
From: Joe Perches <joe@perches.com>
Date: Tue, 03 Mar 2015 12:39:42 -0800
In-Reply-To: <1425410469-26098-1-git-send-email-fabf@skynet.be>
References: <1425410469-26098-1-git-send-email-fabf@skynet.be>
Mime-Version: 1.0
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
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, 2015-03-03 at 20:21 +0100, Fabian Frederick wrote:
> new_parent is only used in 0/1 context.
[]
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
[]
> @@ -2860,7 +2860,7 @@ xfs_rename(
>  {
>  	xfs_trans_t	*tp = NULL;
>  	xfs_mount_t	*mp = src_dp->i_mount;
> -	int		new_parent;		/* moving to a new dir */
> +	bool		new_parent;		/* moving to a new dir */
>  	int		src_is_directory;	/* src_name is a directory */

Could convert src_is_directory to bool too.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
