Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52954 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752508AbdDKXUV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Apr 2017 19:20:21 -0400
Date: Tue, 11 Apr 2017 18:20:18 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH] xfsprogs: ensure growfs rejects non-existent mount point
Message-ID: <20170411232018.GA23511@redhat.com>
References: <20170407175809.8540-1-billodo@redhat.com>
 <58aeca70-8e10-b5c6-b446-cef0bbf2cd48@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58aeca70-8e10-b5c6-b446-cef0bbf2cd48@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Fri, Apr 07, 2017 at 01:51:47PM -0500, Eric Sandeen wrote:
> On 4/7/17 12:58 PM, Bill O'Donnell wrote:
> > xfs_growfs manpage clearly states that the filesystem must
> > be mounted to be grown. Current behavior allows xfs_growfs
> > to proceed if the filesystem /containing/ the path
> > of the desired target is mounted. This is not the specified
> > behavior. Instead, also check the targeted fs argument against
> > the entry found in the fstable lookup. Unless the targeted
> > fs is actually mounted, reject the command.
> > 
> > Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> > ---
> >  growfs/xfs_growfs.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
> > index a294e14..05630b8 100644
> > --- a/growfs/xfs_growfs.c
> > +++ b/growfs/xfs_growfs.c
> > @@ -203,7 +203,7 @@ main(int argc, char **argv)
> >  
> >  	fs_table_initialise(0, NULL, 0, NULL);
> >  	fs = fs_table_lookup(argv[optind], FS_MOUNT_POINT);
> > -	if (!fs) {
> > +	if (!fs || (strcmp(argv[optind], fs->fs_dir) != 0)) {
> >  		fprintf(stderr, _("%s: %s is not a mounted XFS filesystem\n"),
> >  			progname, argv[optind]);
> >  		return 1;
> > 
> 
> Looks like the right start, but I see a few problems with this.
> 
> First, fs_dir contains a full path, so if we point at a relative path, this
> will fail now (with a little extra error annotation):
> 
> # growfs/xfs_growfs -n mnt
> xfs_growfs: mnt is not a mounted XFS filesystem (failed compare to /mnt/test/mnt)
> 
> but will work if given a full path:
> # growfs/xfs_growfs -n `pwd`/mnt
> meta-data=/dev/loop0             isize=512    agcount=4, agsize=65536 blks
> ...
> 
> The path stuff in libxcmd tries to boil everything down to a realpath() - see:
>  
> 050a7f1 xfsprogs: handle symlinks etc in fs_table_initialise_mounts()
> and
> ed350fc libxcmd: make all comparisons using realpath'd paths
> 
> so if you want to compare paths to what's in the fstable, you'll need
> to realpath() them first to get the the same canonical pathname 
> that it has stored.
> 
> Also, if we have the same filesystem mounted
> in multiple ways, say: via loop, via a secondary mount, and via a
> bind mount (and maybe via a symlinked mount point?):
> 
> /mnt/test/fsfile on /mnt/test/mnt type xfs (rw,loop=/dev/loop0)
> /dev/loop0 on /mnt/test/mnt2 type xfs (rw)
> /mnt/test/mnt2 on /mnt/test/mnt3 type none (rw,bind)
> 
> it will fail on all but the first one it finds in the internal table:
> 
> # growfs/xfs_growfs -n `pwd`/mnt2
> xfs_growfs: /mnt/test/mnt2 is not a mounted XFS filesystem (failed compare to /mnt/test/mnt)
> # growfs/xfs_growfs -n `pwd`/mnt3
> xfs_growfs: /mnt/test/mnt3 is not a mounted XFS filesystem (failed compare to /mnt/test/mnt)
> 
> because it the lookup stats the path, and picks the /first/ fstable entry
> which has a matching device, ignoring the mountpoint found in the fstable entry.
> 
> So I think all that indicates an xfstest is needed to validate the change,
> and a slightly different approach to finding a match.

I submitted a v2. I'll also work on an xfstest.

Thanks-
Bill

> 
> Thanks,
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
