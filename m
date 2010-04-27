Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3R00EwB115251 for <xfs@oss.sgi.com>; Mon, 26 Apr 2010 19:00:15 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 81C7113335E2
	for <xfs@oss.sgi.com>; Mon, 26 Apr 2010 17:02:17 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id wvV0idZ5EFXk9CD0 for <xfs@oss.sgi.com>;
	Mon, 26 Apr 2010 17:02:17 -0700 (PDT)
Date: Mon, 26 Apr 2010 17:02:02 -0700
From: Greg KH <gregkh@suse.de>
Subject: Re: 2.6.34-rc3: simple du (on a big xfs tree) triggers oom killer
	[bisected: 57817c68229984818fea9e614d6f95249c3fb098]
Message-ID: <20100427000202.GA31470@suse.de>
References: <201004050049.17952.hpj@urpla.net> <20100413091823.GD7544@dastard>
	<201004131142.33518.hpj@urpla.net>
	<201004241844.23482.hpj@urpla.net> <20100425162740.GB19195@suse.de>
	<20100426003637.GB11437@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100426003637.GB11437@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org, opensuse-kernel@opensuse.org, xfs@oss.sgi.com

On Mon, Apr 26, 2010 at 10:36:37AM +1000, Dave Chinner wrote:
> On Sun, Apr 25, 2010 at 09:27:40AM -0700, Greg KH wrote:
> > On Sat, Apr 24, 2010 at 06:44:22PM +0200, Hans-Peter Jansen wrote:
> > > FYI, 2.6.33.2 is still affected from this issue. 
> > 
> > Is 2.6.33.3-rc2 affected?  A lot of xfs patches are in there (as are in
> > 2.6.32.12-rc2.)
> 
> The fix is not in Linus' kernel yet, Greg. So once that is done,
> I'll have to backport the fix back to those stable kernels as well.
> It's not a trivial fix, so it will miss this round of stable
> releases....

Ok, that's fine, just checking.  I'm in no rush, I have plenty of other
patches to queue up for the next stable releases :)

thanks,

greg k-h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
