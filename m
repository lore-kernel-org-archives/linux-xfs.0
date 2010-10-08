Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o98HHYcx051585 for <xfs@oss.sgi.com>; Fri, 8 Oct 2010 12:17:34 -0500
Received: from mail-qy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E04FD494E
	for <xfs@oss.sgi.com>; Fri,  8 Oct 2010 10:18:38 -0700 (PDT)
Received: from mail-qy0-f181.google.com (mail-qy0-f181.google.com
	[209.85.216.181]) by cuda.sgi.com with ESMTP id
	zBfPKtq9JkAzHCJI for <xfs@oss.sgi.com>;
	Fri, 08 Oct 2010 10:18:38 -0700 (PDT)
Received: by qyk10 with SMTP id 10so1421448qyk.5
	for <xfs@oss.sgi.com>; Fri, 08 Oct 2010 10:18:38 -0700 (PDT)
MIME-Version: 1.0
From: James Braid <jamesb@loreland.org>
Date: Fri, 8 Oct 2010 18:17:52 +0100
Message-ID: <AANLkTinwnOm0V=9WwbXiUGFnyjCwT3GUHo0hiQahQNUV@mail.gmail.com>
Subject: ENOSPC at 90% with plenty of inodes
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

On a fairly busy mail server hosting about 1000 cyrus mailboxes (each
message is stored as a separate file), we are observing ENOSPC errors
from the cyrus pop/imap daemons when attempting to create (tiny)
files. e.g.

Oct  8 12:18:49 xxx cyrus/pop3[14119]: IOERROR: creating
/user/imap/proc/14119: No space left on device
Oct  8 12:18:49 xxx cyrus/lmtpunix[14361]: IOERROR: creating quota
file /user/imap/quota/m/user.xx.NEW: No space left on device
Oct  8 12:18:49 xxx cyrus/imap[12804]: IOERROR: creating quota file
/user/imap/quota/d/user.xxx.NEW: No space left on device

The filesystem appears to have plenty of space available:

# df -i /user
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/sdb1            102294688 10201313 92093375   10% /user
# df /user
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sdb1            213014148 190023408  22990740  90% /user

Any ideas for how can we go about debugging where ENOSPC is coming
from? Unfortunately it's running a vintage 2.6.24 kernel (Ubuntu 8.04)
- we're trying to get it upgraded to 10.04 (2.6.32)

Thanks, James

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
