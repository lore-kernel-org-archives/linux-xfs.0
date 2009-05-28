Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4SCLYIJ253095 for <xfs@oss.sgi.com>; Thu, 28 May 2009 07:21:35 -0500
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B54001D377BC
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 05:21:48 -0700 (PDT)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[83.64.48.195]) by cuda.sgi.com with ESMTP id to7BaKMchsqtrNJF
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 05:21:48 -0700 (PDT)
Received: from cerberus.net4you.net ([194.177.153.130] helo=[192.168.200.110])
	by firestarter.dermichi.com with esmtpsa
	(TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32) (Exim 4.69)
	(envelope-from <mw@dermichi.com>) id 1M9ecF-0004Wv-92
	for xfs@oss.sgi.com; Thu, 28 May 2009 14:21:47 +0200
Message-ID: <4A1E81D8.7010706@dermichi.com>
Date: Thu, 28 May 2009 14:21:44 +0200
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: regarding the inode64 mount option
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

Hi XFS-List!
I understand that the inode64 mount option allows inodes to be created beyond 1TB. There are also certain performance problems that can be cured by using this option when handling LOTS of inodes. During my tests i noticed that enabling it is like a one-way street. Inodes created with inode64 enabled aren't accessible when the option is left out.

Now i got a few questions:
- Does the inode64 option work only on 64bit architectures or is it also possible to use it with i686
- Is there a way to convert the inodes back
- Why doesn't the filesystem remember that inode64 was used in the past and enable it automatically
- Do i have to pass inode64 via grub / lilo if i want to use it on my root filesystem

I haven't found any definitive clear documentation abount the pro's and con's, so maybe you can give me some hints :-)

tia,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
