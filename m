Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7MKkhgg013814 for <xfs@oss.sgi.com>; Sat, 22 Aug 2009 15:46:53 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 026EB3EE822
	for <xfs@oss.sgi.com>; Sat, 22 Aug 2009 13:47:24 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id SsEYgX3PGRCxxlAp for
	<xfs@oss.sgi.com>; Sat, 22 Aug 2009 13:47:24 -0700 (PDT)
Date: Sat, 22 Aug 2009 16:46:52 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.30.4 XFS(..?) regression (& with/2.6.31-rc6)
In-Reply-To: <20090822201558.GA17955@infradead.org>
Message-ID: <alpine.DEB.2.00.0908221645440.20848@p34.internal.lan>
References: <alpine.DEB.2.00.0908080422440.12329@p34.internal.lan>
	<00980BBF-1206-4BEF-A8AE-B4A8DAE7EC27@sgi.com>
	<alpine.DEB.2.00.0908090605080.16485@p34.internal.lan>
	<alpine.DEB.2.00.0908110624420.22426@p34.internal.lan>
	<20090816022331.GA2309@infradead.org>
	<alpine.DEB.2.00.0908171024380.12533@p34.internal.lan>
	<alpine.DEB.2.00.0908220624440.30321@p34.internal.lan>
	<20090822142550.GA10003@infradead.org>
	<alpine.DEB.2.00.0908221044420.30321@p34.internal.lan>
	<20090822201558.GA17955@infradead.org>
MIME-Version: 1.0
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
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Sat, 22 Aug 2009, Christoph Hellwig wrote:

> On Sat, Aug 22, 2009 at 10:45:13AM -0400, Justin Piszcz wrote:
>>> Yes, entirely possible.   All the crypto loop / dm implementation used
>>> to have a tendency to never complete I/O once in a while, although that
>>> didn't happen anymore recently.
>>
>> Ok,
>>
>> What is the best way to debug the issue? git bi-sects between 2.6.29.x
>> and 2.6.31-rc6? or?
>
> Well, that would be a good way to find it.  But I'm personally not
> interested in spending much time on debugging a problem if it only
> happens with fishy out of tree modules.
>

.. No out of tree modules are used ..

Here is the kernel config used:
http://home.comcast.net/~jpiszcz/20090822/config.txt

After 24hrs of various tar-like read/write/verify I/O, the error usually 
recurs.

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
