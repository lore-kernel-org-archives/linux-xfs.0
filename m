Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E238E29DF8
	for <linux-xfs@oss.sgi.com>; Tue, 11 Jun 2013 04:56:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CBFD8304039
	for <linux-xfs@oss.sgi.com>; Tue, 11 Jun 2013 02:56:57 -0700 (PDT)
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id CDKKFfJAFz5YNQl0 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Tue, 11 Jun 2013 02:56:56 -0700 (PDT)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1UmLJu-0000ZB-R1
	for linux-xfs@oss.sgi.com; Tue, 11 Jun 2013 11:56:54 +0200
Received: from adsl-76-242-190-187.dsl.okcyok.sbcglobal.net ([76.242.190.187])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 11 Jun 2013 11:56:54 +0200
Received: from sbergman27 by adsl-76-242-190-187.dsl.okcyok.sbcglobal.net with
	local (Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 11 Jun 2013 11:56:54 +0200
From: Steve Bergman <sbergman27@gmail.com>
Subject: Questions about XFS
Date: Tue, 11 Jun 2013 09:56:38 +0000 (UTC)
Message-ID: <loom.20130611T112155-970@post.gmane.org>
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

I have a few questions about XFS that didn't make the XFS FAQ. I'm trying to
get a feel for where I might want to use it on my servers (or at home). A
mix of ext3 & ext4 has worked well for me. But I'd like to get to know XFS a
bit better. The target OS would be RHEL6.

1. I don't have "lots and large". Why should I run XFS?

2. I don't have "lots and large". Why shouldn't I run XFS?

3. Why doesn't RHEL6 support XFS on root, when the XFS FAQ says XFS on root
is fine? Is there some issue I should be aware of?

4. From the time I write() a bit of data, what's the maximum time before the
data is actually committed to disk?

5. Ext4 provides some automatic fsync'ing to avoid the zero-length file
issue for some common cases via the auto_da_alloc feature added in kernel
2.6.30. Does XFS have similar behavior? 

6. RHEL6 Anaconda sets a RAID10 chunk size of 512K by default XFS complains
and sets its log stripe down to 32k. Should I accept Anaconda's default? It
knows I've requested XFS formatting before it sets the chunk size, after all.

8. Eric (and the XFS FAQ) have recommended just using the defaults for
mkfs.xfs and mount. But I've also heard Dave say "Increase logbsize and use
inode64; everybody does that, but we just haven't made it the default". I'm
guessing it doesn't matter if one doesn't have large and lots?

9. I there something else I should have thought to ask?

Thanks for any insights,

Steve Bergman

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
