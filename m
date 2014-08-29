Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 41CC37FB7
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 10:22:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CD1FEAC003
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 08:22:10 -0700 (PDT)
Received: from smtp.inserm.fr (smtp.inserm.fr [195.98.252.37]) by cuda.sgi.com
	with ESMTP id 3TQaPuC6qDFNVYYF (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 29 Aug 2014 08:22:06 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by smtp.inserm.fr (SrvInserm) with ESMTP id BF9D1168473
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 17:22:04 +0200 (CEST)
Received: from smtp.inserm.fr ([195.98.252.37])
	by localhost (potentille.inserm.fr [127.0.0.1]) (amavisd-new,
	port 10026) with ESMTP id gByL1T2nsJPa for <xfs@oss.sgi.com>;
	Fri, 29 Aug 2014 17:22:04 +0200 (CEST)
Received: from cognac-lmde.crcm.mrs (236-ne1068.marseille.inserm.fr
	[195.220.68.236])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by smtp.inserm.fr (SrvInserm) with ESMTP id A686916841B
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 17:22:03 +0200 (CEST)
Message-ID: <54009A9B.9000208@inserm.fr>
Date: Fri, 29 Aug 2014 17:22:03 +0200
From: Samuel Granjeaud <samuel.granjeaud@inserm.fr>
MIME-Version: 1.0
Subject: Re: Run out of inodes?
References: <54005108.1020203@inserm.fr>	<20140829114806.GA17610@bfoster.bfoster>
	<5400802C.5050005@inserm.fr> <54009603.9050404@sandeen.net>
In-Reply-To: <54009603.9050404@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


Eric Sandeen wrote, On 29/08/14 17:02:
>
> You'll want to be using the inode64 mount option for this filesystem; I'm surprised the openfiler folks didn't do this by default.
>
> http://xfs.org/index.php/XFS_FAQ#Q:_What_is_the_inode64_mount_option_for.3F
Well, I am using the 2.3 version; may be the 2.99 version does it.
> add it to fstab for this filesystem, reboot the box (or unmount/mount the filesystem) and all should be well.
I added the option and rebooted the system. A short rsync ran 
successfully, but it may not have exhausted the pool of previously 
released inodes. Tonight a bigger rsync will take place and I will let 
you know the result.

Thanks for pointing me this option, that I hesitated to apply.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
