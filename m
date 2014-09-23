Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3C3A77F3F
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 11:39:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C92B4AC004
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 09:39:24 -0700 (PDT)
Received: from mail1.g1.pair.com (mail1.g1.pair.com [66.39.3.162]) by
	cuda.sgi.com with ESMTP id YutR1CPUeFuoJ301 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Sep 2014 09:39:22 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by mail1.g1.pair.com (Postfix) with SMTP id BC4C8308A1
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 12:39:21 -0400 (EDT)
Received: from harpe.intellique.com (labo.djinux.com [82.225.196.72])
	by mail1.g1.pair.com (Postfix) with ESMTPSA id E8C0030A24
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 12:39:20 -0400 (EDT)
Date: Tue, 23 Sep 2014 18:41:49 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: compiling xfs-progs 3.2.x
Message-ID: <20140923184149.05a57dba@harpe.intellique.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


Hi list,
xfs-progs 3.1.x compile easily, however I can't get around compiling
3.2.x (debian 7.6) :

 ./configure
./configure: line 2098: AC_PROG_LIBTOOL: command not found
./configure: line 2204: syntax error near unexpected token `xfsprogs'
./configure: line 2204: `AC_PACKAGE_GLOBALS(xfsprogs)'

Any hint on where to start would be appreciated. Libtool version is the
same as testing and unstable (2.4.2).

Thanks,
-- 
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
