Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 15B247F50
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 15:52:41 -0500 (CDT)
Date: Wed, 27 Mar 2013 15:52:40 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: Announce re-factor all current xfstests patches request
Message-ID: <20130327205240.GT22182@sgi.com>
References: <5152F2BB.4000709@sgi.com> <20130327134606.GJ5861@thunk.org>
	<5153217B.5070909@sgi.com> <20130327190512.GA22889@thunk.org>
	<20130327204217.GC16651@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130327204217.GC16651@lenny.home.zabbo.net>
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
To: Zach Brown <zab@zabbo.net>
Cc: Rich Johnston <rjohnston@sgi.com>, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-btrfs <linux-btrfs@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

Hey,

On Wed, Mar 27, 2013 at 01:42:17PM -0700, Zach Brown wrote:
> On Wed, Mar 27, 2013 at 03:05:12PM -0400, Theodore Ts'o wrote:
> > What do you think about renaming the existing tests from NNN to
> > NNN-descriptive-name?  That way it will be easier for people who are
> > trying to track regressions, since they can easily map from the new
> > more descriptive name to the old test number for comparison purposes
> > (i.e., to see whether a failure is a regression or not, etc.)
> 
> It does seem like a good idea to help people map from descriptive names
> to their previous numeric file names.
> 
> But do we want to bake it in to the file names forevermore?  Would it be
> good enough to start the old tests with something like
> 
> _was_test_nr 45
> 
> that spits out the old test number in the log?
> 
> Just thinking out loud over here.

Maybe a text file containing the mapping would be sufficient.  It's not as if
it's going to grow.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
