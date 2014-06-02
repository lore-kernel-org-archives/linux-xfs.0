Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9A9AA7F66
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 07:54:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2FD3AAC001
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 05:53:58 -0700 (PDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.10]) by
	cuda.sgi.com with ESMTP id k6cDCUKVWAmU7l86 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Jun 2014 05:53:56 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Date: Mon, 02 Jun 2014 14:52:13 +0200
Message-ID: <15496653.1vSv1RUCC0@wuerfel>
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

One stupid question about the current code:

static inline void ext4_decode_extra_time(struct inode_time *time, __le32 extra)
{                               
       if (sizeof(time->tv_sec) > 4)
               time->tv_sec |= (__u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK)
                               << 32;
       time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >> EXT4_EPOCH_BITS;
}       

#define EXT4_EINODE_GET_XTIME(xtime, einode, raw_inode)                        \
do {                                                                           \
        if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime))                      \
                (einode)->xtime.tv_sec =                                       \
                        (signed)le32_to_cpu((raw_inode)->xtime);               \
        else                                                                   \
                (einode)->xtime.tv_sec = 0;                                    \
        if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime ## _extra))            \
                ext4_decode_extra_time(&(einode)->xtime,                       \
                                       raw_inode->xtime ## _extra);            \
        else                                                                   \
                (einode)->xtime.tv_nsec = 0;                                   \
} while (0)

For a time between 2038 and 2106, this looks like xtime.tv_sec is
negative when ext4_decode_extra_time gets called, so the '|=' operator
doesn't actually do anything. Shouldn't that be '+='?

	Arnd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
