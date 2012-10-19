Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9JL1L1B060772 for <xfs@oss.sgi.com>; Fri, 19 Oct 2012 16:01:21 -0500
Message-ID: <5081BFFF.70603@sgi.com>
Date: Fri, 19 Oct 2012 16:02:55 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v5 00/10] speculative preallocation inode tracking
References: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
In-Reply-To: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
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

On 10/05/12 09:17, Brian Foster wrote:
> Hi all,
>
> This is v3 of the speculative preallocation inode tracking patchset. This
> functionality tracks inodes with post-EOF speculative preallocation for the
> purpose of background and on-demand trimming.
>
> Background scanning occurs on a longish interval (5 minutes by default) and in
> a best-effort mode (i.e., inodes are skipped due to lock contention or dirty
> cache). The intent is to clear up post-EOF blocks on inodes that might have
> allocations hanging around due to open-write-close sequences (NFS).
>
> On demand scanning is provided via a new ioctl and supports various parameters
> such as scan mode, filtering by quota id and minimum file size. A pending use
> case for on demand scanning is for accurate quota accounting via the gluster
> scale out filesystem (i.e., to free up preallocated space when near a usage
> limit).
>
> Brian

The series looks great.

I am just curious, what is the reason for the padding in the 
xfs_eofblocks structure?

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
