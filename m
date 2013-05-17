Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5AE377F3F
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 11:36:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3A63830407F
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 09:36:35 -0700 (PDT)
Received: from limestone3.mail.cornell.edu (limestone3.mail.cornell.edu
	[128.253.83.163]) by cuda.sgi.com with ESMTP id
	ZWBh7nZOehRIZCIG for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 09:36:30 -0700 (PDT)
Received: from alva02.serverfarm.cornell.edu (alva02.serverfarm.cornell.edu
	[128.84.106.39])
	by limestone3.mail.cornell.edu (8.14.4/8.14.4) with ESMTP id
	r4HGaOj6028486
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 12:36:25 -0400 (EDT)
Received: from sf-en-pub-002.serverfarm.cornell.edu
	(sf-en-pub-002.serverfarm.cornell.edu [132.236.207.16])
	by alva02.serverfarm.cornell.edu (8.14.4/8.14.4) with ESMTP id
	r4HGaTZg019798 for <xfs@oss.sgi.com>; Fri, 17 May 2013 12:36:29 -0400
Received: from sf-en-pub-002.serverfarm.cornell.edu (localhost [127.0.0.1])
	by sf-en-pub-002.serverfarm.cornell.edu (Postfix) with ESMTP id
	1D75D420A7
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 12:36:29 -0400 (EDT)
Received: from sf-en-pub-002.serverfarm.cornell.edu (localhost [127.0.0.1])
	by sf-en-pub-002.serverfarm.cornell.edu (Postfix) with ESMTP id
	11FF641F8A
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 12:36:29 -0400 (EDT)
Date: Fri, 17 May 2013 12:36:29 -0400 (EDT)
From: Josh Endries <endries@cs.cornell.edu>
Message-ID: <731755347.10846.1368808589019.JavaMail.root@coecis.cornell.edu>
In-Reply-To: <1601451892.10839.1368808313900.JavaMail.root@coecis.cornell.edu>
Subject: Crash recovery/zero-byte file question
MIME-Version: 1.0
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

Hello,

We have a RHEL 6.3 machine with a large XFS mount that suffered a power outage. When it came back up, it allegedly fixed itself, but now many files are zero bytes. I found a bug report/errata fix at RH that mentions something similar, which might be what we ran into. We are running a kernel that should have the fix as far as I can tell, but we definitely have zero byte files that shouldn't be.

My question is: is there a way to restore this or fix it before going to backups? Is it worth it to unmount and run xfs_check or similar? Unfortunately, since the system came up and appeared to be working, some users have been using that mount point.

Thanks,
Josh

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
