Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 06C3C7F3F
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2014 04:00:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 87E7FAC0B7
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2014 02:00:06 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id pcF9llfDt5tjdW1H (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 16 Jun 2014 02:00:04 -0700 (PDT)
Date: Mon, 16 Jun 2014 11:00:01 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] xfs: Fix rounding in xfs_alloc_fix_len()
Message-ID: <20140616090001.GA15837@quack.suse.cz>
References: <1401900833-25485-1-git-send-email-jack@suse.cz>
	<20140604184440.GC55624@bfoster.bfoster>
	<20140613150207.GA24615@quack.suse.cz>
	<20140613235622.GA9508@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140613235622.GA9508@dastard>
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
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com, Jan Kara <jack@suse.cz>, dchinner@redhat.com

On Sat 14-06-14 09:56:22, Dave Chinner wrote:
> On Fri, Jun 13, 2014 at 05:02:07PM +0200, Jan Kara wrote:
> > On Wed 04-06-14 14:44:40, Brian Foster wrote:
> > > On Wed, Jun 04, 2014 at 06:53:53PM +0200, Jan Kara wrote:
> > > > Rounding in xfs_alloc_fix_len() is wrong. As the comment states, the
> > > > result should be a number of a form (k*prod+mod) however due to sign
> > > > mistake the result is different. As a result allocations on raid arrays
> > > > could be misaligned in some cases.
> > > > 
> > > > This also seems to fix occasional assertion failure:
> > > > 	XFS_WANT_CORRUPTED_GOTO(rlen <= flen, error0)
> > > > in xfs_alloc_ag_vextent_size().
> > > > 
> > > > Also add an assertion that the result of xfs_alloc_fix_len() is of
> > > > expected form.
> > > > 
> > > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > > ---
> > > 
> > > Looks good to me. Thanks Jan.
> > > 
> > > Reviewed-by: Brian Foster <bfoster@redhat.com>
> >   Ping Dave? Are you going to pick up this patch?
> 
> I did - it's already in Linus' tree for 3.16:
> 
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/xfs/xfs_alloc.c?id=30265117ee1e23fa91920f337a3ea91207f700dc
  Ah, sorry. I was expecting some email about acceptance. I'll check the git
tree next time.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
