Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B486F29DF8
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 15:53:21 -0500 (CDT)
Date: Tue, 9 Jul 2013 15:53:21 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 10/13] xfs: use get_unused_fd_flags(0) instead of
	get_unused_fd()
Message-ID: <20130709205321.GV20932@sgi.com>
References: <cover.1372777600.git.ydroneaud@opteya.com>
	<8d21b76c621dbfc59b2dbbfc933f96170835304d.1372777600.git.ydroneaud@opteya.com>
	<20130708224133.GA23250@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130708224133.GA23250@sgi.com>
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
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Yann,

On Mon, Jul 08, 2013 at 05:41:33PM -0500, Ben Myers wrote:
> On Tue, Jul 02, 2013 at 06:39:34PM +0200, Yann Droneaud wrote:
> > Macro get_unused_fd() is used to allocate a file descriptor with
> > default flags. Those default flags (0) can be "unsafe":
> > O_CLOEXEC must be used by default to not leak file descriptor
> > across exec().
> > 
> > Instead of macro get_unused_fd(), functions anon_inode_getfd()
> > or get_unused_fd_flags() should be used with flags given by userspace.
> > If not possible, flags should be set to O_CLOEXEC to provide userspace
> > with a default safe behavor.
> > 
> > In a further patch, get_unused_fd() will be removed so that
> > new code start using anon_inode_getfd() or get_unused_fd_flags()
> > with correct flags.
> > 
> > This patch replaces calls to get_unused_fd() with equivalent call to
> > get_unused_fd_flags(0) to preserve current behavor for existing code.
> > 
> > The hard coded flag value (0) should be reviewed on a per-subsystem basis,
> > and, if possible, set to O_CLOEXEC.
> > 
> > Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
> >
> > ---
> >  fs/xfs/xfs_ioctl.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 5e99968..dc5b659 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -248,7 +248,7 @@ xfs_open_by_handle(
> >  		goto out_dput;
> >  	}
> >  
> > -	fd = get_unused_fd();
> > +	fd = get_unused_fd_flags(0);
> 
> O_CLOEXEC should be fine in this case.
> 
> Reviewed-by: Ben Myers <bpm@sgi.com>

Applied at git://oss.sgi.com/xfs/xfs.git.  Looks like I was wrong about
O_CLOEXEC being ok here.  There may be applications which open_by_handle then
fork/exec and expect to still be able to use that file descriptor.

Thanks,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
