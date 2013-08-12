Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D26237F3F
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 13:29:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BD5A3304032
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 11:29:27 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id LEC3uWs8XaTHbqqj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 11:29:25 -0700 (PDT)
Date: Mon, 12 Aug 2013 22:29:24 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: GRUB doesn't work on CRC enabled fs
Message-ID: <20130812202924.GA354@x4>
MIME-Version: 1.0
Content-Disposition: inline
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

Just a heads-up: GRUB currently doesn't work on a CRC enabled
file-system. It will print the following error message:
 "not a correct XFS inode"

GRUB's xfs implementation can be found here:
http://bzr.savannah.gnu.org/lh/grub/trunk/grub/annotate/head:/grub-core/fs/xfs.c

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
