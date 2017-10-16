Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:44217
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932718AbdJPXgt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2017 19:36:49 -0400
Date: Tue, 17 Oct 2017 10:36:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 04/30] xfs: refactor btree block header checking
 functions
Message-ID: <20171016233646.GO15067@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777246790.1724.5365622613986439998.stgit@magnolia>
 <20171016194803.GG4703@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171016194803.GG4703@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 16, 2017 at 12:48:03PM -0700, Darrick J. Wong wrote:
> Refactor the btree block header checks to have an internal function that
> returns the address of the failing check without logging errors.  The
> scrubber will call the internal function, while the external version
> will maintain the current logging behavior.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
