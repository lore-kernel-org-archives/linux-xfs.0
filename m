Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6KKW3dl039780 for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 15:32:03 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E939145D5D8
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 13:30:02 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id AcAk2jRkZAZbqfbx
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 13:30:02 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 9EAC76C011
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 15:30:01 -0500 (CDT)
Message-ID: <4C460748.3080608@hardwarefreak.com>
Date: Tue, 20 Jul 2010 15:30:00 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: 4k sector drives
References: <201007202058.35141@zmi.at>
In-Reply-To: <201007202058.35141@zmi.at>
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

Michael Monnerie put forth on 7/20/2010 1:58 PM:
> Dear list, I don't know who else to ask this:
> 
> I recently bought 2 new 4k sector drives (WD Caviar Green 2TB, 
> WD20EARS), but Linux kernel 2.6.34.1 still says:
> 
> # blockdev --getss /dev/sdd
> 512
> 
> Shouldn't that be 4096? Where is the problem?

Firmware sector size translation is the problem.  The WD20EARS is apparently
not a native 4096K sector size drive, but a transitional product.  It is 4k
sector size internally but the firmware translates this to 512B sectors to the
OS driver.  It's a hybrid.

Google "WD20EARS sector size"

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
