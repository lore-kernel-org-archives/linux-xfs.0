Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A728E7F56
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 06:02:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 88B06304059
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 04:02:33 -0700 (PDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
	by cuda.sgi.com with ESMTP id kvt67eZdfV5VweLH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Jun 2014 04:02:29 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Date: Mon, 02 Jun 2014 13:02:07 +0200
Message-ID: <142924495.p3tVTERnnG@wuerfel>
In-Reply-To: <0ab4392c-d89d-4277-914d-1696f455daab@email.android.com>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<8618458.1EVJCoVbkH@wuerfel>
	<0ab4392c-d89d-4277-914d-1696f455daab@email.android.com>
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
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, john.stultz@linaro.org, lftan@altera.com, linux-fsdevel@vger.kernel.org, geert@linux-m68k.org, tglx@linutronix.de, joseph@codesourcery.com

On Sunday 01 June 2014 13:26:03 H. Peter Anvin wrote:
> Perhaps we should make this a kernel command line option instead, with the
> settings: error out on outside the standard window, or a date indicating the
> earliest date that should be recognized and do windowing (0 for no windowing,
> 1970 for retconning the Unix epoch as unsigned...)

What's wrong with compile-time errors? We have a pretty good understanding
of how time values are passed in the kernel, and we know they will all break
in 2038 for 32-bit kernels unless we do something about it.
 
> But again, the kernel is probably the least problem here...
 
I agree the glibc side is harder than this, but we have to get the kernel
into shape first (at the minimum we have to do the APIs), and there is enough
work to do here.

	Arnd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
