Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6B3757F37
	for <xfs@oss.sgi.com>; Fri, 31 May 2013 03:22:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4AA528F8035
	for <xfs@oss.sgi.com>; Fri, 31 May 2013 01:22:32 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id diiOsAYbXNAeTVVX for <xfs@oss.sgi.com>;
	Fri, 31 May 2013 01:22:30 -0700 (PDT)
Date: Fri, 31 May 2013 10:22:29 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] 285: Test offsets over 4GB
Message-ID: <20130531082229.GB9269@quack.suse.cz>
References: <1369917939-22660-1-git-send-email-jack@suse.cz>
	<1369917939-22660-3-git-send-email-jack@suse.cz>
	<51A758A8.80502@redhat.com> <20130530200118.GC586@quack.suse.cz>
	<51A7B0EE.1010300@redhat.com> <20130530204921.GD586@quack.suse.cz>
	<20130530223414.GR29466@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130530223414.GR29466@dastard>
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
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Fri 31-05-13 08:34:14, Dave Chinner wrote:
> On Thu, May 30, 2013 at 10:49:21PM +0200, Jan Kara wrote:
> > On Thu 30-05-13 15:05:02, Eric Sandeen wrote:
> > > On 5/30/13 3:01 PM, Jan Kara wrote:
> > > > On Thu 30-05-13 08:48:24, Eric Sandeen wrote:
> > > >> On 5/30/13 7:45 AM, Jan Kara wrote:
> > > >>> Test whether SEEK_HOLE and SEEK_DATA works correctly with offsets over
> > > >>> 4GB.
> > > >>
> > > >>
> > > >> Hm, should we add 2T as well while we're at it?
> > > >>
> > > >> (and does this cause any new failures?)
> > > >   Yes, ext4 is broken. I've sent fixes for it yesterday. I'm not sure what
> > > 
> > > Argh, sorry I forgot that.  I just want to be careful about more rigorous
> > > tests making it look like we have regressions in the code.
> > > 
> > > > exactly would overflow at 2T ... block counts if signed int is used and
> > > > blocksize is 1KB?
> > > 
> > > Hum ok, where'd I come up with 2T?  :)  never mind that maybe, unless
> > > there are other potential trouble points we should add (8T? 16T for
> > > filesystems that can handle it?)
> >   Yeah, so 8T + something might be interesting and both ext4 & xfs should
> > handle that fine. 16T + something might be interesting for xfs if it
> > supports that size. I'll update this patch with these checks.
> 
> What boundary traversal are we trying to test at these high
> offsets? 
  If fs converts passed offsets to block numbers (as ext4 does) and wrongly
used 32-bit signed instead of 32-bit unsigned type for block numbers, the
overflow would happen at 8T. In case of XFS 64-bit counters should be used
for blocks so checking somewhere beyond 16T is for that.

I'm testing at 3 different offsets because different filesystems have
different s_maxbytes settings so we cannot just test beyond 16 TB - ext4
would just return EFBIG for that.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
