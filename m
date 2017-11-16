Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:50232 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933354AbdKPTNN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Nov 2017 14:13:13 -0500
Subject: Re: [PATCH for 4.15] libxfs: fix dev_t handling in inode forks
References: <20171116011505.GH5119@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b87c8048-ab4f-688a-6bd1-10b520c4779c@sandeen.net>
Date: Thu, 16 Nov 2017 13:13:11 -0600
MIME-Version: 1.0
In-Reply-To: <20171116011505.GH5119@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On 11/15/17 7:15 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In commit 699f676961 ("xfs: remove if_rdev"), some ancient definitions
> of MAJOR/MINOR/MKDEV were ported into libxfs.  However, platform_defs.h
> already has IRIX_DEV_* macros which encode a (major, minor) tuple into a
> (major:14, minor:18) u32 format.  libxfs writes these values to disk
> without any further interpretation.

Thanks for spotting, that was dumb on my part.  Rather than fixing what
I intended to be a RFC/WIP branch with this commit, I plan to include
your changes in the original commit to fix it up, credit you, and
rebase that branch.  There are a couple other reasons to rebase as well.

After 4.14 gets pushed out I'll merge the libxfs-4.15 sync branch to for-next.

-Eric


