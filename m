Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 May 2008 13:50:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m41KndaK029718
	for <xfs@oss.sgi.com>; Thu, 1 May 2008 13:49:53 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DAB27113384
	for <xfs@oss.sgi.com>; Thu,  1 May 2008 13:50:18 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 8XDYp89x324pJ0Zj for <xfs@oss.sgi.com>; Thu, 01 May 2008 13:50:18 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m41Ko7F3031639
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 1 May 2008 22:50:07 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m41Ko4S3031637
	for xfs@oss.sgi.com; Thu, 1 May 2008 22:50:04 +0200
Date: Thu, 1 May 2008 22:50:04 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: xfsqa 166 failure
Message-ID: <20080501205004.GA30384@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Looks like the awk on my system (mawk-1.3.3-11 from Debian unstable) doesn't
like the regex used in there.  I guess it's some kind of GNU awk
extension:

166	[ 2583.856446] XFS mounting filesystem hdd
[ 2583.871549] Ending clean XFS mount for filesystem: hdd
 - output mismatch (see 166.out.bad)
2,6c2,3
< 0: [AA..BB] XX..YY AG (AA..BB) RIGHT GOOD
< 1: [AA..BB] XX..YY AG (AA..BB) RIGHT GOOD
< 2: [AA..BB] XX..YY AG (AA..BB) RIGHT GOOD
< 3: [AA..BB] XX..YY AG (AA..BB) RIGHT GOOD
< 4: [AA..BB] XX..YY AG (AA..BB) RIGHT GOOD
---
> awk: line 9: regular expression compile failed (missing operand)
 * is the extent unwritten? *
