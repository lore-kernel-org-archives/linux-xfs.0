Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAM1kEHL031381
	for <linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 19:46:14 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4CBE026ADCD
	for <linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 17:46:12 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	QfJwHnNB43XD61m3 for <linux-xfs@oss.sgi.com>;
	Mon, 21 Nov 2011 17:46:12 -0800 (PST)
Date: Tue, 22 Nov 2011 12:46:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: stale NFS file handle problem on XFS inode64
Message-ID: <20111122014609.GK2386@dastard>
References: <CAJNJY8Q--O2Z3K6KFxVKOivwaABk+oRtC1y0eQ0nS1WdPNMwsQ@mail.gmail.com>
	<20111121170459.GA1327@infradead.org>
	<CAJNJY8Ty+bQpzGL9wq7Qv3ozcKUPwmTyYUeb2wQqZ326K4JeWw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJNJY8Ty+bQpzGL9wq7Qv3ozcKUPwmTyYUeb2wQqZ326K4JeWw@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: hank peng <pengxihan@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@oss.sgi.com

On Tue, Nov 22, 2011 at 08:19:15AM +0800, hank peng wrote:
> 2011/11/22 Christoph Hellwig <hch@infradead.org>:
> > On Mon, Nov 21, 2011 at 09:00:57PM +0800, hank peng wrote:
> >> Hi:
> >> I have a 4TB XFS filesystem mounted with "inode64" option, and I
> >> exported it using NFS v3, on NFS client, I entered a subdirectory and
> >> got "stale NFS file handle" error.
> >> ls -il showed that its inode number exceed 32 bit limit.
> >> NFS server: kernel version is 2.6.35.6
> >> NFS client: kernel version is 2.6.18
> >
> > Do you export the root directory of the XFS filesystem, or a
> > subdirectory in it? =A0If it's the former it should work in theory,
> > althrough I'm not sure how well 64-bit inode numbers work with a client
> > that old, if it's the latter it needs a few tweaks to work, see
> >
> The following is what I did:
> 1. mkfs.xfs /dev/sdb   (whole disk)
> 2. create a mount point in my root filesystem:
> mkdir /mnt/mymount
> 3. monut xfs with inode64
> mount /dev/sdb /mnt/mymount -o inode64
> 4. export it in NFS /etc/exports
> /mnt/mymount   *(rw, no_root,squash, sync)
                       ^^^^^^^^^^^^^^ no_root_squash
> =

> so, is there any problem here?
> =

> > =A0 =A0 =A0 =A0http://xfs.org/index.php/XFS_FAQ#Q:_Why_doesn.27t_NFS-ex=
porting_subdirectories_of_inode64-mounted_filesystem_work.3F

It's in the FAQ entry christoph pointed you to:

"However, exporting the root of the filesystem works"

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
