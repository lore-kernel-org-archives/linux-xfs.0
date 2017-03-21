Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53750 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932740AbdCUPXA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Mar 2017 11:23:00 -0400
Date: Tue, 21 Mar 2017 11:22:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfstests: xfs/191 update
Message-ID: <20170321152253.GB59313@bfoster.bfoster>
References: <20170315163347.29743-1-jtulak@redhat.com>
 <20170316074941.GS14226@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170316074941.GS14226@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Jan Tulak <jtulak@redhat.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, Mar 16, 2017 at 03:49:41PM +0800, Eryu Guan wrote:
> On Wed, Mar 15, 2017 at 05:33:47PM +0100, Jan Tulak wrote:
> > The removed 'do_mkfs_pass -l size=4096b' was against man page
> > (-b section). Other entries are things that weren't covered before.
> > 
> > Specifically, a standalone "-l size=4096b" should fail, because:
> > To  specify any options on the command line in units of filesys‐
> > tem blocks, this option must be  specified  first  so  that  the
> > filesystem block size is applied consistently to all options.
> > 
> > Signed-off-by: Jan Tulak <jtulak@redhat.com>
> 
> This looks fine to me. But I'd like some reviews from xfs developers
> too. (cc'd linux-xfs@vger.kernel.org).
> 

So has mkfs been fixed to cause '-l size=4096b' to fail? I'm not sure we
should cause the test to fail until/unless the mkfs behavior is fixed
up.

Brian

> Thanks,
> Eryu
> 
> > ---
> >  tests/xfs/191-input-validation | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tests/xfs/191-input-validation b/tests/xfs/191-input-validation
> > index 5de55170..e22f9bfc 100755
> > --- a/tests/xfs/191-input-validation
> > +++ b/tests/xfs/191-input-validation
> > @@ -114,6 +114,9 @@ do_mkfs_fail -d sectsize=2foo $SCRATCH_DEV
> >  do_mkfs_fail -l sectsize=nggh $SCRATCH_DEV
> >  do_mkfs_fail -l sectsize=2nggh $SCRATCH_DEV
> >  
> > +# option respecification should fail
> > +do_mkfs_fail -d agcount=32,agcount=32 $SCRATCH_DEV
> > +
> >  # conflicting sector/block sizes
> >  do_mkfs_fail -s size=512 -d sectsize=1024 $SCRATCH_DEV
> >  do_mkfs_fail -s size=512 -l sectsize=1024 $SCRATCH_DEV
> > @@ -191,6 +194,12 @@ do_mkfs_fail -d sectsize=512s,agsize=65536s $SCRATCH_DEV
> >  
> >  reset_fsimg
> >  
> > +# some sectsize/blocksize combinations
> > +do_mkfs_pass -s size=512 -b size=8s $SCRATCH_DEV
> > +do_mkfs_fail -s size=512s $SCRATCH_DEV
> > +
> > +reset_fsimg
> > +
> >  # file section, should pass
> >  do_mkfs_pass $fsimg
> >  do_mkfs_pass -d file=0 $SCRATCH_DEV
> > @@ -218,7 +227,6 @@ reset_fsimg
> >  # log section, should pass
> >  do_mkfs_pass -l size=$logsize -d size=$fssize $SCRATCH_DEV
> >  do_mkfs_pass -l agnum=2 $SCRATCH_DEV
> > -do_mkfs_pass -l size=4096b $SCRATCH_DEV
> >  do_mkfs_pass -l sectsize=512 $SCRATCH_DEV
> >  do_mkfs_pass -l sunit=64 $SCRATCH_DEV
> >  do_mkfs_pass -l sunit=64 -d sunit=8,swidth=8 $SCRATCH_DEV
> > @@ -237,6 +245,7 @@ do_mkfs_pass -l version=2 -m crc=0 $SCRATCH_DEV
> >  do_mkfs_pass -l version=2 $SCRATCH_DEV
> >  
> >  # log section, should fail
> > +do_mkfs_fail -l size=4096b $SCRATCH_DEV
> >  do_mkfs_fail -l size=${fssize}b $SCRATCH_DEV
> >  do_mkfs_fail -l size=${fssize}s $SCRATCH_DEV
> >  do_mkfs_fail -l size=${fssize}yerk $SCRATCH_DEV
> > -- 
> > 2.11.0
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
