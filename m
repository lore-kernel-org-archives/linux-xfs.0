Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAJ7Xfml235774 for <xfs@oss.sgi.com>; Mon, 19 Nov 2012 01:33:41 -0600
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20]) by
	cuda.sgi.com with ESMTP id IDPnVzxxUPlAEZEw for
	<xfs@oss.sgi.com>; Sun, 18 Nov 2012 23:35:49 -0800 (PST)
Date: Mon, 19 Nov 2012 15:21:43 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [xfs:for-next 70/70] fs/xfs/xfs_da_btree.c:153:26: sparse:
	symbol 'xfs_da_node_buf_ops' was not declared. Should it be static?
Message-ID: <20121119072143.GB5426@localhost>
References: <50a5ea70.Lft3JDA+/WxpLnoh%fengguang.wu@intel.com>
	<20121117235051.GS14281@dastard> <20121119025632.GA27610@localhost>
	<20121119033805.GV14281@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121119033805.GV14281@dastard>
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
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Mon, Nov 19, 2012 at 02:38:05PM +1100, Dave Chinner wrote:
> On Mon, Nov 19, 2012 at 10:56:32AM +0800, Fengguang Wu wrote:
> > Hi Dave,
> > 
> > > > + fs/xfs/xfs_dquot.c:294:1: sparse: symbol 'xfs_dquot_buf_write_verify' was not declared. Should it be static?
> > > > 
> > > > Please consider folding the attached diff :-)
> > > 
> > > No, for the same reason as the last one. Though I'll fix the new
> > > ones (the read/write verifier functions) as they should now be
> > > static as a separate patch.
> > 
> > OK, thanks.
> > 
> > > > diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
> > > > index 0e92d12..3216738 100644
> > > > --- a/fs/xfs/xfs_bmap.c
> > > > +++ b/fs/xfs/xfs_bmap.c
> > > > @@ -4180,7 +4180,7 @@ error0:
> > > >  /*
> > > >   * Add bmap trace insert entries for all the contents of the extent records.
> > > >   */
> > > > -void
> > > > +static void
> > > >  xfs_bmap_trace_exlist(
> > > >  	xfs_inode_t	*ip,		/* incore inode pointer */
> > > >  	xfs_extnum_t	cnt,		/* count of entries in the list */
> > > 
> > > And, again, there are lots of changes in this that are unrelated to
> > > the patch.  In this case, the change is plain wrong. It's a debug
> > > only function, called via the macro XFS_BMAP_TRACE_EXLIST:
> > > 
> > > $ git grep XFS_BMAP_TRACE_EXLIST
> > > fs/xfs/xfs_bmap.c:      XFS_BMAP_TRACE_EXLIST(ip, i, whichfork);
> > > fs/xfs/xfs_bmap.h:#define       XFS_BMAP_TRACE_EXLIST(ip,c,w)   \
> > > fs/xfs/xfs_bmap.h:#define       XFS_BMAP_TRACE_EXLIST(ip,c,w)
> > > fs/xfs/xfs_inode.c:             XFS_BMAP_TRACE_EXLIST(ip, nex, whichfork);
> > > fs/xfs/xfs_inode.c:     XFS_BMAP_TRACE_EXLIST(ip, nrecs, whichfork);
> > > 
> > > And so it clearly needs to be non-static.
> > 
> > Ah OK, that macro does confuse sparse..
> 
> It shouldn't. You've clearly got sparse reporting on stuff that is
> surrounded by #ifdef DEBUG guards, and that should not be happening.
> 
> I get this:
> 
> $ make -j8 C=1 fs/xfs/xfs.ko 2>&1 |grep static
> fs/xfs/xfs_dir2_leaf.c:82:1: warning: symbol 'xfs_dir2_leafn_read_verify' was not declared. Should it be static?
> fs/xfs/xfs_dir2_leaf.c:89:1: warning: symbol 'xfs_dir2_leafn_write_verify' was not declared. Should it be static?
> fs/xfs/xfs_dquot.c:339:1: warning: symbol 'xfs_dquot_buf_write_verify' was not declared. Should it be static?
> $
> 
> And there is no warnings about anything inside DEBUG builds. So you
> must be running the tool with some strange set of options, or you
> are running it with CONFIG_XFS_DEBUG=y. But you can't be doing that,

Yes I can find CONFIG_XFS_DEBUG=y in my .config.

Now I understand your points about "xfs debug build". I've just
disabled CONFIG_XFS_DEBUG for sparse builds, so that the stuffs in
#ifdef DEBUG won't trigger the false warnings.

> either, because:
> 
> $ make -j8 C=1 fs/xfs/xfs.ko 2>&1 |grep static | wc -l
> 283
> $ make -j8 C=1 fs/xfs/xfs.ko 2>&1 |grep static | grep exlist
> $
> 
> sparse is not issuing warnings about xfs_bmap_trace_exlist() needing
> to be static on CONFIG_XFS_DEBUG=y builds.
> 
> So the build bot is doing something strange and unusual, and getting
> false warnings as a result...
 
My build commands are

make ARCH=i386 allmodconfig

make ARCH=i386 C=1 fs/xfs/xfs.ko 2>&1 |grep static
  fs/xfs/xfs_dquot.c:55:15: sparse: symbol 'xfs_dqerror_target' was not declared. Should it be static?
  fs/xfs/xfs_dquot.c:56:5: sparse: symbol 'xfs_do_dqerror' was not declared. Should it be static?
  fs/xfs/xfs_dquot.c:57:5: sparse: symbol 'xfs_dqreq_num' was not declared. Should it be static?
  fs/xfs/xfs_dquot.c:58:5: sparse: symbol 'xfs_dqerror_mod' was not declared. Should it be static?
  fs/xfs/xfs_dquot.c:215:1: sparse: symbol 'xfs_qm_init_dquot_blk' was not declared. Should it be static?
  fs/xfs/xfs_dquot.c:294:1: sparse: symbol 'xfs_dquot_buf_write_verify' was not declared. Should it be static?
  fs/xfs/xfs_dquot.c:310:1: sparse: symbol 'xfs_qm_dqalloc' was not declared. Should it be static?
  fs/xfs/xfs_dquot.c:416:1: sparse: symbol 'xfs_qm_dqrepair' was not declared. Should it be static?
  fs/xfs/xfs_dquot.c:467:1: sparse: symbol 'xfs_qm_dqtobp' was not declared. Should it be static?
  fs/xfs/xfs_dquot.c:838:1: sparse: symbol 'xfs_qm_dqput_final' was not declared. Should it be static?
  fs/xfs/xfs_dquot.c:925:1: sparse: symbol 'xfs_qm_dqflush_done' was not declared. Should it be static?
(only listing the output for xfs_dquot.c)
(almost the same results for ARCH=x86_64)

> > > If you are going throw commit-by-commit build warnings and patches
> > > to fix them, please only include the fixes for the *new* warnings
> > > generated by a single commit, not an aggregate of everything that is
> > > found. 
> > 
> > Fair enough. However I'd like to do it in a slightly different way.
> > 
> > The problem is that there are lots of existing (ie. old) valid
> > warnings on the missing "static". I'd still like the auto generated
> > patch to fix these old ones by the way.
> 
> Sure, but don't mix them with fixes for new warnings.

OK.. this will take a bit more coding, but I fully understand your
points and will do separated fixes for new/old warnings to avoid the
confusion.

> And if they are NAKed, then never send them again ;)

Whether or not they are NAKed, they'll not be sent again ;)
Because the symbols will be remembered as "fixed" (by itself)
at patch generation time.

> > At the same time, to avoid the
> > *duplicated* chunks, I'll tell the script to remember the list of
> > symbols that have been made static by the generated patches. This
> > should address your concern, while still be able to gradually get rid
> > of the existing static warnings.
> 
> Sure.
> 
> > 
> > > For that reason, I think I'd prefer it if your build bot
> > > just sent build warnings, not patches.
> > 
> > I think the patches could be improved rather than removed. I'll fix
> > the duplicated patches like in this case.
> > 
> > Since there tend to be lots of "Should it be static?" warnings, it
> > would save some (boring) human time by providing an auto generated
> > patch for consideration.
> 
> From my perspective, it takes longer to validate that the warning is
> correct (espcially given these cases where the warning is clearly
> wrong and indicates a problem with the bot) and then that the patch
> is correct as it does to find and fix these problems myself.

I'd think the patch offers more context to make a judge.. except that
mixing the fixes for old/new problems in one patch will be confusing
to the commit author who is only responsible for (and aware of) the
new warnings.

> And, of course, the only reason I missed these is that my last set
> of checks on these patches were on a debug build and I was looking
> for endian problems so I filtered out all the static warnings...

Thanks,
Fengguang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
