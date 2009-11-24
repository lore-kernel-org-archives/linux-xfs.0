Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAOGN4EH148621 for <xfs@oss.sgi.com>; Tue, 24 Nov 2009 10:23:05 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 98D4D4C63C7
	for <xfs@oss.sgi.com>; Tue, 24 Nov 2009 08:23:29 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EZOt12cQEyVeQdC5 for
	<xfs@oss.sgi.com>; Tue, 24 Nov 2009 08:23:29 -0800 (PST)
Message-ID: <4B0C087E.6050701@sandeen.net>
Date: Tue, 24 Nov 2009 10:23:26 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Which kernel options should be enabled to find the root cause
	of this bug?
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan>
	<alpine.DEB.2.00.0911240805490.25676@p34.internal.lan>
	<4B0BF866.7040004@sandeen.net>
	<alpine.DEB.2.00.0911241115080.7755@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.0911241115080.7755@p34.internal.lan>
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Justin Piszcz wrote:
> 
> On Tue, 24 Nov 2009, Eric Sandeen wrote:

...

>> Do you get the same behavior if you don't add the log options at mount time?
> I have not tried disabling the log options, although they have been in effect
> for a long time, (the logsbufs and bufsize and recently) the nobarrier
> support.  Could there be an issue using -o nobarrier on a raid1+xfs?

nobarrier should not cause problems.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
