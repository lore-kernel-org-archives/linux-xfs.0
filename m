Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54710 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbeGYGGQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jul 2018 02:06:16 -0400
Date: Tue, 24 Jul 2018 21:56:22 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: kill IHOLD
Message-ID: <20180725045622.GA31006@infradead.org>
References: <153248128617.28208.11803349732053454018.stgit@magnolia>
 <153248129226.28208.17839960103899087670.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153248129226.28208.17839960103899087670.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 24, 2018 at 06:14:52PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Nobody uses this macro, get rid of it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Hah, I had this in my local queue and didn't bother to send it
yet :)

> -	trace_xfs_ihold(ip, _THIS_IP_); \

This tracepoint is also unused now and can be removed.
