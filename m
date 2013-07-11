Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9BC007FA0
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 03:11:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 862658F80A3
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 01:11:23 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	A4KGPvABiap9cEso for <xfs@oss.sgi.com>;
	Thu, 11 Jul 2013 01:11:21 -0700 (PDT)
Date: Thu, 11 Jul 2013 18:11:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v11 3/4] xfs: Add proper versioning support to
	fs_quota_stat
Message-ID: <20130711081113.GD3438@dastard>
References: <1373518843-1492-1-git-send-email-sekharan@us.ibm.com>
	<1373518843-1492-4-git-send-email-sekharan@us.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1373518843-1492-4-git-send-email-sekharan@us.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: jack@suse.cz, swhiteho@redhat.com, xfs@oss.sgi.com

On Thu, Jul 11, 2013 at 12:00:42AM -0500, Chandra Seetharaman wrote:
> Added appropriate pads and code for backward compatibility.
> 
> Copied over the old version as it is different from the newer padded
> version.
> 
> New callers of the system call have to set the version of the data
> structure being passed, and kernel will fill as much data as requested.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Oh, and I forgot to mention:

> +		/*
> +		 * For forward compatibility. Check against all supported
> +		 * versions, and if the version provided is not supported
> +		 * by the kernel, set to the highest version supported.
> +		 * For now only FS_QSTAT_VERSION_2 is supported.
> +		 */
> +		if (fqs.qs_version != FS_QSTAT_VERSION_2)
> +			fqs.qs_version = FS_QSTAT_VERSION_2;

New API, new version number and enforcement: if the version number
passed in from userspace  is not understood, -EINVAL or an
equivalent "parameter not understood" error should be returned.
If the kernel doesn't understand what it is being passed, then
there's no guarantee that anything quota info we return can be
understood by the caller.

And while I remember, we'll also need quotactl(2) man page updates
for the new API.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
