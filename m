Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF484AA013;
	Mon,  5 Oct 2026 14:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791212146; cv=none; b=lZAX0SmwvsOjyNhyRWtjLT3BEWQGL96iir2IPZF8vYtVWqMlicLwJ5B/qEz23OTxSFfVewVPhdtTnr1kLI+TrzU+V1Wzj9jRUL03Z+iBY9WTk3XCGMX3EC+VasM6wjvnAZx6Ef6YjmnYbhzhtLsnCThNLW6gr6w/TuS72VSieIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791212146; c=relaxed/simple;
	bh=erc641/IkjQwNEl073cmLmJeWofoXp3MfKAudy7qOxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rOnsJjvfmtfd3c7Krk4IKxhtmdiv/xcoUGVO+T8qUF/jqcn0fFeDDgJnw90A8m0szfJJI3qVcacVwvjKx4DJTTERL9CoXCDNzc4S/Pi6oOZP9Cku7QBL8opBrEl6Mx8o5BM4cLbjLtMDMkOmwYRoYU8LoHM9DA6tK6m///fZ1gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CE80168AFE; Mon,  5 Oct 2026 16:55:35 +0200 (CEST)
Date: Mon, 5 Oct 2026 16:55:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/13] xfs: add a _require_xfs_data_csum helper
Message-ID: <20261005145535.GA2082@lst.de>
References: <20260924100855.2734089-1-hch@lst.de> <20260924100855.2734089-6-hch@lst.de> <20260929013850.GH2705364@frogsfrogsfrogs> <20261005132029.GJ26805@lst.de> <20261005144856.GA2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005144856.GA2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Oct 05, 2026 at 07:48:56AM -0700, Darrick J. Wong wrote:
> Oh wow, a new ioctl.  Having not tried to do anything with it, it looks
> promising.  Would it be useful for a filesystem with software checksums
> to advertise something like this:
> 
> struct logical_block_metadata_cap foo = {
> 	.lbmd_flags = LBMD_FS_CSUM_CRC32C, /* doesn't yet exist */
> 	.lbmd_interval = i_blocksize(...),
> 	.lbmd_size = 4,
> };

Yes, see the patch below for that below, It might or might not apply to
the current series, but it should give you the idea.

> Even though userspace cannot (yet) access the per-fsblock crc32c data?

Well, I want that to be possible eventually.  I even have working code,
but it has too many layering violations to publish it at the moment.

> Also, if the fs supports per-fsblock checksums and the storage supports
> per-LBA PI, which gets advertised?

Wherever the file systems wants to store it because it intercepts both
the ioctl and the io_uring with metadata ops. So probably is it's own
location.  I should probably add a test for xfs crcs on top of PI to
make sure nothing breaks this..

---
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 96ca3e480cb9..6aa3e7f78eb5 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -46,6 +46,7 @@
 #include "xfs_verify_media.h"
 #include "xfs_zone_priv.h"
 #include "xfs_zone_alloc.h"
+#include "xfs_rtcsum.h"
 
 #include <linux/mount.h>
 #include <linux/fileattr.h>
@@ -1200,6 +1201,36 @@ xfs_ioctl_fs_counts(
 	return 0;
 }
 
+static int
+xfs_ioc_getlbmd_cap(
+	struct xfs_inode		*ip,
+	unsigned int			cmd,
+	struct logical_block_metadata_cap __user *argp)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+	size_t				usize = _IOC_SIZE(cmd);
+	struct logical_block_metadata_cap lbm = {};
+
+	if (xfs_is_rtcsum_inode(ip)) {
+		lbm.lbmd_flags |= LBMD_PI_CAP_INTEGRITY;
+		lbm.lbmd_interval = mp->m_sb.sb_blocksize;
+		lbm.lbmd_pi_size = 1U << mp->m_rtcsum_shift;
+		lbm.lbmd_size = lbm.lbmd_pi_size;
+		switch (mp->m_sb.sb_rtcsum) {
+		case XFS_CSUM_TYPE_CRC32C:
+			lbm.lbmd_guard_tag_type = LBMD_PI_CSUM_CRC32C;
+			break;
+		case XFS_CSUM_TYPE_CRC64:
+			lbm.lbmd_guard_tag_type = LBMD_PI_CSUM_CRC64_NVME;
+			break;
+		default:
+			WARN_ON_ONCE(1);
+		}
+	}
+
+	return copy_struct_to_user(argp, usize, &lbm, sizeof(lbm), NULL);
+}
+
 /*
  * These long-unused ioctls were removed from the official ioctl API in 5.17,
  * but retain these definitions so that we can log warnings about them.
@@ -1467,6 +1498,9 @@ xfs_file_ioctl(
 		return xfs_ioc_verify_media(filp, arg);
 
 	default:
+		if (extensible_ioctl_valid(cmd, FS_IOC_GETLBMD_CAP,
+				LBMD_SIZE_VER0))
+			return xfs_ioc_getlbmd_cap(ip, cmd, arg);
 		return -ENOTTY;
 	}
 }
