Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF31235F60B
	for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 15:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776093209; cv=none; b=JvgUtO+MhSZ5sRt96MnQaR1Yt1idfMpZyic1IxS+XrSsSxtP2OXIqK8tL52O9vh6eRofw78UkF26gutM6NJg3ZMTIJzGKhHLtD7KJiH1vp+m+7lChs4re9p/Gp2XjUyHmoym7IiBIlMo8R9qtiFZfCY70C1gu8uFKpV3vLsFqYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776093209; c=relaxed/simple;
	bh=JVGL4GBxXaO84FaTWRmuzty94Mvq7kJryG7iU6OF7CQ=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=sldaWblENGMjrZyjY0bnQblQYmBdu93L94pBOW6LYXViCuChxmODVBpdGJ54C0sz8kO9tILTiTa0P9NnuMlvbUj7pmbM4gfU8JIO8N2h37lS0MtAZgI60lQopGAmstxmlCF8A8k1twMVry0RqdKJHs+QwfJCPW688bGkrOsPfhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id A1137180F2C1;
	Mon, 13 Apr 2026 17:05:41 +0200 (CEST)
Received: from mail.herbolt.com ([172.168.31.10])
	by mx0.herbolt.com with ESMTPSA
	id r/66HUUG3WlTdgYAKEJqOA
	(envelope-from <lukas@herbolt.com>); Mon, 13 Apr 2026 17:05:41 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 13 Apr 2026 17:05:41 +0200
From: Lukas Herbolt <lukas@herbolt.com>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, "Darrick J . Wong"
 <djwong@kernel.org>, dgc@kernel.org, gost.dev@samsung.com,
 pankaj.raghav@linux.dev, kundan.kumar@samsung.com, cem@kernel.org,
 hch@infradead.org
Subject: Re: [PATCH v2 2/2] xfs: add support for FALLOC_FL_WRITE_ZEROES
In-Reply-To: <20260413133256.3378243-3-p.raghav@samsung.com>
References: <20260413133256.3378243-1-p.raghav@samsung.com>
 <20260413133256.3378243-3-p.raghav@samsung.com>
Message-ID: <c086dc6d3c95d1aed1ac0950ef3278ea@herbolt.com>
X-Sender: lukas@herbolt.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

On 2026-04-13 15:32, Pankaj Raghav wrote:
> If the underlying block device supports the unmap write zeroes
> operation, this flag allows users to quickly preallocate a file with
> written extents that contain zeroes. This is beneficial for subsequent
> overwrites as it prevents the need for unwritten-to-written extent
> conversions, thereby significantly reducing metadata updates and 
> journal
> I/O overhead, improving overwrite performance.
> 
> Co-developed-by: Lukas Herbolt <lukas@herbolt.com>
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  fs/xfs/xfs_file.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 55 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 845a97c9b063..99a02982154a 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1368,6 +1368,57 @@ xfs_falloc_force_zero(
>  	return XFS_TEST_ERROR(ip->i_mount, XFS_ERRTAG_FORCE_ZERO_RANGE);
>  }
> 
> +static int
> +xfs_falloc_write_zeroes(
> +	struct file		*file,
> +	int			mode,
> +	loff_t			offset,
> +	loff_t			len,
> +	struct xfs_zone_alloc_ctx *ac)
> +{
> +	struct inode		*inode = file_inode(file);
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	loff_t			new_size = 0;
> +	loff_t			old_size = XFS_ISIZE(ip);
> +	int			error;
> +	unsigned int		blksize = i_blocksize(inode);
> +	loff_t			offset_aligned = round_down(offset, blksize);
> +	bool			did_zero;
> +
> +	if (xfs_is_always_cow_inode(ip) ||
> +	    !bdev_write_zeroes_unmap_sectors(
> +		    xfs_inode_buftarg(XFS_I(inode))->bt_bdev))
> +		return -EOPNOTSUPP;
> +
> +	error = xfs_falloc_newsize(file, mode, offset, len, &new_size);
> +	if (error)
> +		return error;
> +
> +	error = xfs_free_file_space(ip, offset, len, ac);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Zero the tail of the old EOF block and any space up to the new
> +	 * offset.
> +	 * In the usual truncate path, xfs_falloc_setsize takes care of
> +	 * zeroing those blocks.
> +	 */
> +	if (offset_aligned > old_size)
> +		error = xfs_zero_range(ip, old_size, offset_aligned - old_size,
> +				NULL, &did_zero);
> +	if (error)
> +		return error;
> +
> +	error = xfs_bmap_alloc_or_convert_range(ip, offset, len,
> +			XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO,
> +			new_size ? true : false);
> +	if (error)
> +		return error;
> +
> +	return error;
> +}
> +
>  /*
>   * Punch a hole and prealloc the range.  We use a hole punch rather 
> than
>   * unwritten extent conversion for two reasons:
> @@ -1470,7 +1521,7 @@ xfs_falloc_allocate_range(
>  		(FALLOC_FL_ALLOCATE_RANGE | FALLOC_FL_KEEP_SIZE |	\
>  		 FALLOC_FL_PUNCH_HOLE |	FALLOC_FL_COLLAPSE_RANGE |	\
>  		 FALLOC_FL_ZERO_RANGE |	FALLOC_FL_INSERT_RANGE |	\
> -		 FALLOC_FL_UNSHARE_RANGE)
> +		 FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_WRITE_ZEROES)
> 
>  STATIC long
>  __xfs_file_fallocate(
> @@ -1522,6 +1573,9 @@ __xfs_file_fallocate(
>  	case FALLOC_FL_ALLOCATE_RANGE:
>  		error = xfs_falloc_allocate_range(file, mode, offset, len);
>  		break;
> +	case FALLOC_FL_WRITE_ZEROES:
> +		error = xfs_falloc_write_zeroes(file, mode, offset, len, ac);
> +		break;
>  	default:
>  		error = -EOPNOTSUPP;
>  		break;

I have debug option to skip the check of LBPRZ/DLFEAT on the underlying
device for testing on regular devices.

+       if (xfs_is_always_cow_inode(ip) ||
+           
!bdev_write_zeroes_unmap_sectors(xfs_inode_buftarg(ip)->bt_bdev)) {
+#ifdef DEBUG
+               if (!xfs_globals.allow_write_zero)
+#endif
+                       return -EOPNOTSUPP;


diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 4527119b2961..3436e6b574dd 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -314,6 +314,29 @@ bload_node_slack_show(
  }
  XFS_SYSFS_ATTR_RW(bload_node_slack);

+static ssize_t
+allow_write_zero_store(
+       struct kobject  *kobject,
+       const char      *buf,
+       size_t          count)
+{
+       ssize_t         ret;
+
+       ret = kstrtobool(buf, &xfs_globals.allow_write_zero);
+       if (ret < 0)
+               return ret;
+       return count;
+}
+
+static ssize_t
+allow_write_zero_show(
+       struct kobject  *kobject,
+       char            *buf)
+{
+       return sysfs_emit(buf, "%d\n", xfs_globals.allow_write_zero);
+}
+XFS_SYSFS_ATTR_RW(allow_write_zero);
+
  static struct attribute *xfs_dbg_attrs[] = {
         ATTR_LIST(bug_on_assert),
         ATTR_LIST(log_recovery_delay),
@@ -323,6 +346,7 @@ static struct attribute *xfs_dbg_attrs[] = {
         ATTR_LIST(larp),
         ATTR_LIST(bload_leaf_slack),
         ATTR_LIST(bload_node_slack),
+       ATTR_LIST(allow_write_zero),
         NULL,
  };
  ATTRIBUTE_GROUPS(xfs_dbg);

diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
index ed9d896079c1..464cdfb22f5b 100644
--- a/fs/xfs/xfs_sysctl.h
+++ b/fs/xfs/xfs_sysctl.h
@@ -86,6 +86,7 @@ struct xfs_globals {
         int     mount_delay;            /* mount setup delay (secs) */
         bool    bug_on_assert;          /* BUG() the kernel on assert 
failure */
         bool    always_cow;             /* use COW fork for all 
overwrites */
+       bool    allow_write_zero;       /* Allow WRITE_ZERO on any HW */
  };
  extern struct xfs_globals      xfs_globals;


-- 
-lhe
