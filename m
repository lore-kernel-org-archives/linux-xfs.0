Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E2DAC7F4C
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 03:43:38 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D116F8F8035
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 01:43:35 -0800 (PST)
Received: from awesome.dsw2k3.info (awesome.dsw2k3.info [195.71.86.230]) by
	cuda.sgi.com with ESMTP id 2RKUwRf6r6L3wKmj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 18 Feb 2013 01:43:30 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by awesome.dsw2k3.info (Postfix) with ESMTP id E7FBEBFF41
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 10:43:28 +0100 (CET)
Received: from awesome.dsw2k3.info ([127.0.0.1])
	by localhost (awesome.dsw2k3.info [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3UzGqD5NNvmJ for <xfs@oss.sgi.com>;
	Mon, 18 Feb 2013 10:43:22 +0100 (CET)
Received: from citd.de (p4FC4A312.dip.t-dialin.net [79.196.163.18])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by awesome.dsw2k3.info (Postfix) with ESMTPSA
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 10:43:22 +0100 (CET)
Date: Mon, 18 Feb 2013 10:43:20 +0100
From: Matthias Schniedermeyer <ms@citd.de>
Subject: inode64 and 64bit kernel with 32bit userspace
Message-ID: <20130218094320.GA24644@citd.de>
MIME-Version: 1.0
Content-Disposition: inline
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi


The more or less simple question is:
Is the requirement for 32bit programs to support 64bit inodes the same 
as LFS(Large File Support)?

IOW if a programs was compiled with FILE_OFFSET_BITS=64 (if i remember 
that name correctly) should it work?
So that all programs compiled in the last several years in a halfway 
recent distribution should be able to cope with 64bit inodes?

The program i care about most is rsync and it appears to work correctly 
when i tested it with 2 hard-linked files (with an inode >2^32) and the 
option to preserve hard links. And "find" and "stat" also worked, 
otherwise i couldn't have found the file to test it with. ;-)



-- 

Matthias

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
