Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38172 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752568AbdGYPqL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jul 2017 11:46:11 -0400
Date: Tue, 25 Jul 2017 08:45:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: request for inclusion of 04197b341f23 ("xfs: don't BUG() on
 mixed direct and mapped I/O")
Message-ID: <20170725154548.GO4352@magnolia>
References: <5bcfc94b-ecb9-468b-78f3-ae5de53f62a0@suse.com>
 <666c5faf-cbee-f83b-90bf-279284f0600b@applied-asynchrony.com>
 <18dc98f7-abd8-4925-a303-7ae4c1e46db5@suse.com>
 <20170725134221.GB19075@kroah.com>
 <20170725134334.GC19075@kroah.com>
 <20170725134745.GA19961@kroah.com>
 <20170725135035.GA20865@lst.de>
 <8639f3da-77f4-6330-40f5-3c3d9cbfbc06@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8639f3da-77f4-6330-40f5-3c3d9cbfbc06@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: Christoph Hellwig <hch@lst.de>, Greg KH <greg@kroah.com>, Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>, stable@vger.kernel.org, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Tue, Jul 25, 2017 at 05:02:54PM +0300, Nikolay Borisov wrote:
> 
> 
> On 25.07.2017 16:50, Christoph Hellwig wrote:
> > On Tue, Jul 25, 2017 at 06:47:45AM -0700, Greg KH wrote:
> >> Oh, and I need an ack from the xfs maintainers to be able to take this,
> >> there must be some reason they didn't backport it like they did for a
> >> number of other xfs patches...
> > 
> > In general we'd like to see xfstests runs for all stable backports,
> > because file system code is hairy.
> > 
> > So for any xfs stable backports please send the list of patches you
> > want backported, and tell us that you did indeed run xfstests.  No
> > proof is required, we'd like to trust our contributors.
> > 
> 
> Before including this in our enterprise distribution I did run xfstest
> with and without the patch and there was no difference in the result.
> Hence I sent the patch.

Looks fine to me...
Acked-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
