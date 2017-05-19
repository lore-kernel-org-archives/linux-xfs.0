Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25086 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754169AbdESAG1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 May 2017 20:06:27 -0400
Date: Thu, 18 May 2017 17:06:17 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/3 v3] xfs: Fix SEEK_HOLE implementation
Message-ID: <20170519000617.GH4519@birch.djwong.org>
References: <20170518104850.14508-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170518104850.14508-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Eryu Guan <eguan@redhat.com>

On Thu, May 18, 2017 at 12:48:47PM +0200, Jan Kara wrote:
> Hello,
> 
> this is the second revision of the patches to fix bugs in XFS's SEEK_HOLE
> implementation and cleanup the code a bit.

Looks ok, will give it a test; for now,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Changes since v2:
> * Fixed rounding error in patch 2 spotted by Eryu
> 
> Changes since v1:
> * Fixed some more buggy cases
> * Simplified code a bit as suggested by Darrick
> * Fixed range check as spotted by Brian
> 
> 								Honza
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
