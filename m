Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7VCuwMg098490 for <xfs@oss.sgi.com>; Mon, 31 Aug 2009 07:57:09 -0500
Received: from mail.rtr.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8EBCE41098B
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2009 05:57:46 -0700 (PDT)
Received: from mail.rtr.ca (rtr.ca [76.10.145.34]) by cuda.sgi.com with ESMTP
	id N1GtfKeX0ZP2NEIY for <xfs@oss.sgi.com>;
	Mon, 31 Aug 2009 05:57:46 -0700 (PDT)
Message-ID: <4A9BC8A6.20503@rtr.ca>
Date: Mon, 31 Aug 2009 08:57:10 -0400
From: Mark Lord <lkml@rtr.ca>
MIME-Version: 1.0
Subject: Re: xfs compat_ioctl?
References: <4A9B759B.7020401@msgid.tls.msk.ru>
	<20090831123010.GA2368@infradead.org>
In-Reply-To: <20090831123010.GA2368@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Michael Tokarev <mjt@tls.msk.ru>, Linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Mon, Aug 31, 2009 at 11:02:51AM +0400, Michael Tokarev wrote:
>> Hello!
>>
>> I tried to resize an xfs filesystem on 64bit 2.6.30 kernel
>> using 32bit userland, and that does not work, in dmesg I see:
>>
>> ioctl32(xfs_growfs:24426): Unknown cmd fd(3) cmd(400c586e){t:'X';sz:12} arg(ffa56df4) on /mnt
>> ioctl32(xfs_growfs:24427): Unknown cmd fd(3) cmd(400c586e){t:'X';sz:12} arg(ff991254) on /mnt
>>
>> so apparently there's no compat_ioctl layer for these ioctls.
>>
>> Are there any plans to add these? :)
> 
> Are you sure you're testing 2.6.30?  The copat ioctls were added in 2.6.28.
..

What command-line flags were you using, Michael ?

I just tried a simple "xfs_growfs -d" here, and it worked fine.
This is 2.6.31-rc7-64bit on top of a 32-bit userland.

Cheers

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
