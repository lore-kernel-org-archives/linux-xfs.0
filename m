Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o66GF8uE191885 for <xfs@oss.sgi.com>; Tue, 6 Jul 2010 11:15:09 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AE47142CF83
	for <xfs@oss.sgi.com>; Tue,  6 Jul 2010 09:17:59 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id rl9QXcZPSIk0ZEFM
	for <xfs@oss.sgi.com>; Tue, 06 Jul 2010 09:17:59 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id C7A7B6C3F1
	for <xfs@oss.sgi.com>; Tue,  6 Jul 2010 11:17:58 -0500 (CDT)
Message-ID: <4C335736.1070701@hardwarefreak.com>
Date: Tue, 06 Jul 2010 11:17:58 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: CentOS 5.5 XFS internal errors (XFS_WANT_CORRUPTED_GOTO)
References: <AANLkTimKKEvfJx6EQZeQF_HnlBLj6B8Kjfy6jUHGPnz5@mail.gmail.com>
In-Reply-To: <AANLkTimKKEvfJx6EQZeQF_HnlBLj6B8Kjfy6jUHGPnz5@mail.gmail.com>
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

Shaun Adolphson put forth on 7/6/2010 5:57 AM:

> Software:
> - Fresh install of CentOS 5.5 64bit all patches up to date
> - Kernel 2.6.18-194.3.1.el5.centos.plus

First thing that comes to mind is the fact that 2.6.18 is about 3 years old.
I'm not familiar with CentOS patching policies, but even if you've received
and applied some XFS patches, they'd still probably be rather old.

If CentOS 5.5 doesn't have a much newer kernel package available, say 2.6.30
or later, if I were you, I'd grab the kernel source from kernel.org and roll
your own 2.6.33.6 or 2.6.34.1.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
