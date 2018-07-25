Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58640 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728542AbeGYRgq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jul 2018 13:36:46 -0400
Date: Wed, 25 Jul 2018 09:24:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfs: kill IHOLD
Message-ID: <20180725162403.GP4813@magnolia>
References: <153248128617.28208.11803349732053454018.stgit@magnolia>
 <153248129226.28208.17839960103899087670.stgit@magnolia>
 <20180725045622.GA31006@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180725045622.GA31006@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 24, 2018 at 09:56:22PM -0700, Christoph Hellwig wrote:
> On Tue, Jul 24, 2018 at 06:14:52PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Nobody uses this macro, get rid of it.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Hah, I had this in my local queue and didn't bother to send it
> yet :)
> 
> > -	trace_xfs_ihold(ip, _THIS_IP_); \
> 
> This tracepoint is also unused now and can be removed.

The tracepoint already doesn't exist, but nobody noticed because the
macro wasn't used anywhere. :)

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
