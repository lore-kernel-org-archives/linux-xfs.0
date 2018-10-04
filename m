Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48150 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727354AbeJECH5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Oct 2018 22:07:57 -0400
Subject: Re: [PATCH v3 0/8] xfsprogs-4.19: transaction cleanups
References: <153841345236.27952.5050172703525712660.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6233116e-24bd-bd7c-d19d-883887953335@sandeen.net>
Date: Thu, 4 Oct 2018 14:13:19 -0500
MIME-Version: 1.0
In-Reply-To: <153841345236.27952.5050172703525712660.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org



On 10/1/18 12:04 PM, Darrick J. Wong wrote:
> Here are seven cleanups to the userspace transaction code that make the
> commit and roll code more closely resemble their kernel counterparts,
> and fix a number of problems where client code did not check the return
> values of the transaction functions.  The eighth patch fixes a bug in
> xfs_scrub_all.  The patches should apply to Eric's libxfs-4.19-sync
> branch.
> 
> --D
> 

You're going to hate me (or maybe not) but in the end I decided to stop
being stubborn and bring in these patches before the libxfs-4.19 up[date,
as I should have from the start.  You don't have to rebase them again tho,
I already got through it.  I'll diff to your tree to make sure nothing went
haywire.

For the series with my out of order backporting tweaks,

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks, this was great work.

-Eric
