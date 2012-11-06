Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA6GdLtH074866 for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 10:39:21 -0600
Message-ID: <50993DAC.9070100@sgi.com>
Date: Tue, 06 Nov 2012 10:41:16 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v6 07/10] xfs: add inode id filtering to eofblocks scan
References: <1352213447-59791-1-git-send-email-bfoster@redhat.com>
	<1352213447-59791-8-git-send-email-bfoster@redhat.com>
In-Reply-To: <1352213447-59791-8-git-send-email-bfoster@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 11/06/12 08:50, Brian Foster wrote:
> Support inode ID filtering in the eofblocks scan. The caller must
> set the associated XFS_EOF_FLAGS_*ID bit and ID field.
>
> Signed-off-by: Brian Foster<bfoster@redhat.com>
> ---

turn 0;
>
> +	if (eofb&&

		vvvvvvv
> +	    (eofb->eof_flags&  (XFS_EOF_FLAGS_UID|XFS_EOF_FLAGS_GID|
> +			       XFS_EOF_FLAGS_PRID))&&
		^^^^^^
Not a big deal but wouldn't xfs_inode_match_id() also check these flags?

> +	    !xfs_inode_match_id(ip, eofb))
> +		return 0;
> +


Consider this

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
