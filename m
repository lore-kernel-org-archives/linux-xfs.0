Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Aug 2007 09:29:43 -0700 (PDT)
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.243])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7LGTabm007579
	for <xfs@oss.sgi.com>; Tue, 21 Aug 2007 09:29:39 -0700
Received: by an-out-0708.google.com with SMTP id c38so174734ana
        for <xfs@oss.sgi.com>; Tue, 21 Aug 2007 09:29:41 -0700 (PDT)
Message-ID: <9ee2fe770708210826n5952e727od0df16a5a7b267f0@mail.gmail.com>
Date: Tue, 21 Aug 2007 21:11:56 +0545
From: "kanishk rastogi" <kanishk.85@gmail.com>
Subject: Need of inode->i_mutex in xfs_write()
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I was looking at the xfs_write code path in kernel 2.6.20 .......
I saw it acquiring inode->i_mutex .
Whats the need ?
What are we safegaurding inode for.

AFAIK its used for protecting the incode inode. (CMIIW)

regards
kanishk
