Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A75FF7F37
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 16:51:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8B8868F8064
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 14:51:54 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	aPdVIDXpQjGb9AV5 for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 14:51:52 -0700 (PDT)
Date: Fri, 7 Jun 2013 07:51:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/1] xfs: xfs_inactive fails to cleanup symlinks with
	attributes
Message-ID: <20130606215149.GC29338@dastard>
References: <20130606161032.753011157@sgi.com> <51B0E03B.3010303@sgi.com>
	<20130606211307.GB29338@dastard> <51B0FF1D.60402@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51B0FF1D.60402@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 06, 2013 at 04:29:01PM -0500, Mark Tinguely wrote:
> On 06/06/13 16:13, Dave Chinner wrote:
> >On Thu, Jun 06, 2013 at 02:17:15PM -0500, Mark Tinguely wrote:
> >>On 06/06/13 11:10, Mark Tinguely wrote:
> >>>Found this bug testing extended attributes.
> >>>
> >>># make a big symbolic link that is in the inode core and mostly fills it.
> >>># CRC enabled filesystem will use a 68 byte smaller link in the test.
> >>>
> >>>ln -s 1234567890/1234567890/1234567890/1234567890/1234567890/1234567890/1234567890/1234567890/1234567890/1234567890/1234567890/0123456/a a
> >>>
> >>># the extended attribute will bump the symbolic link to a remote extent
> >>># I think only one of these attribute is needed, but they are so fun...
> >>>attr  -Rs 1234567890ad a<   /dev/null
> >>>attr  -Rs 1234567890ae a<   /dev/null
> >>>attr  -Rs 1234567890af a<   /dev/null
> >>>
> >>
> >>oops. the following steps are also needed - I took them out because I
> >>thought they were unecessary:
> >>
> >># remove the attributes:
> >>attr  -Rr 1234567890ad a
> >>attr  -Rr 1234567890ae a
> >>attr  -Rr 1234567890af a
> >>
> >>now we will assert
> >
> >I cannot reproduce this on a current TOT kernel with or without
> >CRCs:
> >
> ># mkfs.xfs -f /dev/vdb
> >meta-data=/dev/vdb               isize=256    agcount=4, agsize=720896 blks
.....
> 
> Yes, these instructions are for a *256* byte inode with top of tree code.

Yup, that's what I was testing with. It's right there in the mkfs
output I posted. Hence I want your exact test script that reproduces
it, in case there's still something missing from what you've sent as
the test case....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
