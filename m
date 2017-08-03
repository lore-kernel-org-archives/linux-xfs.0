Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60742 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751174AbdHCA4S (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Aug 2017 20:56:18 -0400
Date: Thu, 3 Aug 2017 08:56:17 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 3/5] common/inject: refactor helpers to use new errortag
 interface
Message-ID: <20170803005617.GW9167@eguan.usersys.redhat.com>
References: <150067465981.30639.14801416171688538711.stgit@magnolia>
 <150067468569.30639.11717903404151243816.stgit@magnolia>
 <20170802083742.GU9167@eguan.usersys.redhat.com>
 <20170802143010.GB38674@bfoster.bfoster>
 <20170802155257.GL4477@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170802155257.GL4477@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Aug 02, 2017 at 08:52:57AM -0700, Darrick J. Wong wrote:
> On Wed, Aug 02, 2017 at 10:30:10AM -0400, Brian Foster wrote:
> > On Wed, Aug 02, 2017 at 04:37:42PM +0800, Eryu Guan wrote:
> > > On Fri, Jul 21, 2017 at 03:04:45PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Refactor the XFS error injection helpers to use the new errortag
> > > > interface to configure error injection.  If that isn't present, fall
> > > > back either to the xfs_io/ioctl based injection or the older sysfs
> > > > knobs.  Refactor existing testcases to use the new helpers.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > This looks good to me overall, but I still perfer let other people
> > > who're more familar with XFS errortag and error injection to review too.
> > > While I do have some questions/comments :)
> > > 
> > > > ---
> > > >  common/inject |   58 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
> > > >  tests/xfs/141 |    5 +++--
> > > >  tests/xfs/196 |   17 ++++++-----------
> > > >  3 files changed, 65 insertions(+), 15 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/common/inject b/common/inject
> > > > index 8ecc290..9aa24de 100644
> > > > --- a/common/inject
> > > > +++ b/common/inject
> > > > @@ -35,10 +35,46 @@ _require_error_injection()
> > > >  	esac
> > > >  }
> > > >  
> > > > +# Find a given xfs mount's errortag injection knob in sysfs
> > > > +_find_xfs_mount_errortag_knob()
> > > 
> > > While The function name and comment both indicate it needs a mounted
> > > XFS, it seems weird that the first argument is expected to be a block
> > > device. And do we need to check if the given device is really mounted?
> > > 
> > 
> > The xfs per-mount sysfs knobs distinguish between mounts via the
> > block device name.
> 
> What if we rename the helper and change its documentation as such?
> 
> # Find the errortag injection knob in sysfs for a given xfs mount's
> # block device.
> _find_xfs_mountdev_errortag_knob()

This looks better to me, thanks!

> {
> 	...
> }
> 
> > ...
> > > >  # Requires that xfs_io inject command knows about this error type
> > > >  _require_xfs_io_error_injection()
> > > >  {
> > > >  	type="$1"
> > > > +
> > > > +	# Can we find the error injection knobs via the new errortag
> > > > +	# configuration mechanism?
> > > > +	test -w "$(_find_xfs_mount_errortag_knob "${TEST_DEV}" "${type}")" && return
> > > > +
> > > 
> > > As this check goes prior to the _require_error_injection check, so I
> > > assume this new errortag framework doesn't depend on a debug built XFS,
> > > can I?
> 
> It depends on the sysfs knobs, and the sysfs knobs in turn depend on
> XFS_DEBUG=y.
> 
> > It does depend on debug mode so it probably makes sense to push this
> > after the _require_error_injection check. That way the DEBUG=0 message
> > has precedent over a message regarding lack of support for a particular
> > knob.
> 
> Hm?  This is what _require_xfs_io_error_injection does:
> 
> First we compute the path to the knob if it exists
> (_find_xfs_mount_errortag_knob).
> 
> Then we check if that path is writable.  If it is, error injection is
> enabled (which presumably means XFS_DEBUG=y) and we can continue.
> 
> If not, then we use _require_error_injection to bail out if XFS_DEBUG=n.
> 
> If we don't bail out, XFS_DEBUG=y and so we check if the xfs_io inject
> help page knows about the error type, and bail out if it doesn't.
> 
> 
> In the end it doesn't really matter if we look for XFS_DEBUG=y before or
> after we look for the new sysfs knob.  I figured it was simple enough to
> assume that if the knob is present and writable, then our preconditions
> are satisfied and it's ok to proceed with the injection test.

Agreed, the order doesn't really matter here, I'm fine with either way.

Thanks,
Eryu
