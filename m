Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8NM2j9m150627 for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 17:02:45 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3C9C19833E
	for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 15:03:40 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id YBuKy4BGmfObUuPn
	for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 15:03:40 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 7FBF06C0BA
	for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 17:03:39 -0500 (CDT)
Message-ID: <4C9BCEBB.4030800@hardwarefreak.com>
Date: Thu, 23 Sep 2010 17:03:39 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Question regarding performance on big files.
References: <4C979439.7070906@opencubetech.com>	<4C97BA74.5030304@hardwarefreak.com>	<4C99D9EB.20800@opencubetech.com>	<4C9A69DC.8020606@hardwarefreak.com>
	<4C9B161A.1010301@opencubetech.com>
In-Reply-To: <4C9B161A.1010301@opencubetech.com>
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
To: xfs@oss.sgi.com

Mathieu AVILA put forth on 9/23/2010 3:55 AM:

> The small writes are amortized in the stream of data writes from the
> application, and the application is not frozen.
> (so you were right: there was a page cache issue)

Given what you've described about the streaming write behavior of your
application, I'd suggest you rewrite it and use O_DIRECT writes to
bypass the page cache completely.  You may also want to look into using
the XFS realtime subvolume feature.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
