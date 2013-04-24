Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0F35129DFA
	for <xfs@oss.sgi.com>; Wed, 24 Apr 2013 05:49:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DEEE08F8054
	for <xfs@oss.sgi.com>; Wed, 24 Apr 2013 03:49:03 -0700 (PDT)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[194.177.153.153]) by cuda.sgi.com with ESMTP id
	W8iD78jd9RuQTcgi (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Apr 2013 03:49:02 -0700 (PDT)
Received: from noclinksys.net4you.net ([194.177.153.180] helo=[192.168.34.189])
	by firestarter.dermichi.com with esmtpsa
	(TLSv1:DHE-RSA-CAMELLIA256-SHA:256) (Exim 4.80.1)
	(envelope-from <mw@dermichi.com>) id 1UUxG1-00050j-6V
	for xfs@oss.sgi.com; Wed, 24 Apr 2013 12:49:01 +0200
Message-ID: <5177B899.4000707@dermichi.com>
Date: Wed, 24 Apr 2013 12:48:57 +0200
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: XFS Support in RHEL Server 6.4 x86_64
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

Hi List!
I was under the impression that XFS was officially supported by Red Hat
Enterprise Linux.

During the installation i noticed that Anaconda wouldn't allow XFS as
root file system. Well, that's not a big problem for me. But after
installation i realized that they don't even include xfsprogs so that i
could do mkfs.xfs. Well, also not a big problem, i used the latest
tarball and compiled them myself.

But the big question now is: can anybody actually recommend using XFS on
stock RHEL? It does feel like being just a stepchild there. On the other
hand there seem be be quite a number of patches that were backported for
Red Hat's kernel and it does use delaylog by default (which IIRC wasn't
the default with a stock 2.6.32 Kernel).

tia,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
