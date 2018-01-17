Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:37937 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751662AbeAQAl1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jan 2018 19:41:27 -0500
Date: Wed, 17 Jan 2018 11:41:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 10/21] xfs: set up scrub cross-referencing helpers
Message-ID: <20180117004123.GD6304@dastard>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398983388.18741.9974351544672577036.stgit@magnolia>
 <20180105215451.GM5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180105215451.GM5602@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jan 05, 2018 at 01:54:51PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create some helper functions that we'll use later to deal with problems
> we might encounter while cross referencing metadata with other metadata.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

.....

> @@ -512,5 +558,6 @@ xfs_scrub_btree(
>  	}
>  
>  out:
> +
>  	return error;
>  }

Stray whitespace.

Much nicer than the first version. :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
