Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C1CE57F6F
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 02:18:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4F918AC002
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 00:18:47 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	NMeGCgUFG1AGGY3b for <xfs@oss.sgi.com>;
	Thu, 11 Jul 2013 00:18:39 -0700 (PDT)
Date: Thu, 11 Jul 2013 17:18:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v10 10/11] quota: Add proper versioning support to
	fs_quota_stat
Message-ID: <20130711071832.GC5652@dastard>
References: <1372371914-11370-1-git-send-email-sekharan@us.ibm.com>
	<1372371914-11370-11-git-send-email-sekharan@us.ibm.com>
	<20130710155538.GY20932@sgi.com>
	<20130710162602.GB32444@quack.suse.cz>
	<1373489390.6020.30.camel@chandra-dt.ibm.com>
	<20130711014501.GY3438@dastard>
	<1373516161.4555.10.camel@chandra-laptop.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1373516161.4555.10.camel@chandra-laptop.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: Ben Myers <bpm@sgi.com>, Jan Kara <jack@suse.cz>, swhiteho@redhat.com, xfs@oss.sgi.com

On Wed, Jul 10, 2013 at 11:16:01PM -0500, Chandra Seetharaman wrote:
> On Thu, 2013-07-11 at 11:45 +1000, Dave Chinner wrote:
> > And to play Devil's advocate: it is way too late in the merge cycle
> > to make these sorts of ABI changes to a patch and test/review them
> > adequately.
> 
> There is no ABI issues even in the earlier version, it was an API
> breakage.

Old binaries would have done the wrong thing - that's an ABI
issue. I'm sorry I didn't realise this earlier.

> And with Jan's suggestion even that API breakage is being
> fixed. There is no change in API or ABI. We are just adding a new
> interface.

Yes, we are adding a new API to avoid ABI problems with
re-interpreting the old API. 

But whether it's API or ABI, it doesn't matter - my point is that
it's almost 2 weeks after the merge window was opened and adding new
userspace APIs at the last moment before the merge window closes
tends to be frowned upon....

> Old code and old binary will work as before.

Yes, but we have no new code or binaries to test the new interface,
do we?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
