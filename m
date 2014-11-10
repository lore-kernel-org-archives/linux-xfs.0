Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7BC837F66
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 03:25:43 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EF29CAC05C
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 01:25:42 -0800 (PST)
Received: from mail-qa0-f42.google.com (mail-qa0-f42.google.com
	[209.85.216.42]) by cuda.sgi.com with ESMTP id 1ocN4eEgeCUhfO2A
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 10 Nov 2014 01:25:41 -0800 (PST)
Received: by mail-qa0-f42.google.com with SMTP id k15so5086355qaq.29
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 01:25:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141108234232.GJ28565@dastard>
References: <20141107190959.GB21021@infradead.org>
	<20141108234232.GJ28565@dastard>
Date: Mon, 10 Nov 2014 10:25:40 +0100
Message-ID: <CAJfpegsvZtCxV-GSJ4ON7=JeNkZ7o2=+fmbOTrxDAfm==b1XBw@mail.gmail.com>
Subject: Re: beginners project: RENAME_WHITEOUT
From: Miklos Szeredi <miklos@szeredi.hu>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sun, Nov 9, 2014 at 12:42 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Nov 07, 2014 at 11:09:59AM -0800, Christoph Hellwig wrote:
>> The overlayfs merge introduces a new rename flag to create to whiteouts.
>> Should be a fairly easy to implement.
>>
>> Miklos, do you have any good documentation and/or test cases for this?
>
> So overlayfs uses some weird char dev hack to implement whiteout
> inodes in directories?  Why do we need a whiteout inode on disk?
> what information is actually stored in the whiteout inode that
> overlayfs actually needs?  Only readdir and lookup care about
> whiteouts, and AFAICT nothing of the inode is ever used except
> checking the chrdev/whiteoutdev hack via ovl_is_whiteout(dentry).
>
> Indeed, whatever happened to just storing the whiteout in the dirent
> via DT_WHT and using that information on lookup in the lower
> filesystem to mark the dentry returned appropriately without needing
> to lookup a real inode?

The filesystem is free to implement whiteouts a dirent without an actual inode.

But we do need at least an inode in the VFS, since the whiteout needs
to be presented to userspace when not part of the overlay.  The DT_WHT
makes the typical mistake of trying to make the implementation nice,
while not caring about user interfaces.

This is usually a big mistake, user interfaces are much more important
than implementation details, and an already existing file type on
which all the usual operations work (stat, unlink) is much better in
this respect than a completely new object which is unknown and
unmanageable for the vast majority of applications.

The special chardev was Linus' idea, but I agree with him completely
on this point.  Introducing DT_WHT on the userspace API would be much
more of a hack than reusing existing objects and operations.

Thanks,
Miklos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
