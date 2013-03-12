Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2D6457F5A
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 05:23:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BF450AC004
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 03:23:39 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	FqZfstGlHj6fSPIl for <xfs@oss.sgi.com>;
	Tue, 12 Mar 2013 03:23:38 -0700 (PDT)
Date: Tue, 12 Mar 2013 21:23:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.9-rc2 xfs panic
Message-ID: <20130312102335.GM21651@dastard>
References: <20130312074608.GL21651@dastard>
	<924669527.12643828.1363075451534.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <924669527.12643828.1363075451534.JavaMail.root@redhat.com>
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
To: CAI Qian <caiqian@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Mar 12, 2013 at 04:04:11AM -0400, CAI Qian wrote:
> 
> 
> ----- Original Message -----
> > From: "Dave Chinner" <david@fromorbit.com>
> > To: "CAI Qian" <caiqian@redhat.com>
> > Cc: xfs@oss.sgi.com
> > Sent: Tuesday, March 12, 2013 3:46:08 PM
> > Subject: Re: 3.9-rc2 xfs panic
> > 
> > On Tue, Mar 12, 2013 at 02:34:07AM -0400, CAI Qian wrote:
> > > 
> > > 
> > > ----- Original Message -----
> > > > From: "Dave Chinner" <david@fromorbit.com>
> > > > To: "CAI Qian" <caiqian@redhat.com>
> > > > Cc: xfs@oss.sgi.com
> > > > Sent: Tuesday, March 12, 2013 2:07:01 PM
> > > > Subject: Re: 3.9-rc2 xfs panic
> > > > 
> > > > On Tue, Mar 12, 2013 at 12:32:28AM -0400, CAI Qian wrote:
> > > > > Just came across when running xfstests using 3.9-rc2 kernel on
> > > > > a
> > > > > power7
> > > > > box with addition of this patch which fixed a known issue,
> > > > > http://people.redhat.com/qcai/stable/01-fix-double-fetch-hlist.patch
> > > > > 
> > > > > The log shows it was happened around test case 370 with
> > > > > TEST_PARAM_BLKSIZE = 2048
> > > > 
> > > > That doesn't sound like xfstests. it only has 305 tests, and no
> > > > parameters like TEST_PARAM_BLKSIZE....
> > > Sorry, it is a typo, test case 270 not 370. TEST_PARAM_BLKSIZE was
> > > from an internal wrapper to be used to create new filessytem not
> > > from the
> > > original xfstests.
> > 
> > OK, so that means you're testing 2k filesystem block size on a 64k
> > page size machine?
> Looks like so. Would that be a problem?

It shouldn't be a problem, but nobody else is testing with that
config and so you could be seeing problems nobody sees.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
