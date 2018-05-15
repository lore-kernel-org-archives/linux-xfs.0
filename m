Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:18335 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750952AbeEOEdZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 May 2018 00:33:25 -0400
Date: Tue, 15 May 2018 14:32:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] xfs_io: add label command
Message-ID: <20180515043241.GG23861@dastard>
References: <5957a0ff-0fd7-c1f3-2d44-86b825c2eb3b@redhat.com>
 <ef558e14-5b31-4c5a-a07c-3d2ac67dd993@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef558e14-5b31-4c5a-a07c-3d2ac67dd993@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, May 14, 2018 at 12:43:20PM -0500, Eric Sandeen wrote:
> This adds a get/set label command to xfs_io.
....
> +static int
> +label_f(
> +	int		argc,
> +	char		**argv)
> +{
> +	int		error;
> +	char		label[FSLABEL_MAX];
> +
> +	if (argc == 1) {
> +		memset(&label, 0, sizeof(label));
> +		error = ioctl(file->fd, FS_IOC_GET_FSLABEL, &label);
> +	} else {
> +		strncpy(label, argv[1], sizeof(label));
> +		error = ioctl(file->fd, FS_IOC_SET_FSLABEL, &label);
> +	}
> +
> +	if (error)
> +		perror("label");

Need to set exitcode = 1 here so that xfs_io fails with a non-zero
exit status....

> +	else
> +		printf("label = \"%s\"\n", label);
> +
> +	return error;

Because this isn't the exit status - this is the "continue
processing the next command" return value. i.e. return 0 if we want
to continue, non-zero if we want to abort further CLI processing....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
