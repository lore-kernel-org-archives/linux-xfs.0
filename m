Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:42328 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751001AbeACAoy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jan 2018 19:44:54 -0500
Date: Wed, 3 Jan 2018 11:44:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 19/20] xfs: teach error reporting functions to take
 xfs_failaddr_t
Message-ID: <20180103004451.GH5858@dastard>
References: <151399122361.23543.15718507168231759645.stgit@magnolia>
 <151399134260.23543.8399442741926285897.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151399134260.23543.8399442741926285897.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 22, 2017 at 05:09:02PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Convert the two other error reporting functions to take xfs_failaddr_t
> when the caller wishes to capture a code pointer instead of the classic
> void * pointer.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
