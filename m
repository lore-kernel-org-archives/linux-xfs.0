Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3PIFqQ1028144 for <xfs@oss.sgi.com>; Sun, 25 Apr 2010 13:15:52 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 66AE12EEC72
	for <xfs@oss.sgi.com>; Sun, 25 Apr 2010 11:17:54 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id N88kCY4kjCYUIoVN for <xfs@oss.sgi.com>;
	Sun, 25 Apr 2010 11:17:54 -0700 (PDT)
Date: Sun, 25 Apr 2010 11:18:35 -0700
From: Greg KH <gregkh@suse.de>
Subject: Re: 2.6.34-rc3: simple du (on a big xfs tree) triggers oom killer
	[bisected: 57817c68229984818fea9e614d6f95249c3fb098]
Message-ID: <20100425181835.GA22772@suse.de>
References: <201004050049.17952.hpj@urpla.net> <20100413091823.GD7544@dastard>
	<201004131142.33518.hpj@urpla.net>
	<201004241844.23482.hpj@urpla.net> <20100425162740.GB19195@suse.de>
	<20100425165734.GA2887@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100425165734.GA2887@infradead.org>
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
Cc: Nick Piggin <npiggin@suse.de>, xfs@oss.sgi.com, opensuse-kernel@opensuse.org, linux-kernel@vger.kernel.org

On Sun, Apr 25, 2010 at 12:57:35PM -0400, Christoph Hellwig wrote:
> On Sun, Apr 25, 2010 at 09:27:40AM -0700, Greg KH wrote:
> > On Sat, Apr 24, 2010 at 06:44:22PM +0200, Hans-Peter Jansen wrote:
> > > FYI, 2.6.33.2 is still affected from this issue. 
> > 
> > Is 2.6.33.3-rc2 affected?  A lot of xfs patches are in there (as are in
> > 2.6.32.12-rc2.)
> 
> Yes.  It's not even in mainline yet as Nick doesn't like the trivial
> core VM fix required to solve this in a clean way.

Hm, Nick, why?  This seems like a real problem, easily reproduced.  Is
it solved some other way in Linus's tree that we could backport to the
-stable series?

thanks,

greg k-h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
