Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E29927F3F
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 20:47:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D069E304051
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 18:47:21 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	FpG3rjQuG3oc5FYc for <xfs@oss.sgi.com>;
	Mon, 18 Mar 2013 18:47:20 -0700 (PDT)
Date: Tue, 19 Mar 2013 12:47:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: possible dev branch regression - xfstest 285/1k
Message-ID: <20130319014718.GV6369@dastard>
References: <20130315222818.GA16100@wallace> <20130316150923.GA18589@gmail.com>
	<20130317030648.GA14225@thunk.org> <51473C8B.5070509@redhat.com>
	<20130318170927.GA5639@thunk.org> <51475043.4010505@redhat.com>
	<20130318204133.GE22182@sgi.com> <20130318231233.GQ6369@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130318231233.GQ6369@dastard>
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
To: Ben Myers <bpm@sgi.com>
Cc: Eric Whitney <enwlinux@gmail.com>, Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, xfs-oss <xfs@oss.sgi.com>

On Tue, Mar 19, 2013 at 10:12:33AM +1100, Dave Chinner wrote:
> On Mon, Mar 18, 2013 at 03:41:33PM -0500, Ben Myers wrote:
> > Hi Eric,
> > 
> > On Mon, Mar 18, 2013 at 12:34:59PM -0500, Eric Sandeen wrote:
> > > On 3/18/13 12:09 PM, Theodore Ts'o wrote:
> > > > On Mon, Mar 18, 2013 at 11:10:51AM -0500, Eric Sandeen wrote:
> > still run with default settings.
> 
> And when the default settings change, or some other bug fix comes
> along?
> 
> So, let's step back a moment and ask ourselves what the test is
> actaully trying to test. zero-out is not what it is trying to test,
> nor is it trying to test specific file layouts. This is a basic
> *defragmenter* sanity test. SO, we're testing 2 things:

Sorry about this - I've mixed up my threads about ext4 having
problems with zero-out being re-enabled. I thought this was a
cross-post of the 218 issue....

However, the same reasoning can be applied to 285 - the file sizes,
the size of the holes and the size of the data is all completely
arbitrary. If we make the holes in the files larger, then the
zero-out problem simply goes away.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
