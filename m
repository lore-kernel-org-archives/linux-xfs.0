Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1GLvXb3079666 for <xfs@oss.sgi.com>; Wed, 16 Feb 2011 15:57:33 -0600
Received: from coco.kroah.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 26B722E1310
	for <xfs@oss.sgi.com>; Wed, 16 Feb 2011 14:00:12 -0800 (PST)
Received: from coco.kroah.org (kroah.org [198.145.64.141]) by cuda.sgi.com
	with ESMTP id a6EP8x7kg3ZOPJGM for <xfs@oss.sgi.com>;
	Wed, 16 Feb 2011 14:00:12 -0800 (PST)
Date: Wed, 16 Feb 2011 13:50:02 -0800
From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [GIT PULL] XFS update for 2.6.38-rc3
Message-ID: <20110216215002.GJ5027@kroah.com>
References: <201101311642.p0VGgXTS018851@stout.americas.sgi.com>
	<4D482E21.5040803@teksavvy.com> <20110203000757.GT11040@dastard>
	<201102032302.31780.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201102032302.31780.a.miskiewicz@gmail.com>
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
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>, Mark Lord <kernel@teksavvy.com>, stable@kernel.org

On Thu, Feb 03, 2011 at 11:02:31PM +0100, Arkadiusz Miskiewicz wrote:
> On Thursday 03 of February 2011, Dave Chinner wrote:
> > On Tue, Feb 01, 2011 at 11:00:33AM -0500, Mark Lord wrote:
> > > On 11-01-31 11:42 AM, Alex Elder wrote:
> > > > Linus, please accept the following updates for XFS, for 2.6.38-rc3
> > > > (if it's not too late) or 2.6.38-rc4.
> > > > 
> > > > They are all fixes for bugs that have some pretty undesirable
> > > > consequences. 
> 
> [...]
> 
> > > Are these bugs all new in 2.6.38, or should some of these fixes
> > > also go out to -stable for earlier revisions?
> > > >       xfs: fix dquot shaker deadlock
> > 
> > That's a regression, so maybe.
> 
> Definitely, xfs_fsr can hit this even few times a day (happened already).
> 
> Stable team, please include this one for 2.6.37.1:

Now queued up (it will make .2, sorry, not .1)

thanks,

greg k-h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
