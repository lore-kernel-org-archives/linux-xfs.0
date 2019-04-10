Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:35954 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729474AbfDJPBl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Apr 2019 11:01:41 -0400
Date: Wed, 10 Apr 2019 08:01:22 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: About http://man7.org/linux/man-pages/man8/xfs_repair.8.html
Message-ID: <20190410150122.GA1019523@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Manual Pages <man-pages@man7.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

Hi,

I was browsing man7.org looking for manual pages and came across this:

http://man7.org/linux/man-pages/man8/xfs_repair.8.html

Hm, that's cool that it pulls in xfsprogs manpages now. :)

Unfortunately, I got to the bottom and saw:

   "Information about the project can be found at ⟨http://xfs.org/⟩. If
   you have a bug report for this manual page, see
   ⟨http://oss.sgi.com/bugzilla/buglist.cgi?product=XFS⟩.  This page was
   obtained from the project's upstream Git repository
   ⟨git://oss.sgi.com/xfs/cmds/xfsprogs⟩ on 2019-03-06.  (At that time,
   the date of the most recent commit that was found in the repository
   was 2019-02-22.)"

The last two URLs here are incorrect.  Linux XFS no longer uses any SGI
servers, I think oss.sgi.com has been dead for 18 months, and xfs.org .
In any case, bug reports should go to [1] and the upstream git repo is
[2].  Could you please update whatever's generating man7.org?

Thanks,

--D

[1] mailto:linux-xfs@vger.kernel.org
[2] https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/
