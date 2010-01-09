Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o09Egamr164326 for <xfs@oss.sgi.com>; Sat, 9 Jan 2010 08:42:37 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C82A013577A4
	for <xfs@oss.sgi.com>; Sat,  9 Jan 2010 06:43:30 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id CO7AEEaMoUbJWUSE for
	<xfs@oss.sgi.com>; Sat, 09 Jan 2010 06:43:30 -0800 (PST)
Date: Sat, 9 Jan 2010 09:43:28 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] mkfs: handle 4k sector devices more cleanly
Message-ID: <20100109144327.GB9688@infradead.org>
References: <4B1E9A25.50108@redhat.com> <4B476171.4020701@sandeen.net>
	<20100108174400.GA17634@infradead.org>
	<4B47E8C0.2040809@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B47E8C0.2040809@sandeen.net>
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
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Jan 08, 2010 at 08:24:00PM -0600, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> > On Fri, Jan 08, 2010 at 10:46:41AM -0600, Eric Sandeen wrote:
> >> +extern void platform_findsizes (char *path, int fd, long long *sz, int *bsz);
> > 
> > Can you move the prototype from libxfs/init.h to include/libxfs.h
> > instead of adding it to the .c file?
> 
> actually it seems a little out of place in libxfs/init.h; that probably
> works but there are no other platform_* functions there...
> 
> Should this be more like an xfs_findsizes in libxfs, which
> calls platform_findsizes internally just for consistency? *shrug*

I'd just move the header around to keep it simple for now.

> The only way this is used is: it's sent to libxfs_init and then from there
> only to libxfs_open which does:
> 
>         if (!readonly && setblksize && (statb.st_mode & S_IFMT) == S_IFBLK) {
>                 if (setblksize == 1)
>                         /* use the default blocksize */
>                         (void)platform_set_blocksize(fd, path, statb.st_rdev, XFS_MIN_SECTORSIZE, 0);
>                 else {
>                         /* given an explicit blocksize to use */
>                         if (platform_set_blocksize(fd, path, statb.st_rdev, setblksize, 1))
>                             exit(1);
>                 }
>         }
> 
> so "1" seems to have the special meaning of "use XFS_MIN_SECTORSIZE"
> 
> Hm, ok but in my patch setblksize is 0, so it's not getting set.
> I suppose this -might- mess up other utils ...

Yes, now we do not set any size, while previously we always set
XFS_MIN_SECTORSIZE.  I don't think this actually changes anything - the
kernel doesn't make use of this blocksize information outside of
filesystems, and we already reset it on mount.

> > Maye we should just do the xi.setblksize = sectorsize unconditionally?
> 
> I think that's best.  It's already defaulted to XFS_MIN_SECTORSIZE
> so should be no functional change if it doesn't get otherwise set - although
> I think it -does- get set in all cases now - either from ft.sectoralign/blocksize,
> from the explicit -s setting, or the ft.sectorsize by default.
> 
> What do you think about removing the "1" magic if so?  At that point I think
> nothing relies on it.

repair uses it in a weird way.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
