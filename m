Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36166 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbeG1JE6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 28 Jul 2018 05:04:58 -0400
Date: Sat, 28 Jul 2018 00:39:19 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH ] misc: clean up MIN/MAX in the utilities
Message-ID: <20180728073919.GP30972@magnolia>
References: <153273073460.1594.8379497525888711422.stgit@magnolia>
 <bb65d98a-26a2-cf56-38ea-096218715c88@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb65d98a-26a2-cf56-38ea-096218715c88@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Fri, Jul 27, 2018 at 07:45:02PM -0700, Eric Sandeen wrote:
> On 7/27/18 3:32 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Get rid of the MIN/MAX macros and just use the native min/max macros
> > directly in the XFS code, just like we did for libxfs.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This is just s/MIN/min/g etc right?

Right.

> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
