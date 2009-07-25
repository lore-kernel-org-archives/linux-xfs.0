Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6P3rSxg169779 for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 22:53:30 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D83A313F669D
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 20:54:12 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.9])
	by cuda.sgi.com with ESMTP id bbZJXbVN28DbAagq for
	<xfs@oss.sgi.com>; Fri, 24 Jul 2009 20:54:12 -0700 (PDT)
Date: Fri, 24 Jul 2009 20:53:58 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: Using xfsdump On Linux With IRIX Version 1 FS?
In-Reply-To: <C68F8010.B953%elbles@sessys.com>
Message-ID: <alpine.DEB.2.01.0907242048000.6426@bogon.housecafe.de>
References: <C68F8010.B953%elbles@sessys.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Sean Elble <elbles@sessys.com>
Cc: xfs@oss.sgi.com

On Fri, 24 Jul 2009 at 15:13, Sean Elble wrote:
> Yeah, that's probably what I'll do then.  I figure the disk will thrash for
> a while during the search for a string in /etc/shadow, but hopefully it'll

Instead of working on the (old, slow) disk, you could just work on the 
backup (located on faster disk, I presume), maybe even set up a 
blockdevice for it:

  # losetup -r /dev/loop0 /path/to/IRIXbackup
  # hexedit /dev/loop0 ...or whatever tool you'll be using.

Christian.
-- 
BOFH excuse #378:

Operators killed by year 2000 bug bite.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
