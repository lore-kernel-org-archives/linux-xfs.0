Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAQ2kI8I103211 for <xfs@oss.sgi.com>; Thu, 25 Nov 2010 20:46:19 -0600
Received: from smtp3.clear.net.nz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C8EC41C7563E
	for <xfs@oss.sgi.com>; Thu, 25 Nov 2010 18:47:57 -0800 (PST)
Received: from smtp3.clear.net.nz (smtp3.clear.net.nz [203.97.33.64]) by
	cuda.sgi.com with ESMTP id BFX115EUOe0NrjAT for
	<xfs@oss.sgi.com>; Thu, 25 Nov 2010 18:47:57 -0800 (PST)
Received: from [210.246.8.244] (210-246-8-244.paradise.net.nz [210.246.8.244])
	by smtp3.clear.net.nz (CLEAR Net Mail)
	with ESMTP id <0LCH008LX13DZJ00@smtp3.clear.net.nz> for xfs@oss.sgi.com;
	Fri, 26 Nov 2010 15:47:39 +1300 (NZDT)
Date: Fri, 26 Nov 2010 15:43:40 +1300
From: Richard Scobie <r.scobie@clear.net.nz>
Subject: Re: Verify filesystem is aligned to stripes
Message-id: <4CEF1EDC.8020005@clear.net.nz>
MIME-version: 1.0
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
To: xfs@oss.sgi.com

  Stan Hoeppner wrote:

 > I've done no formal testing myself, but the last article I read that
 > tested md RAID1 performance showed marginally faster read performance 
 > for a two disk mirror.

All my testing of md RAID1 has shown write performance of one device and 
  single threaded read performance of one device. A second, concurrent 
read will be directed to the second device though.

Regards,

Richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
