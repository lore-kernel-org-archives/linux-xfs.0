Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64400C7EE2E
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jun 2023 15:53:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbjFLPxK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 11:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbjFLPxJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jun 2023 11:53:09 -0400
Received: from out02.mta.xmission.com (out02.mta.xmission.com [166.70.13.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3396710E2;
        Mon, 12 Jun 2023 08:53:08 -0700 (PDT)
Received: from in02.mta.xmission.com ([166.70.13.52]:40524)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1q8jqs-0087ZJ-2N; Mon, 12 Jun 2023 09:53:06 -0600
Received: from ip68-110-29-46.om.om.cox.net ([68.110.29.46]:35760 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1q8jqr-00G1o3-4k; Mon, 12 Jun 2023 09:53:05 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
References: <20230611124836.whfktwaumnefm5z5@zlang-mailbox>
        <ZIZSPyzReZkGBEFy@dread.disaster.area>
        <20230612015145.GA11441@frogsfrogsfrogs>
        <ZIaBQnCKJ6NsqGhd@dread.disaster.area>
        <CAHk-=whJqZLKPR-cpX-V4wJTXVX-_tG5Vjuj2q9knvKGCPdfkg@mail.gmail.com>
        <20230612153629.GA11427@frogsfrogsfrogs>
Date:   Mon, 12 Jun 2023 10:52:37 -0500
In-Reply-To: <20230612153629.GA11427@frogsfrogsfrogs> (Darrick J. Wong's
        message of "Mon, 12 Jun 2023 08:36:29 -0700")
Message-ID: <87zg54r83e.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1q8jqr-00G1o3-4k;;;mid=<87zg54r83e.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.110.29.46;;;frm=ebiederm@xmission.com;;;spf=pass
X-XM-AID: U2FsdGVkX19l2ouqJHn9zcO+QmRcaljj7Zv6Ie2q7/g=
X-SA-Exim-Connect-IP: 68.110.29.46
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [6.5-rc5 regression] core dump hangs (was Re: [Bug report]
 fstests generic/051 (on xfs) hang on latest linux v6.5-rc5+)
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


Can someone who can reproduce the hang run this test patch.

I am currently drawing a blank looking at the changes, so I am
proposing some debug code to help us narrow things down.

Can someone who can reproduce this run the code below?

The tests reproducing this don't appear to use use /dev/host-net or
/dev/vhost-vsock.  So if the WARN_ON's trigger it is a good sign
that code connected to the WARN_ON's are wrong.

If the WARN_ON's don't trigger I suspect the code in kernel/fork.c

But as I said staring at the code I don't see anything wrong.

Eric


diff --git a/fs/coredump.c b/fs/coredump.c
index 88740c51b942..e9acf0a2d2f0 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -374,6 +374,7 @@ static int zap_process(struct task_struct *start, int exit_code)
 			/* The vhost_worker does not particpate in coredumps */
 			if ((t->flags & (PF_USER_WORKER | PF_IO_WORKER)) != PF_USER_WORKER)
 				nr++;
+			else WARN_ON_ONCE(true);
 		}
 	}
 
diff --git a/kernel/exit.c b/kernel/exit.c
index edb50b4c9972..56002a58ec33 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -437,6 +437,7 @@ static void coredump_task_exit(struct task_struct *tsk)
 		}
 		__set_current_state(TASK_RUNNING);
 	}
+	else if (core_state) WARN_ON_ONCE(true);
 }
 
 #ifdef CONFIG_MEMCG
diff --git a/kernel/signal.c b/kernel/signal.c
index 2547fa73bde5..1be27dbbce62 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1371,6 +1371,7 @@ int zap_other_threads(struct task_struct *p)
 		/* Don't require de_thread to wait for the vhost_worker */
 		if ((t->flags & (PF_IO_WORKER | PF_USER_WORKER)) != PF_USER_WORKER)
 			count++;
+		else WARN_ON_ONCE(true);
 
 		/* Don't bother with already dead threads */
 		if (t->exit_state)
