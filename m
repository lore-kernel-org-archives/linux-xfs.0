Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5501C7F72
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 08:16:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 21DB8304039
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 06:16:06 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id q9IyTgKGajm07ikR (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Jun 2014 06:16:04 -0700 (PDT)
Date: Mon, 2 Jun 2014 09:15:55 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Message-ID: <20140602131555.GD14276@thunk.org>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<4178301.j9kWdGCRLC@wuerfel> <20140602115737.GB14276@thunk.org>
	<4910284.a72lauVLNV@wuerfel>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4910284.a72lauVLNV@wuerfel>
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
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, lftan@altera.com, hch@infradead.org, john.stultz@linaro.org, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, geert@linux-m68k.org, tglx@linutronix.de, xfs@oss.sgi.com, joseph@codesourcery.com

On Mon, Jun 02, 2014 at 02:38:09PM +0200, Arnd Bergmann wrote:
> 
> "For new inodes we always reserve enough space for the kernel's known
> extended fields, but for inodes created with an old kernel this might
> not have been the case. None of the extended inode fields is critical
> for correct filesystem operation."
> 
> Do we have to worry about this for inodes that contain extended
> attributes and that get updated after 2038?

In practice, the extended timestamps was one of the first things added
to ext4, so the vast majority of ext4 file systems with inode sizes >
128 bytes will have room for the extended timestamps.  There are some
legacy ext3 file systems with 256-byte inodes (enabled for fast
sotrage of SELinux xattrs) that in theory, could have been converted
to ext4 and had enough xattrs so that the extended timestamps couldn't
be added.  That would be a vanishingly small use case, and in
practice, it's not likely to be the case for the embedded market.

I could imagine someone worrying about file systems originally
formatted using RHEL 4 post-2038 (perhaps running in a VM), but I
don't work for IBM any more, and hopefully even IBM would just tell
such customers that they need to suck it up, and do a
backup/reformat/restore pass.

Cheers,
						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
