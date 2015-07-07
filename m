Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E7A377F37
	for <xfs@oss.sgi.com>; Tue,  7 Jul 2015 04:29:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C3A84304032
	for <xfs@oss.sgi.com>; Tue,  7 Jul 2015 02:29:46 -0700 (PDT)
Received: from mail-yk0-f178.google.com (mail-yk0-f178.google.com
	[209.85.160.178]) by cuda.sgi.com with ESMTP id
	FL9Ofle7EDokegFu (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 07 Jul 2015 02:29:44 -0700 (PDT)
Received: by ykeo3 with SMTP id o3so51804075yke.0
	for <xfs@oss.sgi.com>; Tue, 07 Jul 2015 02:29:44 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 7 Jul 2015 17:29:43 +0800
Message-ID: <CA+eFSM30A1V7j4CYJOyLSN7V7REHt0hrxteU1dVRw4HQZLmuxw@mail.gmail.com>
Subject: Possible memory allocation deadlock in kmem_alloc and hung task in
	xfs_log_commit_cil and xlog_cil_push
From: Gavin Guo <gavin.guo@canonical.com>
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
To: xfs@oss.sgi.com, linux-kernel <linux-kernel@vger.kernel.org>

Hi all,

Recently, we observed that there is the error message in
Ubuntu-3.13.0-48.80:

"XFS: possible memory allocation deadlock in kmem_alloc (mode:0x8250)"

repeatedly shows in the dmesg. Temporarily, our workaround is to tune the
parameters, such as, vfs_cache_pressure, min_free_kbytes, and dirty_ratio.

And we also found that there are different error messages regarding the
hung tasks which happened in xfs_log_commit_cil and xlog_cil_push.

The log is available at: http://paste.ubuntu.com/11835007/

The following link seems the same problem we suffered:

XFS hangs with XFS: possible memory allocation deadlock in kmem_alloc
http://oss.sgi.com/archives/xfs/2015-03/msg00172.html

I read the mail and found that there might be some modification regarding
to move the memory allocation outside the ctx lock. And I also read the
latest patch from February of 2015 to see if there is any new change
about that. Unfortunately, I didn't find anything regarding the change (may
be I'm not familiar with the XFS, so didn't find the commit). If it's
possible for someone who is familiar with the code to point out the commits
related to the bug if already exist or any status about the plan.

Thanks,
Gavin Guo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
