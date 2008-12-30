Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBUEKWAR019596 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 08:20:32 -0600
Received: from qw-out-1920.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B2C791797185
	for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 06:20:30 -0800 (PST)
Received: from qw-out-1920.google.com (qw-out-1920.google.com [74.125.92.150])
	by cuda.sgi.com with ESMTP id 9BDYDKpHd8OS2IRf for
	<xfs@oss.sgi.com>; Tue, 30 Dec 2008 06:20:30 -0800 (PST)
Received: by qw-out-1920.google.com with SMTP id 5so17253074qwc.32
	for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 06:20:29 -0800 (PST)
Date: Tue, 30 Dec 2008 08:20:26 -0600
From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: mismatch_cnt, random bitflips, silent corruption(?), mdadm/sw
	raid[156]
Message-ID: <20081230142026.GB3549@sewage.raw-sewage.fake>
References: <alpine.DEB.1.10.0812250435260.12329@p34.internal.lan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812250435260.12329@p34.internal.lan>
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>, smartmontools-support@lists.sourceforge.net, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Dec 25, 2008 at 01:04:07PM -0500, Justin Piszcz wrote:
> Options/alternatives for maintaining data integrity?
>
> 1. Obviously DVD and/or LTO-tape (multiple copies of data at rest)
> http://epoka.dk/media/Linear_Tape_Open_(LTO)_Ultrium_Data_Cartridges.pdf
> -> For LTO-2/LTO-3
> -> Uncorrected bit error rate 1x10-17 1x10-17
> -> Undetected bit error rate 1x10-27 1x10-27
>
> 2. ZFS, but only runs in user-space in Linux.
>
> 3. Keep an md5sum for each file on the filesystem and run daily
> checks?

I've recently started using par2[1][2] on backed up files.

I just started doing this, so don't know how it will work in the
long run.  Can't hurt, anyway, other than taking up more space.

[1] http://www.par2.net/
[2] http://parchive.sourceforge.net/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
