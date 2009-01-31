Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0VNCOJd135074 for <xfs@oss.sgi.com>; Sat, 31 Jan 2009 17:12:25 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3DF1E18A02C8
	for <xfs@oss.sgi.com>; Sat, 31 Jan 2009 15:11:43 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id SDydcg8PDROzdtek for
	<xfs@oss.sgi.com>; Sat, 31 Jan 2009 15:11:43 -0800 (PST)
Date: Sat, 31 Jan 2009 18:11:41 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.28: All I/O, D-state: 3ware
 9650SE-16ML/Intel/965/MTRR/PAT?
In-Reply-To: <20090131175509.GA24900@infradead.org>
Message-ID: <alpine.DEB.1.10.0901311811140.19833@p34.internal.lan>
References: <alpine.DEB.1.10.0901310523480.29879@p34.internal.lan>
	<alpine.DEB.1.10.0901311230510.4472@p34.internal.lan>
	<20090131175509.GA24900@infradead.org>
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
Cc: linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, Alan Piszcz <ap@solarrain.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Sat, 31 Jan 2009, Christoph Hellwig wrote:

> On Sat, Jan 31, 2009 at 12:37:39PM -0500, Justin Piszcz wrote:
>> I think it was a coincidence when I tried to login before, I tried it
>> again (after trying to re-produce the problem, which I had been able to
>> do) and this time the mouse worked but the keyboard did not..even running
>> echo b > sysrq-trigger did not reboot the server..  Had to resort to
>> manual method.
>>
>> I am now on kernel 2.6.28.2 and will see if I can make it happen again.
>
> This looks like the bug fixed by commit
> e8c82c2e23e3527e0c9dc195e432c16784d270fa.  Make sure you have it.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Thanks, looks like that was the culprit, no hangs in 1-2 hrs of heavy I/O.

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
