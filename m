Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7VCxBGM098603 for <xfs@oss.sgi.com>; Mon, 31 Aug 2009 07:59:26 -0500
Received: from isrv.corpit.ru (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8F5C341061B
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2009 06:00:01 -0700 (PDT)
Received: from isrv.corpit.ru (isrv.corpit.ru [81.13.33.159]) by cuda.sgi.com
	with ESMTP id 3w0UHDMN8jxMJiV0 for <xfs@oss.sgi.com>;
	Mon, 31 Aug 2009 06:00:01 -0700 (PDT)
Message-ID: <4A9BC94B.9050808@msgid.tls.msk.ru>
Date: Mon, 31 Aug 2009 16:59:55 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
MIME-Version: 1.0
Subject: Re: xfs compat_ioctl?
References: <4A9B759B.7020401@msgid.tls.msk.ru>
	<20090831123010.GA2368@infradead.org> <4A9BC8A6.20503@rtr.ca>
In-Reply-To: <4A9BC8A6.20503@rtr.ca>
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
To: Mark Lord <lkml@rtr.ca>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Mark Lord wrote:
> Christoph Hellwig wrote:
>> On Mon, Aug 31, 2009 at 11:02:51AM +0400, Michael Tokarev wrote:
>>> Hello!
>>>
>>> I tried to resize an xfs filesystem on 64bit 2.6.30 kernel
>>> using 32bit userland, and that does not work, in dmesg I see:
>>>
>>> ioctl32(xfs_growfs:24426): Unknown cmd fd(3) 
>>> cmd(400c586e){t:'X';sz:12} arg(ffa56df4) on /mnt
>>> ioctl32(xfs_growfs:24427): Unknown cmd fd(3) 
>>> cmd(400c586e){t:'X';sz:12} arg(ff991254) on /mnt
>>>
>>> so apparently there's no compat_ioctl layer for these ioctls.
>>>
>>> Are there any plans to add these? :)
>>
>> Are you sure you're testing 2.6.30?  The copat ioctls were added in 
>> 2.6.28.
> 
> What command-line flags were you using, Michael ?
> 
> I just tried a simple "xfs_growfs -d" here, and it worked fine.
> This is 2.6.31-rc7-64bit on top of a 32-bit userland.

Damn.  I rebooted to 2.6.27 to test something unrelated, forgot
about it, and later tried xfs_growfs -d, which failed as per above.

And yes indeed, in 2.6.30 everything works as expected.

Please excuse me for the noise.

/mjt

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
