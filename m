Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q29GjRe1257012 for <xfs@oss.sgi.com>; Fri, 9 Mar 2012 10:45:27 -0600
Date: Fri, 9 Mar 2012 10:45:33 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: Safe to use XFS in production in Linux 3.2.9?
Message-ID: <20120309164533.GA7762@sgi.com>
References: <20120308140600.77406b8zzy2zggkc@web.mail.umich.edu>
	<20120308235326.GQ5091@dastard>
	<20120309110838.147865q6j5c9hqsc@web.mail.umich.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120309110838.147865q6j5c9hqsc@web.mail.umich.edu>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Sean Thomas Caron <scaron@umich.edu>
Cc: hch@lst.de, xfs@oss.sgi.com

Sean,

On Fri, Mar 09, 2012 at 11:08:38AM -0500, Sean Thomas Caron wrote:
> OK, Linux 3.2.9 doesn't sound very safe to use in production. So, fine, 
> we can try 3.0.23; it appears that a fix for CVE-2012-0056 was applied 
> around 3.0.19 so it should be all set in that regard.
>
> I'm comparing the contents of the xfs-bulletproof-sync patch with the  
> 3.0.23 XFS sources and it's not entirely clear to me if 3.0.23 fully  
> implements the fixes in the patch. Please forgive me because it's a  
> little long, but here's the contents of the patch:

Looks like this fix made 3.0.16:

# git describe 6826d3e80d143ca7411fd2dca05bc57c7ed3e620
v3.0.15-68-g6826d3e

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
