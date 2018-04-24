Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54984 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750791AbeDXTv0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Apr 2018 15:51:26 -0400
Subject: Re: [PATCH 4/9] xfs: refactor inode buffer verifier error logging
References: <152107377037.19571.8618901963505842632.stgit@magnolia>
 <152107379476.19571.15155451515464003337.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c1e36789-58c5-740e-e6a5-79e18e45e99d@sandeen.net>
Date: Tue, 24 Apr 2018 13:51:24 -0600
MIME-Version: 1.0
In-Reply-To: <152107379476.19571.15155451515464003337.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/14/18 6:29 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When the inode buffer verifier encounters an error, it's much more
> helpful to print a buffer from the offending inode instead of just the
> start of the inode chunk buffer.

Thanks, I was about to do this until you told me you did it weeks ago.  ;)
That said, we should use this in the dquot verifiers as well.  But I'll
need to hold off on that until we decide where my old

[PATCH 0/6] xfs: quota fixes and enhancements

series is going, I think?

-Eric
