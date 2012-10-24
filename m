Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9OLJXcc056207 for <xfs@oss.sgi.com>; Wed, 24 Oct 2012 16:19:33 -0500
Date: Wed, 24 Oct 2012 16:21:14 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/3] respect DESTDIR when installing
Message-ID: <20121024212114.GS1377@sgi.com>
References: <1348529978-30048-1-git-send-email-vapier@gentoo.org>
	<1348529978-30048-2-git-send-email-vapier@gentoo.org>
	<20121024205140.GR1377@sgi.com>
	<201210241707.37499.vapier@gentoo.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201210241707.37499.vapier@gentoo.org>
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
To: Mike Frysinger <vapier@gentoo.org>
Cc: xfs@oss.sgi.com


On Wed, Oct 24, 2012 at 05:07:36PM -0400, Mike Frysinger wrote:
> On Wednesday 24 October 2012 16:51:40 Ben Myers wrote:
> > On Mon, Sep 24, 2012 at 07:39:37PM -0400, Mike Frysinger wrote:
> > > This makes the `make install DESTDIR=...` form work.  It keeps support
> > > for all previous forms too (like DIST_ROOT).
> > 
> > This doesn't seem to work for me.  I do a make install
> > DESTDIR=/some/odd/path and it all still goes into /usr.  What sort of
> > system did you try this on? Maybe it just doesn't like opensuse 12.2?
> 
> the `make` output makes it look like it's going into / and such, but it isn't.  
> the install-sh script rewrites the path silently behind the scenes.
> 
> alternatively, maybe you didn't rebuild autotools after applying the patch ?  
> the code will copy include/install-sh to the top level, and then everything 
> executes that rather than the original in the include/ subdir.

Thanks Mike, works great. 

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
