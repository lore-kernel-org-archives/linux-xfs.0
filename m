Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4E6A57F74
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 08:07:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 38763304043
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 06:07:26 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id GOfU1kEOIL1pFPsA (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Jun 2014 06:07:21 -0700 (PDT)
Date: Mon, 2 Jun 2014 09:07:00 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Message-ID: <20140602130700.GC14276@thunk.org>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<4178301.j9kWdGCRLC@wuerfel> <20140602115737.GB14276@thunk.org>
	<15496653.1vSv1RUCC0@wuerfel>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <15496653.1vSv1RUCC0@wuerfel>
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

Yes, there are some ongoing dicussions about changing the post-2038
encoding of the timestamp in ext4, which is why this hasn't been fixed
yet.  The main thing that's been missing is time for me to review the
patches, and a good way of writing regression tests that will work (or
at least not fail) on build environments with a 32-bit time_t and
32-bit-only capable versions of functions such as gmtime(3).

And given current discussions, I may want to think about some kind of
superblock flag to allow the use of a 32-bit unsigned encoding for
file systems using a 128-byte inode, with a way of setting that flag
after scanning the file system to make sure there are no times that
are previous to January 1, 1970.  (Or more generally, allow any epoch
to be defined using a 64-bit time_t offset stored in the superblock...)

Cheers,

					- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
