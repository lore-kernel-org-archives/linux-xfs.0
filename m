Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8E0747F3F
	for <linux-xfs@oss.sgi.com>; Thu, 26 Sep 2013 17:49:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 15F15AC002
	for <linux-xfs@oss.sgi.com>; Thu, 26 Sep 2013 15:49:45 -0700 (PDT)
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id QtbLJhcBZAEexnK7 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Thu, 26 Sep 2013 15:49:41 -0700 (PDT)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1VPKNP-000800-5o
	for linux-xfs@oss.sgi.com; Fri, 27 Sep 2013 00:49:39 +0200
Received: from wombat.san-francisco.ca.us ([75.101.60.140])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 27 Sep 2013 00:49:39 +0200
Received: from kkeller by wombat.san-francisco.ca.us with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 27 Sep 2013 00:49:39 +0200
From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: free inodes remaining in 1tb
Date: Thu, 26 Sep 2013 15:47:00 -0700
Message-ID: <44qehaxod8.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

Hi all,

I "recently" (a few months ago) came across the inode64 entries in the
XFS FAQ.  Unfortunately, I have a filesystem not mounted with inode64,
and I would like to know how many more inodes I can create in the
first 1TB before I run out, so that I can plan for a migration to
inode64 (if it's very few, I would make it a high priority; if not, it
can be done in a few weeks instead, for example).  Is there an easy
way (or even a hard way) to query the filesystem for this information?

I also wanted to ask about the FAQ that says you can switch back from
inode64 to inode32.  How does that work if an inode is created past the
1TB mark?  How would the kernel know how to find an inode64 inode that
was created beyond the 1TB mark if the filesystem is subsequentely
mounted without inode64?

Thanks,

--keith

-- 
kkeller@wombat.san-francisco.ca.us


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
