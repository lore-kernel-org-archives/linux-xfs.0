Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9869F7F3F
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 11:38:55 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 12AA3AC005
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 09:38:54 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id xOvYDOIYmOL2GDQx (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 04 Mar 2015 09:38:51 -0800 (PST)
Date: Wed, 4 Mar 2015 12:38:41 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: How to handle TIF_MEMDIE stalls?
Message-ID: <20150304173841.GB15669@thunk.org>
References: <20150219225217.GY12722@dastard>
	<20150221235227.GA25079@phnom.home.cmpxchg.org>
	<20150223004521.GK12722@dastard>
	<20150222172930.6586516d.akpm@linux-foundation.org>
	<20150223073235.GT4251@dastard>
	<20150302202228.GA15089@phnom.home.cmpxchg.org>
	<20150302231206.GK18360@dastard>
	<20150303025023.GA22453@phnom.home.cmpxchg.org>
	<20150304065242.GR18360@dastard>
	<20150304150436.GA16442@phnom.home.cmpxchg.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150304150436.GA16442@phnom.home.cmpxchg.org>
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
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, rientjes@google.com, oleg@redhat.com, xfs@oss.sgi.com, mhocko@suse.cz, linux-mm@kvack.org, mgorman@suse.de, dchinner@redhat.com, Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org

On Wed, Mar 04, 2015 at 10:04:36AM -0500, Johannes Weiner wrote:
> Yes, we can make this work if you can tell us which allocations have
> limited/controllable lifetime.

It may be helpful to be a bit precise about definitions here.  There
are a number of different object lifetimes:

a) will be released before the kernel thread returns control to
userspace

b) will be released once the current I/O operation finishes.  (In the
case of nbd where the remote server has unexpectedy gone away might be
quite a while, but I'm not sure how much we care about that scenario)

c) can be trivially released if the mm subsystem asks via calling a
shrinker

d) can be released only after doing some amount of bounded work (i.e.,
cleaning a dirty page)

e) impossible to predict when it can be released (e.g., dcache, inodes
attached to an open file descriptors, buffer heads that won't be freed
until the file system is umounted, etc.)


I'm guessing that what you mean is (b), but what about cases such as
(c)?

Would the mm subsystem find it helpful if it had more information
about object lifetime?  For example, the CMA folks seem to really care
about know whether memory allocations falls in category (e) or not.

						- Ted
						

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
