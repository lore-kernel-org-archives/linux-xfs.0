Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:51809 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725535AbfAaDlK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Jan 2019 22:41:10 -0500
Date: Thu, 31 Jan 2019 14:41:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] ext4: add link file support for {GET,SET}XATTR ioctl
Message-ID: <20190131034106.GJ4205@dastard>
References: <1548899232-30311-1-git-send-email-wshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1548899232-30311-1-git-send-email-wshilong1991@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-fs@vger.kernel.org, linux-xfs@vger.kernel.org, Wang Shilong <wshilong@ddn.com>, Andreas Dilger <adilger@dilger.ca>, Li Xi <lixi@ddn.com>

On Thu, Jan 31, 2019 at 10:47:12AM +0900, Wang Shilong wrote:
> From: Wang Shilong <wshilong@ddn.com>
> 
> Currently there is no way to change project ID of
> symlink file itself, this is important to implement
> Directory quota for an existed directory.

This seems like something open(O_PATH|O_NOFOLLOW) should allow.
from open(2):

	If pathname is a symbolic link and the O_NOFOLLOW flag is
	also specified, then the call returns a file  descriptor
	referring  to  the symbolic  link.  This  file  descriptor
	can  be used as the dirfd argument in calls to fchownat(2),
	fstatat(2), linkat(2), and read¿ linkat(2) with an empty
	pathname to have the calls operate on the symbolic link.

Changing the project id is the equivalent of fchownat().....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
