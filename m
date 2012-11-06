Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA6H31SB076696 for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 11:03:01 -0600
Message-ID: <50994335.6020109@sgi.com>
Date: Tue, 06 Nov 2012 11:04:53 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v6 10/10] xfs: add background scanning to clear eofblocks
	inodes
References: <1352213447-59791-1-git-send-email-bfoster@redhat.com>
	<1352213447-59791-11-git-send-email-bfoster@redhat.com>
In-Reply-To: <1352213447-59791-11-git-send-email-bfoster@redhat.com>
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
> Create a new mount workqueue and delayed_work to enable background
> scanning and freeing of eofblocks inodes. The scanner kicks in once
> speculative preallocation occurs and stops requeueing itself when
> no eofblocks inodes exist.
>
> The scan interval is based on the new
> 'speculative_prealloc_lifetime' tunable (default to 5m). The
> background scanner performs unfiltered, best effort scans (which
> skips inodes under lock contention or with a dirty cache mapping).
>
> Signed-off-by: Brian Foster<bfoster@redhat.com>
> ---

Looks good. Nice series.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
