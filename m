Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8RNShw8071316 for <xfs@oss.sgi.com>; Tue, 27 Sep 2011 18:28:43 -0500
Received: from mta11.charter.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 20E7D160EBB8
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2011 16:34:39 -0700 (PDT)
Received: from mta11.charter.net (mta11.charter.net [216.33.127.80]) by
	cuda.sgi.com with ESMTP id DxX7BDtd2hRD19R5 for
	<xfs@oss.sgi.com>; Tue, 27 Sep 2011 16:34:39 -0700 (PDT)
Received: from imp10 ([10.20.200.15]) by mta11.charter.net
	(InterMail vM.7.09.02.04 201-2219-117-106-20090629) with ESMTP
	id <20110927232839.BSVJ4091.mta11.charter.net@imp10>
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2011 19:28:39 -0400
Received: from [172.17.100.41] (unknown [67.130.187.94])
	by cchtml.com (Postfix) with ESMTPSA id A38AEC0287BED
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2011 18:28:37 -0500 (CDT)
Message-ID: <4E825C25.6050804@cchtml.com>
Date: Tue, 27 Sep 2011 18:28:37 -0500
From: Michael Cronenworth <mike@cchtml.com>
MIME-Version: 1.0
Subject: 64-bit inodes and back again
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

Hello,

I enabled 64-bit inodes on a 2.6.35.14 kernel system. I ran into some 
software that did not handle this well, so I wanted to go back to 32-bit 
inodes. When I booted into the system again, any files that were created 
while in 64-bit inode mode are inaccessable and are shown to me like this:

$ ls -l /var/lib/mock/
ls: cannot access /var/lib/mock/dist-5E-build-373-1401: Invalid argument
??????????? ? ?    ?     ?            ? dist-5E-build-373-1401

I was led[1] to believe that this would not cause problems, but it has.

I have run xfs_repair on the file system but the old files still remain.

Are there any other things I can do to fix this? One thought is to 
remount with 64-bit inodes and erase or copy the offending files, but is 
that my only option?

[1] 
http://xfs.org/index.php/XFS_FAQ#Q:_Can_I_just_try_the_inode64_option_to_see_if_it_helps_me.3F

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
