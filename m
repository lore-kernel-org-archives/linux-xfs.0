Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3D4c0ea190676 for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 23:38:00 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 349AD126B761
	for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 21:39:54 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.171]) by cuda.sgi.com with ESMTP id
	FPZXxpJZtQ6iRHBr for <xfs@oss.sgi.com>;
	Mon, 12 Apr 2010 21:39:54 -0700 (PDT)
Date: Mon, 12 Apr 2010 21:39:43 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.34-rc3: inode 0x401afe0 background reclaim flush failed with
	11
In-Reply-To: <20100413042451.GQ2493@dastard>
Message-ID: <alpine.DEB.2.01.1004122135350.29272@bogon.housecafe.de>
References: <alpine.DEB.2.01.1004091348010.29272@bogon.housecafe.de>
	<20100413024946.GP2493@dastard>
	<alpine.DEB.2.01.1004121950510.29272@bogon.housecafe.de>
	<20100413042451.GQ2493@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


For the sake of the archives:

On Tue, 13 Apr 2010 at 14:24, Dave Chinner wrote:
> Hmmm - I'd never realised that find doesn't decode hex numbers.
> I guess I rarely use find for that purpose. I'll keep that in mind
> when adding new output.

No, but standard /bin/sh can do it:

   $ find . -inum $((0xff)) -ls
   255    0 -rw-r--r--   1 root     root      0 Apr 12 21:35 ./0156

I'll have to remember this next time...

Thanks,
Christian.
-- 
BOFH excuse #276:

U.S. Postal Service

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
