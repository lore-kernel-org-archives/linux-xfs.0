Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBB9PU7T032570 for <xfs@oss.sgi.com>; Thu, 11 Dec 2008 03:25:30 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7F273170F86E
	for <xfs@oss.sgi.com>; Thu, 11 Dec 2008 01:25:29 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id f4Y0TzrRUIGPCc5x for
	<xfs@oss.sgi.com>; Thu, 11 Dec 2008 01:25:29 -0800 (PST)
Date: Thu, 11 Dec 2008 04:24:58 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers
 [xfs]
In-Reply-To: <alpine.DEB.1.10.0812110416550.14590@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0812110422380.14590@p34.internal.lan>
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>
	<49405CD5.4070704@tmr.com>
	<alpine.DEB.1.10.0812110416550.14590@p34.internal.lan>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>, xfs@oss.sgi.com



On Thu, 11 Dec 2008, Justin Piszcz wrote:

>
>
> On Wed, 10 Dec 2008, Bill Davidsen wrote:
>
>> Justin Piszcz wrote:
>>> Someone should write a document with XFS and barrier support, if I recall,
>
>

Best not to do things in a rush, here is the correct benchmark:

# rm -rf linux*7
# sync
# echo 1 > /proc/sys/vm/drop_caches
# /usr/bin/time bash -c 'tar xf linux-2.6.27.7.tar; sync'
0.13user 1.62system 0:46.67elapsed 3%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (17major+955minor)pagefaults 0swaps

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
