Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4FKH55O211371 for <xfs@oss.sgi.com>; Tue, 15 May 2012 15:17:05 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id bDTejj6fSUZDOnlK (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 May 2012 13:17:03 -0700 (PDT)
Date: Tue, 15 May 2012 22:16:45 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: Test 274 in xfstests
Message-ID: <20120515201645.GF26579@quack.suse.cz>
References: <20120515180521.GE26579@quack.suse.cz>
	<4FB29C85.5000603@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FB29C85.5000603@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: wu.bo@cn.fujitsu.com, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Tue 15-05-12 13:12:21, Eric Sandeen wrote:
> On 5/15/12 1:05 PM, Jan Kara wrote:
> >   Hello,
> > 
> >   test 274 fails e.g. for ext3 because it does not support fallocate(). So
> > I would think the best way to fix the is to add to the test
> >   _require_xfs_io_falloc()
> > so that the test is run only for filesystems which do support fallocate.
> > But with that is connected one slightly related question - why does the
> > test use fallocate(1) binary instead of "xfs_io falloc" command which is
> > more common in xfstests?
> > 
> > 								Honza
> 
> Argh I'm behind.  I had:
> 
> [PATCH V2] xfstests: several 274 fixups
> 
> on the list way too long ago.
> 
> Want to test that out?  It has 1 review on the list, I'll merge it
> soon - if you want to give it a quick test first, go for it :)
  Yup, the patch works for me (since I'm mostly interested in ext3 not
being tested ;). I also reviewed your patch and it looks OK so feel free to
add:
  Reviewed-by: Jan Kara <jack@suse.cz>

  Just one comment. Messages like:
echo "Fill fs with 1M IOs; EIO expected" >> $seq.full
  should probably speak of ENOSPC, not EIO, shouldn't they?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
