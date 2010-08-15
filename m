Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7F9M2uT183623 for <xfs@oss.sgi.com>; Sun, 15 Aug 2010 04:22:05 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0CDA91D73227
	for <xfs@oss.sgi.com>; Sun, 15 Aug 2010 02:22:29 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id fBzfNmEAB5Ut5fav for
	<xfs@oss.sgi.com>; Sun, 15 Aug 2010 02:22:29 -0700 (PDT)
Date: Sun, 15 Aug 2010 05:22:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: fs corruption not detected by xfs_check or _repair
Message-ID: <20100815092222.GA1801@infradead.org>
References: <4C656149.6050604@nethype.de>
	<20100814183537.GA13734@puku.stupidest.org>
	<4C671E83.4060106@nethype.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C671E83.4060106@nethype.de>
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
To: Marco Maisenhelder <marco@nethype.de>
Cc: Chris Wedgwood <cw@f00f.org>, xfs@oss.sgi.com

On Sun, Aug 15, 2010 at 12:53:55AM +0200, Marco Maisenhelder wrote:
> Chris Wedgwood wrote:
> >On Fri, Aug 13, 2010 at 05:14:17PM +0200, Marco Maisenhelder wrote:
> >
> >>*marco:/etc# ls -lrt /store/xfs_corruption/x/
> >>ls: cannot access /store/xfs_corruption/x/db.backup2: Invalid argument
> >>ls: cannot access /store/xfs_corruption/x/db.backup1: Invalid argument
> >>total 0
> >>?????????? ? ? ? ?                ? db.backup2
> >>?????????? ? ? ? ?                ? db.backup1
> >
> >where these created with inode64 and now mounted w/o that option?  (in
> >which case inodes > 32-bit are inaccessible)
> 
> I wasn't even aware of the option - I guess I should have spent more
> time reading the FAQ before trying to find a more complex problem :(
> 
> inode64 was my problem - mouting the partition with -o inode64 fixes
> all weirdness.

FYI: starting from kernel 2.6.35 you can access all the inodes even
without -o inode64 and won't get these strange errors.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
