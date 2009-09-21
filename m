Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8LEYPEv098251 for <xfs@oss.sgi.com>; Mon, 21 Sep 2009 09:34:27 -0500
Subject: List corruption with defective XFS image
From: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
Date: Mon, 21 Sep 2009 16:35:09 +0200
Message-Id: <1253543709.3490.43.camel@queen>
Mime-Version: 1.0
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
To: xfs-masters@oss.sgi.com
Cc: felixb@sgi.com, xfs@oss.sgi.com

Hi,

The following XFS image http://www.cccmz.de/~snakebyte/xfs.76.img
produces some linked list corruption warnings when a copy is issued

touch /media/test/filea
mkdir /media/test/dir
cp /media/test/filea /media/test/dir

http://www.cccmz.de/~snakebyte/xfs.76.img.txt

When I enable XFS Debugging it already oopses during filesystem mount:

http://www.cccmz.de/~snakebyte/xfs.76.img.debug.txt

Regards, Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
