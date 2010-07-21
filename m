Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6LBS6Yq075047 for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 06:28:06 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C5DEE15C1D10
	for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 04:31:06 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.186]) by cuda.sgi.com with ESMTP id
	kpuJ80wbKRDuMaGh for <xfs@oss.sgi.com>;
	Wed, 21 Jul 2010 04:31:06 -0700 (PDT)
Received: from localhost ([127.0.0.1])
	by bogon.housecafe.de with esmtp (Exim 4.69)
	(envelope-from <lists@nerdbynature.de>) id 1ObXVt-0004lw-8X
	for xfs@oss.sgi.com; Wed, 21 Jul 2010 13:31:01 +0200
Date: Wed, 21 Jul 2010 04:31:01 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: xfsprogs: only absolute run-paths are allowed
Message-ID: <alpine.DEB.2.01.1007210408390.3964@bogon.housecafe.de>
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
To: xfs@oss.sgi.com

Hi,

I noticed that I can't use --prefix= any more for the ./configure script. 
Doing so makes libtool unhappy:

$ make configure
$ ./configure --prefix=/opt/xfsprogs
$ make
[...]
libtool: link: only absolute run-paths are allowed
make[2]: *** [libxfs.la] Error 1

Digging through the releases I noticed that using --prefix= was possible 
with v3.0.4 but fails with v3.0.5, more exactly commit 595e27 seems to be
the changeset in question, as reverting it helps:

   commit 595e27dbd7360e81fa9e74d992098fe44fd7aed5
   Author: Christoph Hellwig <hch@lst.de>
   Date:   Sat Oct 10 17:02:53 2009 -0400

      update configure defaults


So, I guess my question is: how can I build xfsprogs to install in a 
different location?

Full buildlogs: http://nerdbynature.de/bits/xfsprogs/prefix/

Thanks,
Christian.
-- 
BOFH excuse #94:

Internet outage

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
