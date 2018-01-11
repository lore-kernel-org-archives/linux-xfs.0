Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34792 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753715AbeAKXZ7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jan 2018 18:25:59 -0500
Subject: Re: [PATCH 21/27] xfs_scrub: scrub file data blocks
References: <151520348769.2027.9860697266310422360.stgit@magnolia>
 <151520361807.2027.808101481520701260.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <282321ba-d611-3fdc-7fc5-033f53cf0a5c@sandeen.net>
Date: Thu, 11 Jan 2018 17:25:58 -0600
MIME-Version: 1.0
In-Reply-To: <151520361807.2027.808101481520701260.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org



On 1/5/18 7:53 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>

...

> +		/* Get the stat info for this directory entry. */
> +		error = fstatat(dir_fd, dirent->d_name, &sb,
> +				AT_NO_AUTOMOUNT | AT_SYMLINK_NOFOLLOW);
> +		if (error) {
> +			str_errno(ctx, newpath);
> +			continue;

I needed:

+#ifndef AT_NO_AUTOMOUNT
+#define AT_NO_AUTOMOUNT 0x800
+#endif

here

-Eric
