Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 597537F5F
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 07:40:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 40DFA304051
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 05:40:01 -0700 (PDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.131])
	by cuda.sgi.com with ESMTP id mCeKB6WC1xSO8xiH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Jun 2014 05:39:59 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Date: Mon, 02 Jun 2014 14:38:09 +0200
Message-ID: <4910284.a72lauVLNV@wuerfel>
In-Reply-To: <20140602115737.GB14276@thunk.org>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<4178301.j9kWdGCRLC@wuerfel> <20140602115737.GB14276@thunk.org>
MIME-Version: 1.0
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, lftan@altera.com, hch@infradead.org, john.stultz@linaro.org, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, geert@linux-m68k.org, tglx@linutronix.de, xfs@oss.sgi.com, joseph@codesourcery.com

On Monday 02 June 2014 07:57:37 Theodore Ts'o wrote:
> On Mon, Jun 02, 2014 at 12:56:42PM +0200, Arnd Bergmann wrote:
> > 
> > I think you misunderstood what I suggested: the intent is to avoid
> > seeing things break in 2038 by making them break much earlier. We have
> > a solution for ext2 file systems, it's called ext4, and we just need
> > to ensure that everybody knows they have to migrate eventually.
> > 
> > At some point before the mid 2030ies, you should no longer be able to
> > build a kernel that has support for ext2 or any other module that will
> > run into bugs later....
> 
> Even for ext4, it's not quite so simple as that.  You only have
> support for times post 2038 if you are using an inode size > 128
> bytes.  There are a very, very large number of machines which even
> today, are using 128 byte inodes with ext4 for performance reasons.
> 
> The vast majority of those machines which I know of can probably move
> to 256 byte inodes relatively easily, since hard drive replacement
> cycles are order 5-6 years tops, so I'm not that concerned, but it
> just goes to show this is a very complicated problem.

Ok, I see.

I also now noticed this comment above EXT4_FITS_IN_INODE():

"For new inodes we always reserve enough space for the kernel's known
extended fields, but for inodes created with an old kernel this might
not have been the case. None of the extended inode fields is critical
for correct filesystem operation."

Do we have to worry about this for inodes that contain extended
attributes and that get updated after 2038?

	Arnd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
