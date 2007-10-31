Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 31 Oct 2007 13:31:53 -0700 (PDT)
Received: from el-out-1112.google.com (el-out-1112.google.com [209.85.162.181])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9VKVmrS013165
	for <xfs@oss.sgi.com>; Wed, 31 Oct 2007 13:31:50 -0700
Received: by el-out-1112.google.com with SMTP id v27so79489ele
        for <xfs@oss.sgi.com>; Wed, 31 Oct 2007 13:31:52 -0700 (PDT)
Message-ID: <fb545b820710310835l5a187e5fs53e0bb6a613beae3@mail.gmail.com>
Date: Wed, 31 Oct 2007 21:05:33 +0530
From: "umesh deshpande" <followumesh@gmail.com>
Subject: change in the value of XFS_TRANS_PUSH_AIL_RESTARTS
MIME-Version: 1.0
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: kiran@scalex86.org

Hi,

The value of XFS_TRANS_PUSH_AIL_RESTARTS was 10 in 2.6.20 but later it was
changed to 1000.
What was the log space issue because of which the value of this variable was
changed?

Because when I tried to run dbench on Raid0 partition which was formatted
with xfs and I got few softlockups in function
xfs_trans_push_ail. But I didn't get these softlockups when I reverted back
the value of XFS_TRANS_PUSH_AIL_RESTARTS
to 10.

Regards
Umesh

Note: I am not a member of this list yet so please cc to my personal id,
Thanks


[[HTML alternate version deleted]]
