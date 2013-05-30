Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5F1A37F53
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 17:34:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4EA298F8049
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 15:34:17 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	rPCceOcVLS59ABID for <xfs@oss.sgi.com>;
	Thu, 30 May 2013 15:34:15 -0700 (PDT)
Date: Fri, 31 May 2013 08:34:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] 285: Test offsets over 4GB
Message-ID: <20130530223414.GR29466@dastard>
References: <1369917939-22660-1-git-send-email-jack@suse.cz>
	<1369917939-22660-3-git-send-email-jack@suse.cz>
	<51A758A8.80502@redhat.com> <20130530200118.GC586@quack.suse.cz>
	<51A7B0EE.1010300@redhat.com> <20130530204921.GD586@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130530204921.GD586@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Thu, May 30, 2013 at 10:49:21PM +0200, Jan Kara wrote:
> On Thu 30-05-13 15:05:02, Eric Sandeen wrote:
> > On 5/30/13 3:01 PM, Jan Kara wrote:
> > > On Thu 30-05-13 08:48:24, Eric Sandeen wrote:
> > >> On 5/30/13 7:45 AM, Jan Kara wrote:
> > >>> Test whether SEEK_HOLE and SEEK_DATA works correctly with offsets over
> > >>> 4GB.
> > >>
> > >>
> > >> Hm, should we add 2T as well while we're at it?
> > >>
> > >> (and does this cause any new failures?)
> > >   Yes, ext4 is broken. I've sent fixes for it yesterday. I'm not sure what
> > 
> > Argh, sorry I forgot that.  I just want to be careful about more rigorous
> > tests making it look like we have regressions in the code.
> > 
> > > exactly would overflow at 2T ... block counts if signed int is used and
> > > blocksize is 1KB?
> > 
> > Hum ok, where'd I come up with 2T?  :)  never mind that maybe, unless
> > there are other potential trouble points we should add (8T? 16T for
> > filesystems that can handle it?)
>   Yeah, so 8T + something might be interesting and both ext4 & xfs should
> handle that fine. 16T + something might be interesting for xfs if it
> supports that size. I'll update this patch with these checks.

What boundary traversal are we trying to test at these high
offsets? 

I mean, I can understand wanting to confirm they work, but there's
no 32 bit variable boundary in the seek code at 8/16TB that needs to
be specifically test is there? i.e. is it just testing the same case
as the 8GB case?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
