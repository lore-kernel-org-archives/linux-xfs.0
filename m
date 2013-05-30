Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 451D47F51
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 17:44:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C390CAC00E
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 15:44:01 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	a4K6t3N93lfhs66c for <xfs@oss.sgi.com>;
	Thu, 30 May 2013 15:44:00 -0700 (PDT)
Date: Fri, 31 May 2013 08:43:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFStest suite problem
Message-ID: <20130530224358.GT29466@dastard>
References: <51A708B2.2080701@oracle.com>
 <51A75745.7090805@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51A75745.7090805@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: alexander.tsvetkov@oracle.com, xfs@oss.sgi.com

On Thu, May 30, 2013 at 08:42:29AM -0500, Eric Sandeen wrote:
> On 5/30/13 3:07 AM, alexander.tsvetkov@oracle.com wrote:
> > I think the following code of "check" script incorrectly builds this exclude list:
> > 
> > "-X) xfile=$2; shift ;
> > for d in $SRC_GROUPS $FSTYP; do
> > [ -f $SRC_DIR/$d/$xfile ] || continue
> > for f in `cat $SRC_DIR/$d/$xfile`; do
> > echo $d/$f >> $tmp.xlist
> 
> Well, it is perhaps unexpected, but:
> 
>     -X file		exclude individual tests
> 
> I think it's designed to actually exclude tests contained in that
> file, not test numbers.  It's not very obvious.  :(

Right, it's a file full of test numbers to expunged. Two things can
be done here:

	1. improve the description
	2. change the `cat $file` to `egrep ^$SUPPORTED_TESTS $file`
	   so that it requires files in the same format as group
	   files.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
