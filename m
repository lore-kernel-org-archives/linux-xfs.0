Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3B1D77F95
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 16:27:53 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BACDBAC001
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 14:27:49 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	fFAqCpiVi3DubKxi for <xfs@oss.sgi.com>;
	Thu, 07 Mar 2013 14:27:47 -0800 (PST)
Date: Fri, 8 Mar 2013 09:27:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: enhance ltp/fsx with a timeout option
Message-ID: <20130307222745.GT23616@dastard>
References: <1358944851-14336-1-git-send-email-dsterba@suse.cz>
	<51378B7F.9090103@sgi.com> <20130307182525.GA29541@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130307182525.GA29541@suse.cz>
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
To: dsterba@suse.cz, Rich Johnston <rjohnston@sgi.com>, xfs@oss.sgi.com

On Thu, Mar 07, 2013 at 07:25:25PM +0100, David Sterba wrote:
> Hi,
> 
> On Wed, Mar 06, 2013 at 12:31:27PM -0600, Rich Johnston wrote:
> > I used test 263 to verify that fsx works as expected with the new -T and the
> > existing -N options.  With the -T option of course, test 263 will fail.  I
> > don't suggest that we change existing tests but add new tests which use the
> > new -T option. Do you have a new test which you intend to use the -T option
> > that can be submitted with this patch?
> 
> I understand that changing behaviour of existing checks is not desirable.
> 
> The -T option to fsx was inspired by the test we used to hunt a bug at
> 3.8-rc time where 50 concurrent direct io fsx jobs triggered the bug in
> about 10 minutes or it was considered fine.
> 
> fsx -q xxxf$x -Z -R -W -r 4096 -w 4096
> (http://permalink.gmane.org/gmane.comp.file-systems.btrfs/22447)

fsx is already run with those exact parameters as part of test 091.

> I'll send this test integrated into xfstests harness.

There's little point in adding duplicate tests that only differ in
runtime. It does not improve test coverage at all and only increases
the overall test harness run time.

If you want to run 091 for longer, add support for the new
LOAD_FACTOR variable so you can increase the number of ops it runs
for. Alternatively, make fsx use both -N ops and -T time
simultaneously, and stop the execution whenever the first criteria
expires. That way you can bound the test run time, and just use
LOAD_FACTOR to make sure it runs for the desired amount out time....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
