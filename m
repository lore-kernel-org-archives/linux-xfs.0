Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 50D107F60
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 18:56:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D44C0AC001
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 16:56:37 -0700 (PDT)
Received: from mail-pb0-f47.google.com (mail-pb0-f47.google.com
	[209.85.160.47]) by cuda.sgi.com with ESMTP id tu75AOdqOTZZIfVt
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 26 Jun 2013 16:56:36 -0700 (PDT)
Received: by mail-pb0-f47.google.com with SMTP id rr13so102203pbb.34
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 16:56:36 -0700 (PDT)
Received: from briankrusicw.logan.tv ([64.17.255.138])
	by mx.google.com with ESMTPSA id z19sm747143paf.12.2013.06.26.16.56.34
	for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
	Wed, 26 Jun 2013 16:56:35 -0700 (PDT)
From: aurfalien <aurfalien@gmail.com>
Subject: sizing log - is there a too big?
Date: Wed, 26 Jun 2013 16:56:31 -0700
Message-Id: <55C24454-59E9-4285-9A4C-C4BD24EDBEEC@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1085)
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

Hi all,

Wondering if my log being just under 2GB is a bad idea.

Noticing flush-253:2/kcopyd which is my XFS file system getting really high load avg and wait times via top).

Doing a simple rsync over NFS and after a bit, the system gets to a load of 24.... yikes...

Upon killing the rsync, I am seeing loads going down to sub 1 after about 10 min.  I have repeated this to verify 10 min.

- aurf



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
