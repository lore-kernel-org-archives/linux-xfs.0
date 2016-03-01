Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A66847CB4
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 13:05:08 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7FA8B8F8033
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 11:05:05 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wGfOoKP1vDsjHPjb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Mar 2016 11:05:01 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: ASSERT in xlog_find_verify_log_record during xfs/098
Message-ID: <56D5E7DA.3080900@redhat.com>
Date: Tue, 1 Mar 2016 13:04:58 -0600
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
Cc: Al Viro <viro@ZenIV.linux.org.uk>

Al mentioned that he hit an ASSERT during xfs/098, a log fuzzer
test, in xlog_find_verify_log_record():


        for (i = (*last_blk) - 1; i >= 0; i--) {
                if (i < start_blk) {
                        /* valid log record not found */
                        xfs_warn(log->l_mp,
                "Log inconsistent (didn't find previous header)");
                        ASSERT(0);
                        error = -EIO;
                        goto out;
                }

Should that assert even be there?  Looks like it's gracefully
handled, I don't see offhand that anything should have caught
this corruption earlier, and we don't really want to bug on disk
corruption.  Am I missing something?

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
