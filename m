Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:20627 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753294AbdCHTnb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2017 14:43:31 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v28JAvg7005978
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2017 19:10:57 GMT
Date: Wed, 8 Mar 2017 11:09:20 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/3] misc: use system FICLONE/FICLONERANGE/FIDEDUPERANGE
 definitions
Message-ID: <20170308190920.GQ5280@birch.djwong.org>
References: <148893300446.23674.6348172768180643163.stgit@birch.djwong.org>
 <148893301058.23674.10160100843692497809.stgit@birch.djwong.org>
 <20170308155313.GC4353@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170308155313.GC4353@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Wed, Mar 08, 2017 at 07:53:13AM -0800, Christoph Hellwig wrote:
> xfs_fs.h should never removed previously define APIs - that'll just
> break application.

Yeah, I should've erased those defines before they ended up in 4.9.
Oh well.

> So to be honest I'm not sure there is any upside to this patch - it
> adds tons of lines, does not add any functionality and breaks existing
> apps.

But is it a good idea to expose the reflink and dedupe xfs_io commands
on platforms where we know it isn't going to work?  AFAIK those ioctls
are still Linux-only.

Or: how popular are the darwin and *bsd ports of xfsprogs?  It looks
like OSX can only read XFS via fuse, and freebsd dropped XFS from
their kernel in 10.0.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
