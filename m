Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7TN5j1x086786 for <xfs@oss.sgi.com>; Wed, 29 Aug 2012 18:05:45 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id jKrlr01dY1tA3ec3
	for <xfs@oss.sgi.com>; Wed, 29 Aug 2012 16:06:38 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 9D9356C147
	for <xfs@oss.sgi.com>; Wed, 29 Aug 2012 18:06:37 -0500 (CDT)
Message-ID: <503EA07D.7000602@hardwarefreak.com>
Date: Wed, 29 Aug 2012 18:06:37 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS or MDADM issue?
References: <EEB5584C-116B-4D39-8765-D3ED0F982B98@gmail.com>
In-Reply-To: <EEB5584C-116B-4D39-8765-D3ED0F982B98@gmail.com>
Reply-To: stan@hardwarefreak.com
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

On 8/29/2012 1:33 PM, Blair Sonnen wrote:
> 
> Greetings.  I do not know where to inquire next for my issue and I would 
> appreciate it if anyone could suggest something to potentially help regarding 
> XFS.  I have already submitted this bug report to mdadm on 5/31 
> (http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=675394#5), with no updates as 
> of yet.
> 
> Please read my bug report and let me know if I should be considering this a 
> potential XFS issue.  Thank you for any help you may lend and your time!

Does the md5sum change when you create a file in the XFS filesystem in
question, then copy it to another directory in the filesystem?

Which SATA controller and which drives did you add?

Do you see any ATA or other storage device related errors in dmesg?

Are you running any kind of transparent block device encryption?

Did you perform a distribution or other software upgrade directly before
of after changing the array parameters and growing the filesystem?

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
