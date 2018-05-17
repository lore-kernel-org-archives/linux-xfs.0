Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:41496 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751734AbeEQV46 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 May 2018 17:56:58 -0400
Date: Fri, 18 May 2018 07:56:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5 V3] xfs_io: add label command
Message-ID: <20180517215655.GA23861@dastard>
References: <5957a0ff-0fd7-c1f3-2d44-86b825c2eb3b@redhat.com>
 <ef558e14-5b31-4c5a-a07c-3d2ac67dd993@redhat.com>
 <0f9a7c17-233c-042a-5449-acd7e0a27316@sandeen.net>
 <9cee370a-41e2-6dae-4ae1-97fbd7393d38@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cee370a-41e2-6dae-4ae1-97fbd7393d38@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, May 17, 2018 at 10:22:09AM -0500, Eric Sandeen wrote:
> This adds an online get/set/clear label command to xfs_io.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> +static int
> +label_f(
> +	int		argc,
> +	char		**argv)
> +{
> +	int		c;
> +	int		error;
> +	char		label[FSLABEL_MAX];
> +
> +	if (argc == 1) {
> +		memset(label, 0, sizeof(label));
> +		error = ioctl(file->fd, FS_IOC_GETFSLABEL, &label);
> +		goto out;
> +	}
> +
> +	while ((c = getopt(argc, argv, "cs:")) != EOF) {
> +		switch (c) {
> +		case 'c':
> +			label[0] = '\0';
> +			break;
> +		case 's':
> +			strncpy(label, optarg, sizeof(label));
> +			break;
> +		default:

			exitcode = 1
			;
> +			return command_usage(&label_cmd);
> +		}
> +	}
> +
> +	/* Check for trailing arguments */
> +	if (argc != optind)

		exitcode = 1

> +		return command_usage(&label_cmd);
> +
> +	error = ioctl(file->fd, FS_IOC_SETFSLABEL, label);
> +out:
> +	if (error) {
> +		perror("label");
> +		exitcode = 1;
> +	} else {
> +		printf("label = \"%s\"\n", label);
> +	}
> +
> +	return 0;

Otherwise looks OK.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
