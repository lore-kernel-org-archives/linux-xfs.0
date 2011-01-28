Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0S0vVux064348 for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 18:57:31 -0600
Received: from ironport2-out.pppoe.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8613F1DC4277
	for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 16:59:54 -0800 (PST)
Received: from ironport2-out.pppoe.ca (ironport2-out.teksavvy.com
	[206.248.154.181]) by cuda.sgi.com with ESMTP id
	MfDWfUDdiND28cfi for <xfs@oss.sgi.com>;
	Thu, 27 Jan 2011 16:59:54 -0800 (PST)
Message-ID: <4D421507.1030006@teksavvy.com>
Date: Thu, 27 Jan 2011 19:59:51 -0500
From: Mark Lord <kernel@teksavvy.com>
MIME-Version: 1.0
Subject: Re: xfs: very slow after mount, very slow at umount
References: <4D40C8D1.8090202@teksavvy.com> <20110127033011.GH21311@dastard>
	<4D40EB2F.2050809@teksavvy.com> <4D418B57.1000501@teksavvy.com>
	<20110127234152.GN21311@dastard>
In-Reply-To: <20110127234152.GN21311@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, Linux Kernel <linux-kernel@vger.kernel.org>, Stan Hoeppner <stan@hardwarefreak.com>, Alex Elder <aelder@sgi.com>

On 11-01-27 06:41 PM, Dave Chinner wrote:
> On Thu, Jan 27, 2011 at 10:12:23AM -0500, Mark Lord wrote:
..
>> Can you recommend a good set of mkfs.xfs parameters to suit the characteristics
>> of this system? 
> 
> http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E

That entry says little beyond "blindly trust the defaults".
But thanks anyway (really).

> And perhaps you want to consider the allocsize mount option, though
> that shouldn't be necessary for 2.6.38+...

That's a good tip, thanks.
>From my earlier posting:

>   /dev/sdb1 on /var/lib/mythtv type xfs
> (rw,noatime,allocsize=64M,logbufs=8,largeio)

Maybe that allocsize value could be increased though.
Perhaps something on the order of 256MB might do it.

Thanks again!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
