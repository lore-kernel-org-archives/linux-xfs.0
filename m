Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:51346 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751402AbeEPA5D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 May 2018 20:57:03 -0400
Date: Wed, 16 May 2018 10:57:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] xfs_io: add label command
Message-ID: <20180516005700.GM23861@dastard>
References: <5957a0ff-0fd7-c1f3-2d44-86b825c2eb3b@redhat.com>
 <ef558e14-5b31-4c5a-a07c-3d2ac67dd993@redhat.com>
 <20180515043241.GG23861@dastard>
 <d5db1a4e-4efe-30cb-4c8d-0a32f1f50a94@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5db1a4e-4efe-30cb-4c8d-0a32f1f50a94@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, May 15, 2018 at 10:06:53AM -0500, Eric Sandeen wrote:
> 
> 
> On 5/14/18 11:32 PM, Dave Chinner wrote:
> >On Mon, May 14, 2018 at 12:43:20PM -0500, Eric Sandeen wrote:
> >>This adds a get/set label command to xfs_io.
> >....
> >>+static int
> >>+label_f(
> >>+	int		argc,
> >>+	char		**argv)
> >>+{
> >>+	int		error;
> >>+	char		label[FSLABEL_MAX];
> >>+
> >>+	if (argc == 1) {
> >>+		memset(&label, 0, sizeof(label));
> >>+		error = ioctl(file->fd, FS_IOC_GET_FSLABEL, &label);
> >>+	} else {
> >>+		strncpy(label, argv[1], sizeof(label));
> >>+		error = ioctl(file->fd, FS_IOC_SET_FSLABEL, &label);
> >>+	}
> >>+
> >>+	if (error)
> >>+		perror("label");
> >
> >Need to set exitcode = 1 here so that xfs_io fails with a non-zero
> >exit status....
> >
> >>+	else
> >>+		printf("label = \"%s\"\n", label);
> >>+
> >>+	return error;
> >
> >Because this isn't the exit status - this is the "continue
> >processing the next command" return value. i.e. return 0 if we want
> >to continue, non-zero if we want to abort further CLI processing....
> 
> Hm, ok.  Today we only set exitcode for bmap, fiemap, freeze/thaw, and
> imap.  It's really consistently used at all, and needs an audit I guess.

You mean the audit I did 6 months ago?

https://www.spinics.net/lists/linux-xfs/msg13605.html

(which is why I know what the exitcode rules are. :)

The patch is still sitting around somewhere here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
