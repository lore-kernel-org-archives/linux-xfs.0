Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BE48E7CA1
	for <xfs@oss.sgi.com>; Wed, 18 May 2016 03:25:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8C4ED8F8065
	for <xfs@oss.sgi.com>; Wed, 18 May 2016 01:25:43 -0700 (PDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com
	[74.125.82.52]) by cuda.sgi.com with ESMTP id zDGMxk1Z3glYl5kF
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 May 2016 01:25:41 -0700 (PDT)
Received: by mail-wm0-f52.google.com with SMTP id r12so22682518wme.0
	for <xfs@oss.sgi.com>; Wed, 18 May 2016 01:25:41 -0700 (PDT)
Date: Wed, 18 May 2016 10:25:39 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: Xfs lockdep warning with for-dave-for-4.6 branch
Message-ID: <20160518082538.GE21654@dhcp22.suse.cz>
References: <20160512055756.GE6648@birch.djwong.org>
	<20160512080321.GA18496@dastard>
	<20160513160341.GW20141@dhcp22.suse.cz>
	<20160516104130.GK3193@twins.programming.kicks-ass.net>
	<20160516130519.GJ23146@dhcp22.suse.cz>
	<20160516132541.GP3193@twins.programming.kicks-ass.net>
	<20160516231056.GE18496@dastard>
	<20160517144912.GZ3193@twins.programming.kicks-ass.net>
	<20160517223549.GV26977@dastard>
	<20160518072005.GA3193@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160518072005.GA3193@twins.programming.kicks-ass.net>
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
To: Peter Zijlstra <peterz@infradead.org>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs@oss.sgi.com, linux-mm@kvack.org, Ingo Molnar <mingo@kernel.org>

On Wed 18-05-16 09:20:05, Peter Zijlstra wrote:
> On Wed, May 18, 2016 at 08:35:49AM +1000, Dave Chinner wrote:
> > On Tue, May 17, 2016 at 04:49:12PM +0200, Peter Zijlstra wrote:
[...]
> > > In any case; would something like this work for you? Its entirely
> > > untested, but the idea is to mark an entire class to skip reclaim
> > > validation, instead of marking individual sites.
> > 
> > Probably would, but it seems like swatting a fly with runaway
> > train. I'd much prefer a per-site annotation (e.g. as a GFP_ flag)
> > so that we don't turn off something that will tell us we've made a
> > mistake while developing new code...
> 
> Fair enough; if the mm folks don't object to 'wasting' a GFP flag on
> this the below ought to do I think.

GFP flag space is quite scarse. Especially when it would be used only
for lockdep configurations which are mostly disabled. Why cannot we go
with an explicit disable/enable API I have proposed? It would be lockdep
contained and quite easy to grep for and git blame would tell us
(hopefuly) why the lockdep had to be put out of the way for the
particular path.
-- 
Michal Hocko
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
