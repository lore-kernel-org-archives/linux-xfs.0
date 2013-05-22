Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0BE2029DF8
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 18:54:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B12958F8068
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 16:54:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id JALcJzAARq8kpVYh for
	<xfs@oss.sgi.com>; Wed, 22 May 2013 16:54:01 -0700 (PDT)
Date: Wed, 22 May 2013 19:53:55 -0400
From: Dave Jones <davej@redhat.com>
Subject: Re: XFS assertion from truncate. (3.10-rc2)
Message-ID: <20130522235355.GA31001@redhat.com>
References: <20130522001603.GZ29466@dastard>
	<20130522025605.GA29767@redhat.com>
	<20130522040318.GG29466@dastard> <20130522041521.GA1837@redhat.com>
	<20130522051243.GH29466@dastard> <20130522052938.GA2573@redhat.com>
	<20130522055147.GI29466@dastard> <20130522142252.GB1407@redhat.com>
	<20130522161946.GA25906@redhat.com>
	<20130522220933.GV24543@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130522220933.GV24543@dastard>
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
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Thu, May 23, 2013 at 08:09:33AM +1000, Dave Chinner wrote:
 > On Wed, May 22, 2013 at 12:19:46PM -0400, Dave Jones wrote:
 > > On Wed, May 22, 2013 at 10:22:52AM -0400, Dave Jones wrote:
 > >  > On Wed, May 22, 2013 at 03:51:47PM +1000, Dave Chinner wrote:
 > >  > 
 > >  >  > > Tomorrow I'll also try running some older kernels with the same
 > >  >  > > options to see if it's something new, or an older bug. This is a
 > >  >  > > new machine, so it may be something that's been around for a
 > >  >  > > while, and for whatever reason, my other machines don't hit
 > >  >  > > this.
 > >  >  > 
 > >  >  > Another thing that just occurred to me - what compiler are you
 > >  >  > using?  We had a report last week on #xfs that xfsdump was failing
 > >  >  > with bad checksums because of link time optimisation (LTO) in
 > >  >  > gcc-4.8.0. When they turned that off, everything worked fine. So if
 > >  >  > you are using 4.8.0, perhaps trying a different compiler might be a
 > >  >  > good idea, too.
 > >  > 
 > >  > Yeah, this is 4.8.0. This box is running F19-beta. 
 > >  > I managed to shoehorn the gcc-4.7 from f18 on there though.
 > >  > Bug reproduced instantly, so I think we can rule out compiler.
 > >  > 
 > >  > I ran 3.9 with the same debug options. Seems stable.
 > >  > I'll do a bisect.
 > > 
 > > good news.  It wasn't until I started bisecting I realised I was still
 > > carrying this patch from you to fix slab corruption I was seeing.
 > > 
 > > It seems to be the culprit (or is masking another problem -- I had to apply
 > > it at each step of the bisect to get past the slab corruption bug).
 > 
 > That doesn't make a whole lot of sense to me. The fix in the xfsdev
 > tree is a little different:
 > 
 > http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs.git;a=commitdiff;h=52c24ad39ff02d7bd73c92eb0c926fb44984a41d
 > 
 > but I can't set how this makes any difference to the problem at all.
 > See my previous post about the fact that 0xa068 is actually a valid
 > mask and should not be tripping the assert....

Hmm, I did git bisect fs/xfs/, so maybe itit's something outside of that subdir
that's the cause. I'll start over on the whole tree once I'm done bisecting
another entirely different bug.

	Dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
