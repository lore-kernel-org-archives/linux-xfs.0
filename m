Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 633057F37
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 13:58:18 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F3C57AC006
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 11:58:17 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id iJ7lxcKU0tFkAtRt (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 04 Jan 2016 11:58:16 -0800 (PST)
Date: Mon, 4 Jan 2016 11:57:48 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/76] xfs: fix log ticket type printing
Message-ID: <20160104195748.GC28357@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
	<20151219085636.12713.59155.stgit@birch.djwong.org>
	<20160103121353.GA28429@infradead.org>
	<20160103212905.GY19802@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160103212905.GY19802@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Jan 04, 2016 at 08:29:05AM +1100, Dave Chinner wrote:
> On Sun, Jan 03, 2016 at 04:13:53AM -0800, Christoph Hellwig wrote:
> > On Sat, Dec 19, 2015 at 12:56:36AM -0800, Darrick J. Wong wrote:
> > > Update the log ticket reservation type printing code to reflect
> > > all the types of log tickets, to avoid incorrect debug output and
> > > avoid running off the end of the array.
> > 
> > This looks okay, but I think we should use name array initializers
> > to make sure it doesn't got out of sync ever.
> 
> Good idea, separate patch is fine.

Will do.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
