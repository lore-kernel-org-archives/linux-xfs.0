Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBQIUqGZ009049 for <xfs@oss.sgi.com>; Fri, 26 Dec 2008 12:30:52 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 010FF4ADE5
	for <xfs@oss.sgi.com>; Fri, 26 Dec 2008 10:30:51 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id tFVX8HEz0SEYX3Fo for
	<xfs@oss.sgi.com>; Fri, 26 Dec 2008 10:30:51 -0800 (PST)
Date: Thu, 25 Dec 2008 18:46:37 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: How do I tell if my partition is aligned for a 64k/RAID-6?
In-Reply-To: <495410F4.5010508@ziu.info>
Message-ID: <alpine.DEB.1.10.0812251846270.32331@p34.internal.lan>
References: <alpine.DEB.1.10.0812250821360.31386@p34.internal.lan>
	<495410F4.5010508@ziu.info>
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
To: Michal Soltys <soltys@ziu.info>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com



On Fri, 26 Dec 2008, Michal Soltys wrote:

>> 
>> I am not worried about the filesystem as the defaults usually get it right 
>> but with parted, this is the first time I had to use it for home use and 
>> with RAID-6 I am noticing slower performance with 15 disks (1 is a spare) 
>> in RAID-6 (albeit slower 7200 ones, RE3s) than I was getting with 10 
>> raptor150s in RAID-6 (but I had used fdisk there).
>> 
>> Justin.
>> 
>
> For best effect - partition should start at 1920th sector (stripe width
> boundary), and su/sw should be appropriately set - su=64k,sw=13 in your
> case. Parted shows the values normally - from the beginning of the volume, 0 
> based.
>
>
> ps.
>
> I dropped some of CCs.

Thanks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
