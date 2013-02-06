Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 619197F3F
	for <xfs@oss.sgi.com>; Wed,  6 Feb 2013 14:24:47 -0600 (CST)
Message-ID: <5112BC0B.7070702@sgi.com>
Date: Wed, 06 Feb 2013 14:24:43 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/2] xfs: conditionally force log on trylock failure
	of pinned/stale buf
References: <1360154681-28246-1-git-send-email-bfoster@redhat.com>
	<1360154681-28246-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1360154681-28246-2-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 02/06/13 06:44, Brian Foster wrote:
> xfs_force_log() is not safe from all contexts. Add a flag parameter
> to xfs_buf_trylock() to specify when the force is appropriate and
> create a macro to preserve current behavior.
>
> Signed-off-by: Brian Foster<bfoster@redhat.com>
> ---
>   fs/xfs/xfs_buf.c |    8 +++++---
>   fs/xfs/xfs_buf.h |    3 ++-
>   2 files changed, 7 insertions(+), 4 deletions(-)
>

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
