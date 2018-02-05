Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59866 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750990AbeBEXWT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Feb 2018 18:22:19 -0500
Subject: [PATCH 0/7] xfsprogs: 4.15 rollup pt. 5
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 05 Feb 2018 15:22:14 -0800
Message-ID: <151787293446.3743.11110014829952400444.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

A bunch of scrub fixes here -- disable syslog if we're debugging the program,
tidying up the scrub manpage to avoid mentioning things that it doesn't yet
know how to do, removing preen mode to bring the command line usage in line
with xfs_repair, fixing complaints about the report that gets printed at the
end, and reclassifying how a lot of runtime errors get logged so that the
return status reflects this.

--D
