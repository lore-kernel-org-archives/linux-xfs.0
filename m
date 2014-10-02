Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5C27F7F63
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2014 02:45:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DB2EAAC00E
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2014 00:45:43 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id zN8afQdQSYTadSSr (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Oct 2014 00:45:37 -0700 (PDT)
Date: Thu, 2 Oct 2014 09:45:34 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: Test xfs/287 failure
Message-ID: <20141002074534.GA19748@quack.suse.cz>
References: <20141001152314.GH17405@quack.suse.cz>
	<20141001224155.GW4758@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141001224155.GW4758@dastard>
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
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Thu 02-10-14 08:41:55, Dave Chinner wrote:
> On Wed, Oct 01, 2014 at 05:23:14PM +0200, Jan Kara wrote:
> >   Hello,
> > 
> >   so after installing latest xfsdump (just pulled git repo at oss.sgi.com),
> > I'm getting failure in test xfs/287. The failure is:
> > xfs/287 2s ... 2s
> > _check_xfs_filesystem: filesystem on /dev/vdb2 is inconsistent (r) (see
> > /var/lib/xfstests/results//xfs/287.full)
> > 
> > And the 287.full has:
> > ...
> > Phase 3 - for each AG...
> >         - scan (but don't clear) agi unlinked lists...
> >         - process known inodes and perform inode discovery...
> >         - agno = 0
> > directory flags set on non-directory inode 133
> > directory flags set on non-directory inode 134
> > directory flags set on non-directory inode 133
> > would fix bad flags.
> > directory flags set on non-directory inode 134
> > would fix bad flags.
> > ...
> > 
> > Complete file is attached. I'm using also the latest xfsprogs from git and
> > kernel 3.17.0-rc5 (plus couple of my patches but these should have no
> > influence).
> 
> It's a bug, but a minor inconvenience at worst. I sent patches to
> fix this a couple of days ago:
> 
> http://oss.sgi.com/archives/xfs/2014-09/msg00510.html
  Ah, OK. Thanks for info. I was just going through xfstests failures in my
test VM and fixing xfstests / my setup and I wasn't able to figure out this
one...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
