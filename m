Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37184 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1948823AbdEZXGs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 May 2017 19:06:48 -0400
Subject: Re: [PATCH 6/9] xfs_spaceman: AG state control
References: <149417257252.24656.2629280196308754994.stgit@birch.djwong.org>
 <149417261413.24656.8374342916847767840.stgit@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2b192db0-ebda-e42e-a326-66bf61b3c6ca@sandeen.net>
Date: Fri, 26 May 2017 18:06:46 -0500
MIME-Version: 1.0
In-Reply-To: <149417261413.24656.8374342916847767840.stgit@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On 5/7/17 10:56 AM, Darrick J. Wong wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add support for a new allocation group state control ioctl. This
> allows control of various AG parameters, such as whether inode
> allocation is allowed in the AG, metadata preference, whether new
> allocations are allowed, etc. This requires a new ioctl.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> [darrick: change xfsctl to ioctl]
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Sounds like a great patch to send if this ever gets implemented in
the kernel; for now, I think, I'll not merge it.  :)

-Eric


