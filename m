Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6944D7F4E
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 20:13:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4EAC13041BF
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 18:13:07 -0700 (PDT)
Received: from mail-qa0-f43.google.com (mail-qa0-f43.google.com
	[209.85.216.43]) by cuda.sgi.com with ESMTP id cOrm0YYrcKd7s6dE
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 12 May 2014 18:13:05 -0700 (PDT)
Received: by mail-qa0-f43.google.com with SMTP id m5so7861267qaj.16
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 18:13:05 -0700 (PDT)
Date: Mon, 12 May 2014 21:13:01 -0400
From: Jeff Layton <jlayton@poochiereds.net>
Subject: Re: [xfstests PATCH 0/4] locktest: cleanup, bugfixes, and add new
	locking test
Message-ID: <20140512211301.3280b2cd@poochiereds.net>
In-Reply-To: <20140513010028.GZ5421@dastard>
References: <1399907193-23857-1-git-send-email-jlayton@poochiereds.net>
	<20140512225845.GN26353@dastard>
	<20140512203505.16f73ef8@tlielax.poochiereds.net>
	<20140513010028.GZ5421@dastard>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, 13 May 2014 11:00:28 +1000
Dave Chinner <david@fromorbit.com> wrote:

> On Mon, May 12, 2014 at 08:35:05PM -0400, Jeff Layton wrote:
> > On Tue, 13 May 2014 08:58:45 +1000
> > Dave Chinner <david@fromorbit.com> wrote:
> > 
> > > On Mon, May 12, 2014 at 11:06:29AM -0400, Jeff Layton wrote:
> > > > This patchset does some general cleanup of the locktest binary, adds
> > > > some infrastructure to allow testing F_GETLK requests, and adds a new
> > > > F_GETLK test to the pile.
> > > > 
> > > > The main impetus here is a regression that I caused in F_GETLK handling
> > > > for v3.15. The patch is making its way to Linus now, but I want to be
> > > > sure that it doesn't regress in the future.
> > > 
> > > So do these changes cause locktest to fail on older kernels? i.e.
> > > does changing the test cause the locktest tests to fail where
> > > previously they passed? If so, we're going to have to make this a
> > > little more complex...
> > > 
> > 
> > I haven't tested on much in the way of older kernels, but I wouldn't
> > expect it to cause any problems. The only behavior change that should
> > be introduced is the F_GETLK test, and older kernels should pass that
> > just fine (modulo v3.15 which has a regression that should be patched
> > soon). The rest of the changes are just cleanups, and shouldn't
> > introduce any behavioral changes.
> 
> Is this the regression in question?
> 
> +Server failure in 29:Verify that F_GETLK for F_WRLCK doesn't
> require that file be opened for write
> 
> Cheers,
> 
> Dave.

Yes, that's the test I'm adding for the kernel regression. The patch
for the bug is:

    [PATCH v2] locks: only validate the lock vs. f_mode in F_SETLK codepaths

...and I sent a pull request to Linus for it today. It should go in
fairly soon, I hope.

Thanks,
-- 
Jeff Layton <jlayton@poochiereds.net>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
