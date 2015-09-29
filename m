Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 69CA57F37
	for <xfs@oss.sgi.com>; Tue, 29 Sep 2015 17:25:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 28005304048
	for <xfs@oss.sgi.com>; Tue, 29 Sep 2015 15:25:05 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id rGPzLGIKPerKvRzg for <xfs@oss.sgi.com>;
	Tue, 29 Sep 2015 15:25:04 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id A228361A5FC0
	for <xfs@oss.sgi.com>; Tue, 29 Sep 2015 17:25:03 -0500 (CDT)
Subject: Re: [PATCH 1/2] xfs: always drain dio before extending aio write
	submission
References: <1443465481-63460-1-git-send-email-bfoster@redhat.com>
	<1443465481-63460-2-git-send-email-bfoster@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <560B0FBE.5010205@sandeen.net>
Date: Tue, 29 Sep 2015 17:25:02 -0500
MIME-Version: 1.0
In-Reply-To: <1443465481-63460-2-git-send-email-bfoster@redhat.com>
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
To: xfs@oss.sgi.com

Looks good to me, and tested w/ a testcase I'll send in a bit.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>


On 9/28/15 1:38 PM, Brian Foster wrote:
> XFS supports and typically allows concurrent asynchronous direct I/O
> submission to a single file. One exception to the rule is that file
> extending dio writes that start beyond the current EOF (e.g.,
> potentially create a hole at EOF) require exclusive I/O access to the
> file. This is because such writes must zero any pre-existing blocks
> beyond EOF that are exposed by virtue of now residing within EOF as a
> result of the write about to be submitted.
> 
> Before EOF zeroing can occur, the current file i_size must be stabilized
> to avoid data corruption. In this scenario, XFS upgrades the iolock to
> exclude any further I/O submission, waits on in-flight I/O to complete
> to ensure i_size is up to date (i_size is updated on dio write
> completion) and restarts the various checks against the state of the
> file. The problem is that this protection sequence is triggered only
> when the iolock is currently held shared. While this is true for async
> dio in most cases, the caller may upgrade the lock in advance based on
> arbitrary circumstances with respect to EOF zeroing. For example, the
> iolock is always acquired exclusively if the start offset is not block
> aligned. This means that even though the iolock is already held
> exclusive for such I/Os, pending I/O is not drained and thus EOF zeroing
> can occur based on an unstable i_size.
> 
> This problem has been reproduced as guest data corruption in virtual
> machines with file-backed qcow2 virtual disks hosted on an XFS
> filesystem. The virtual disks must be configured with aio=native mode
> and the must not be truncated out to the maximum file size (as some virt
> managers will do).
> 
> Update xfs_file_aio_write_checks() to unconditionally drain in-flight
> dio before EOF zeroing can occur. Rather than trigger the wait based on
> iolock state, use a new flag and upgrade the iolock when necessary. Note
> that this results in a full restart of the inode checks even when the
> iolock was already held exclusive when technically it is only required
> to recheck i_size. This should be a rare enough occurrence that it is
> preferable to keep the code simple rather than create an alternate
> restart jump target.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_file.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index e78feb4..347b3e0 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -574,6 +574,7 @@ xfs_file_aio_write_checks(
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	ssize_t			error = 0;
>  	size_t			count = iov_iter_count(from);
> +	bool			drained_dio = false;
>  
>  restart:
>  	error = generic_write_checks(iocb, from);
> @@ -611,12 +612,13 @@ restart:
>  		bool	zero = false;
>  
>  		spin_unlock(&ip->i_flags_lock);
> -		if (*iolock == XFS_IOLOCK_SHARED) {
> -			xfs_rw_iunlock(ip, *iolock);
> -			*iolock = XFS_IOLOCK_EXCL;
> -			xfs_rw_ilock(ip, *iolock);
> -			iov_iter_reexpand(from, count);
> -
> +		if (!drained_dio) {
> +			if (*iolock == XFS_IOLOCK_SHARED) {
> +				xfs_rw_iunlock(ip, *iolock);
> +				*iolock = XFS_IOLOCK_EXCL;
> +				xfs_rw_ilock(ip, *iolock);
> +				iov_iter_reexpand(from, count);
> +			}
>  			/*
>  			 * We now have an IO submission barrier in place, but
>  			 * AIO can do EOF updates during IO completion and hence
> @@ -626,6 +628,7 @@ restart:
>  			 * no-op.
>  			 */
>  			inode_dio_wait(inode);
> +			drained_dio = true;
>  			goto restart;
>  		}
>  		error = xfs_zero_eof(ip, iocb->ki_pos, i_size_read(inode), &zero);
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
