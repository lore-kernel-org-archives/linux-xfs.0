Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38154 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750761AbdE3Sab (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 May 2017 14:30:31 -0400
Date: Tue, 30 May 2017 11:30:22 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/9] xfs_spaceman: AG state control
Message-ID: <20170530183022.GY4519@birch.djwong.org>
References: <149417257252.24656.2629280196308754994.stgit@birch.djwong.org>
 <149417261413.24656.8374342916847767840.stgit@birch.djwong.org>
 <2b192db0-ebda-e42e-a326-66bf61b3c6ca@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b192db0-ebda-e42e-a326-66bf61b3c6ca@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Fri, May 26, 2017 at 06:06:46PM -0500, Eric Sandeen wrote:
> On 5/7/17 10:56 AM, Darrick J. Wong wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Add support for a new allocation group state control ioctl. This
> > allows control of various AG parameters, such as whether inode
> > allocation is allowed in the AG, metadata preference, whether new
> > allocations are allowed, etc. This requires a new ioctl.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > [darrick: change xfsctl to ioctl]
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Sounds like a great patch to send if this ever gets implemented in
> the kernel; for now, I think, I'll not merge it.  :)

Oops, this one got sucked into the patch series despite not having
a corresponding kernel ioctl, so I will drop this.

--D

> 
> -Eric
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
