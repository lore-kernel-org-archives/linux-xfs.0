Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o06MZipI117026 for <xfs@oss.sgi.com>; Wed, 6 Jan 2010 16:35:44 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EAD14148BC7
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2010 14:36:34 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	okDQbSDsBzZ4GCH5 for <xfs@oss.sgi.com>;
	Wed, 06 Jan 2010 14:36:34 -0800 (PST)
Date: Thu, 7 Jan 2010 09:36:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] remove bashisms from xfstests
Message-ID: <20100106223631.GV13802@discord.disaster>
References: <alpine.DEB.2.01.1001030125040.3483@bogon.housecafe.de>
	<20100106164844.GB4209@infradead.org>
	<alpine.DEB.2.01.1001061114340.3483@bogon.housecafe.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1001061114340.3483@bogon.housecafe.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christian Kujau <lists@nerdbynature.de>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Jan 06, 2010 at 11:24:10AM -0800, Christian Kujau wrote:
> On Wed, 6 Jan 2010 at 11:48, Christoph Hellwig wrote:
> > > 2) convert "let..." into something (hopefully) more portable
> > 
> > Dave converted these away from expr due to performance reasons.  I'd
> > like too see a prove that performance hasn't regressed due to this
> > change.
> 
> That's why I hesitated to just change all scripts to /bin/bash, but didn't 
> dare to say so, because of the inevitable "but today's computers are fast 
> enough" reactions :-)

FYI - the problem I came across was to do with running xfsqa under UML,
where forking a new process is an expensive operation (I measured it
at about 300ms) and so using bash built-in expressions for
incrementing variables is a major win in terms of test run time.
IIRC, one test loops 100,000 times and the runtime went from half an
hour to 10s just by using "let n=n+1" instead of expr...

> 
> > > 3) replace 'a == b' with 'a = b' in bourne shell scripts
> > 
> > This looks fine.  If you want feel free to submit these as a separate
> > first patch so that we have the large pile sorted out.
> 
> OK, will do.
> 
> > I fear this might cause some overhead in the shell.  What about the
> > following instead:
> > 
> > for i in `seq 0 39`; do
> >     ln -s $o symlink_$i
> >     o=symlink_$i
> > done
> 
> I didn't go for seq(1), as I feared this wouldn't be available on every 
> machine.

seq(1) is already used in several tests, so it is ok to use in
more. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
