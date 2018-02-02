Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46814 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752951AbeBBRr5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Feb 2018 12:47:57 -0500
Date: Fri, 2 Feb 2018 09:47:33 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: don't allow DAX on reflink filesystems
Message-ID: <20180202174733.GA4849@magnolia>
References: <20180131222324.GH4849@magnolia>
 <20180202095131.GB17952@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180202095131.GB17952@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>

On Fri, Feb 02, 2018 at 01:51:31AM -0800, Christoph Hellwig wrote:
> On Wed, Jan 31, 2018 at 02:23:24PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Now that reflink is no longer experimental, reject attempts to mount
> > with DAX until that whole mess gets sorted out.
> 
> Didn't I send exactly the same patch about a week ago?

I haven't received any such patch (but Oracle mail has been dropping and
delaying mail recently) and marc.info doesn't bring up anything relevant
for a search of 'DAX' and 'Hellwig'. :/

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
