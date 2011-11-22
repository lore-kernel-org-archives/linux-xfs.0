Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAMMFH8h174780
	for <linux-xfs@oss.sgi.com>; Tue, 22 Nov 2011 16:15:18 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D411E162D73A
	for <linux-xfs@oss.sgi.com>; Tue, 22 Nov 2011 14:15:16 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ZNvjuS0gPqLggxwK for <linux-xfs@oss.sgi.com>;
	Tue, 22 Nov 2011 14:15:16 -0800 (PST)
Date: Tue, 22 Nov 2011 17:15:15 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: stale NFS file handle problem on XFS inode64
Message-ID: <20111122221515.GA29540@infradead.org>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: hank peng <pengxihan@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@oss.sgi.com

On Tue, Nov 22, 2011 at 08:19:15AM +0800, hank peng wrote:
> > Do you export the root directory of the XFS filesystem, or a
> > subdirectory in it? ??If it's the former it should work in theory,
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
> 
> so, is there any problem here?

That should work fine, and I've tried it a lot of times.  Do you see
the same issue when mounting the fs on the server (not recommended for
production use, just for testing!) and accessing it from the 2.6.35
kernel nfs client?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
