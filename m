Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0O7FW8w234757 for <xfs@oss.sgi.com>; Sun, 24 Jan 2010 01:15:33 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C9D84F42897
	for <xfs@oss.sgi.com>; Sat, 23 Jan 2010 23:16:34 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	7lK7dL5vaeb1DihF for <xfs@oss.sgi.com>;
	Sat, 23 Jan 2010 23:16:34 -0800 (PST)
Date: Sun, 24 Jan 2010 18:16:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfstests: rebuild aclocal.m4
Message-ID: <20100124071631.GH25842@discord.disaster>
References: <1264053773-6054-1-git-send-email-david@fromorbit.com>
	<1264053773-6054-2-git-send-email-david@fromorbit.com>
	<20100121112115.GA27634@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100121112115.GA27634@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Jan 21, 2010 at 06:21:15AM -0500, Christoph Hellwig wrote:
> On Thu, Jan 21, 2010 at 05:02:52PM +1100, Dave Chinner wrote:
> > The local m4 configuration has not been built in a long time.
> > Trying to rebuild it results in failures with dmapi library
> > detection and libxfs.h detection macros. Fix the errors and rebuild
> > it.
> > 
> > Note: the new format for the aclocal.m4 file uses m4_include
> > directives which means it is much smaller th an before and won't
> > need updating unless we include new m4 macro files.
> 
> Looks good, but shouldn't we create aclocal.m4 automocatically as part
> of make configure which generates the rest of the auto* stuff and stop
> having it checked into the git repository?

I'll do that as a separate patch - I'm not sure what is involved in
doing this yet. No need to hold up the automatic dependency changes
for this....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
