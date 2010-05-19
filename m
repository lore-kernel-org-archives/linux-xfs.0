Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4JEAVPD134110 for <xfs@oss.sgi.com>; Wed, 19 May 2010 09:10:31 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 00B3B1DF3C5C
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 07:12:49 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id AxyDyzwrJHKlBB6L
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 07:12:49 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 843256C24C
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 09:12:49 -0500 (CDT)
Message-ID: <4BF3F212.5030600@hardwarefreak.com>
Date: Wed, 19 May 2010 09:13:38 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: noatime,nodiratime?
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

Need a little education here.  I have a general understanding of what the
inode access timestamps "are" but I have no idea what, if any, applications
make use of these access times.  I see posts all over Google land saying to
use "noatime,nodiratime,logbufs=8" for XFS mount options to increase
performance.

Is there any potential downside to disabling atime?  Do daemons such as
Dovecot or Samba need these access times updated?  Do any applications need
this?

Thanks.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
