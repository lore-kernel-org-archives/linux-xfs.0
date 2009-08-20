Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7KCOeC8091583
	for <linux-xfs@oss.sgi.com>; Thu, 20 Aug 2009 07:24:50 -0500
Received: from mail-ew0-f223.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A8AC31B76574
	for <linux-xfs@oss.sgi.com>; Thu, 20 Aug 2009 05:25:01 -0700 (PDT)
Received: from mail-ew0-f223.google.com (mail-ew0-f223.google.com
	[209.85.219.223]) by cuda.sgi.com with ESMTP id
	clyWDf5ixaav5rOv for <linux-xfs@oss.sgi.com>;
	Thu, 20 Aug 2009 05:25:01 -0700 (PDT)
Received: by ewy23 with SMTP id 23so5377806ewy.8
	for <linux-xfs@oss.sgi.com>; Thu, 20 Aug 2009 05:24:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090817211437.GA5929@infradead.org>
References: <4A408316.2070903@news-service.com>
	<1587994907.388291245745033392.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	<20090623171305.GB23971@infradead.org>
	<4A4A7205.6010101@news-service.com>
	<20090701124441.GA12844@infradead.org>
	<4A4CEEF2.7040101@news-service.com>
	<20090721141225.GA24330@infradead.org>
	<89c4f90c0907220155u5d9331dj3cbe53efcf6b51f2@mail.gmail.com>
	<20090817211437.GA5929@infradead.org>
Date: Thu, 20 Aug 2009 14:24:59 +0200
Message-ID: <89c4f90c0908200524m2dc7df3dk27de7337bd2ae4a@mail.gmail.com>
Subject: Re: 2.6.30 panic - xfs_fs_destroy_inode
From: Tommy van Leeuwen <tommy@news-service.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Patrick Schreurs <patrick@news-service.com>, linux-xfs@oss.sgi.com, Lachlan McIlroy <lmcilroy@redhat.com>, Eric Sandeen <sandeen@sandeen.net>

On Mon, Aug 17, 2009 at 11:14 PM, Christoph Hellwig<hch@infradead.org> wrot=
e:
> On Wed, Jul 22, 2009 at 10:55:54AM +0200, Tommy van Leeuwen wrote:
>> Unfortunately we still get errors, with this patch on top of the
>> previous one: The difference is that is now crashes within an hour
>> instead of once a week, so that might be good for troubleshooting.
>
> Hi Tommy and sorry for dropping the ball on this, I didn't remember this
> mail anymore until I look for more reporters of the inode related
> problems.

Hi Chris, no problem. We're always busy ourself too. We will check out
the new fixes but we need some time to deploy them. We will take the
extra debug info with it just in case. We'll report back when we have
some news.

Cheers,
Tommy


>
> Current mainline (Linus' git as of today) has a lot of the fixes in this
> area, any chance I could trick you into trying it? =A0Maybe including the
> debug patch below which adds a printk to that one culprit that I thing
> might remain:
>
> Also if it still happens any chance you could send output of the dmesg
> command instead of the syslog files? =A0For some reason syslogd usually
> eats up some bits of kernel oops message..
>
>
> Index: linux-2.6/fs/xfs/xfs_iget.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/fs/xfs/xfs_iget.c =A0 =A02009-08-17 18:08:39.563217129=
 -0300
> +++ linux-2.6/fs/xfs/xfs_iget.c 2009-08-17 18:09:12.999316531 -0300
> @@ -242,6 +242,8 @@ xfs_iget_cache_hit(
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0error =3D -inode_init_always(mp->m_super, =
inode);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (error) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk("XFS: inode_init_alw=
ays failed to re-initialize inode\n");
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * Re-initializing the ino=
de failed, and we are in deep
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * trouble. =A0Try to re-a=
dd it to the reclaim list.
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
