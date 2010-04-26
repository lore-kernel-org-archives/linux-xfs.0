Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3Q0YrNw045283 for <xfs@oss.sgi.com>; Sun, 25 Apr 2010 19:34:53 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 951312EF182
	for <xfs@oss.sgi.com>; Sun, 25 Apr 2010 17:36:55 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	CFkDHpfcBYGzBOhS for <xfs@oss.sgi.com>;
	Sun, 25 Apr 2010 17:36:55 -0700 (PDT)
Date: Mon, 26 Apr 2010 10:36:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.34-rc3: simple du (on a big xfs tree) triggers oom killer
	[bisected: 57817c68229984818fea9e614d6f95249c3fb098]
Message-ID: <20100426003637.GB11437@dastard>
References: <201004050049.17952.hpj@urpla.net> <20100413091823.GD7544@dastard>
	<201004131142.33518.hpj@urpla.net>
	<201004241844.23482.hpj@urpla.net> <20100425162740.GB19195@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100425162740.GB19195@suse.de>
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
To: Greg KH <gregkh@suse.de>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org, opensuse-kernel@opensuse.org, xfs@oss.sgi.com

On Sun, Apr 25, 2010 at 09:27:40AM -0700, Greg KH wrote:
> On Sat, Apr 24, 2010 at 06:44:22PM +0200, Hans-Peter Jansen wrote:
> > FYI, 2.6.33.2 is still affected from this issue. 
> 
> Is 2.6.33.3-rc2 affected?  A lot of xfs patches are in there (as are in
> 2.6.32.12-rc2.)

The fix is not in Linus' kernel yet, Greg. So once that is done,
I'll have to backport the fix back to those stable kernels as well.
It's not a trivial fix, so it will miss this round of stable
releases....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
