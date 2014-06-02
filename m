Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 937B07F5D
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 06:58:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 26725AC002
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 04:58:21 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id 5c4wFJuRQDHNCUbx (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Jun 2014 04:58:18 -0700 (PDT)
Date: Mon, 2 Jun 2014 07:57:37 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Message-ID: <20140602115737.GB14276@thunk.org>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<8618458.1EVJCoVbkH@wuerfel>
	<alpine.LFD.2.11.1406012121430.17310@knanqh.ubzr>
	<4178301.j9kWdGCRLC@wuerfel>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4178301.j9kWdGCRLC@wuerfel>
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

On Mon, Jun 02, 2014 at 12:56:42PM +0200, Arnd Bergmann wrote:
> 
> I think you misunderstood what I suggested: the intent is to avoid
> seeing things break in 2038 by making them break much earlier. We have
> a solution for ext2 file systems, it's called ext4, and we just need
> to ensure that everybody knows they have to migrate eventually.
> 
> At some point before the mid 2030ies, you should no longer be able to
> build a kernel that has support for ext2 or any other module that will
> run into bugs later....

Even for ext4, it's not quite so simple as that.  You only have
support for times post 2038 if you are using an inode size > 128
bytes.  There are a very, very large number of machines which even
today, are using 128 byte inodes with ext4 for performance reasons.

The vast majority of those machines which I know of can probably move
to 256 byte inodes relatively easily, since hard drive replacement
cycles are order 5-6 years tops, so I'm not that concerned, but it
just goes to show this is a very complicated problem.

And even if we're talking about flash and embedded devices, the good
news is if you assume that 10 years is enough time for people to
update their embedded OS builds, and that the vast majority of
deployed devices will probably only be in service for 10-15 years, we
do have enough time to make file system format changes, although
admittedly we can't afford to dilly-dally.

Regards,

					- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
