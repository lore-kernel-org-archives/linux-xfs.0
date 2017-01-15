Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from buxtehude.debian.org ([209.87.16.39]:52422 "EHLO
        buxtehude.debian.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751200AbdAOSPK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Jan 2017 13:15:10 -0500
MIME-Version: 1.0
From: owner@bugs.debian.org (Debian Bug Tracking System)
Subject: Bug#822369: marked as done (xfsprogs: FTBFS: error: redefinition
 of 'struct fsxattr')
Message-ID: <handler.822369.D822369.14845039381399.ackdone@bugs.debian.org>
References: <20170115181203.hre34x37wsalbrnu@localhost>
 <20160423210831.GA19384@jirafa.cyrius.com>
Date: Sun, 15 Jan 2017 18:15:05 +0000
Content-Type: multipart/mixed; boundary="----------=_1484504105-2219-0"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Adrian Bunk <bunk@debian.org>

This is a multi-part message in MIME format...

------------=_1484504105-2219-0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=utf-8

Your message dated Sun, 15 Jan 2017 20:12:03 +0200
with message-id <20170115181203.hre34x37wsalbrnu@localhost>
and subject line 4.9.0 builds
has caused the Debian Bug report #822369,
regarding xfsprogs: FTBFS: error: redefinition of 'struct fsxattr'
to be marked as done.

This means that you claim that the problem has been dealt with.
If this is not the case it is now your responsibility to reopen the
Bug report if necessary, and/or fix the problem forthwith.

(NB: If you are a system administrator and have no idea what this
message is talking about, this may indicate a serious mail system
misconfiguration somewhere. Please contact owner@bugs.debian.org
immediately.)


--=20
822369: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D822369
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems

------------=_1484504105-2219-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at submit) by bugs.debian.org; 23 Apr 2016 21:08:40 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.0-bugs.debian.org_2005_01_02
	(2014-02-07) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=4.0 tests=BAYES_00,DIGITS_LETTERS,
	HAS_PACKAGE,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL
	autolearn=ham autolearn_force=no version=3.4.0-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 17; hammy, 122; neutral, 23; spammy,
	0. spammytokens: hammytokens:0.000-+--H*UA:2014-03-12,
	0.000-+--H*u:2014-03-12, 0.000-+--H*u:1.5.23, 0.000-+--H*UA:1.5.23,
	0.000-+--michlmayr
Return-path: <tbm@hpe.com>
Received: from g1t6213.austin.hp.com ([15.73.96.121])
	by buxtehude.debian.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.84_2)
	(envelope-from <tbm@hpe.com>)
	id 1au4nA-0007vj-GM
	for submit@bugs.debian.org; Sat, 23 Apr 2016 21:08:40 +0000
Received: from g1t6217.austin.hpicorp.net (g1t6217.austin.hpicorp.net [15.67.1.144])
	by g1t6213.austin.hp.com (Postfix) with ESMTP id AC8DD99
	for <submit@bugs.debian.org>; Sat, 23 Apr 2016 21:08:33 +0000 (UTC)
Received: from loric-alpo.cyrius.com (ospra0.fc.hp.com [16.79.38.117])
	by g1t6217.austin.hpicorp.net (Postfix) with ESMTP id 7A8525F
	for <submit@bugs.debian.org>; Sat, 23 Apr 2016 21:08:33 +0000 (UTC)
Received: by loric-alpo.cyrius.com (Postfix, from userid 1000)
	id E4973690AC; Sat, 23 Apr 2016 23:08:31 +0200 (CEST)
Date: Sat, 23 Apr 2016 14:08:31 -0700
From: Martin Michlmayr <tbm@hpe.com>
To: submit@bugs.debian.org
Subject: xfsprogs: FTBFS: error: redefinition of 'struct fsxattr'
Message-ID: <20160423210831.GA19384@jirafa.cyrius.com>
References: <20160423205226.67773120316@dl580gen9-02.hlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160423205226.67773120316@dl580gen9-02.hlinux>
User-Agent: Mutt/1.5.23 (2014-03-12)
Delivered-To: submit@bugs.debian.org

Package: xfsprogs
Version: 4.3.0+nmu1
Severity: serious

This package fails to build in unstable:

> sbuild (Debian sbuild) 0.68.0 (15 Jan 2016) on dl580gen9-02.hlinux
...
>     [CC]     fiemap.o
> In file included from ../include/xfs.h:58:0,
>                  from io.h:19,
>                  from fiemap.c:24:
> ../include/xfs/xfs_fs.h:42:8: error: redefinition of 'struct fsxattr'
>  struct fsxattr {
>         ^
> In file included from fiemap.c:22:0:
> /usr/include/linux/fs.h:155:8: note: originally defined here
>  struct fsxattr {
>         ^
> ../include/buildrules:59: recipe for target 'fiemap.o' failed
> make[3]: *** [fiemap.o] Error 1
> include/buildrules:35: recipe for target 'io' failed

-- 
Martin Michlmayr
Linux for HPE Helion, Hewlett Packard Enterprise

------------=_1484504105-2219-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 822369-done) by bugs.debian.org; 15 Jan 2017 18:12:18 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.0-bugs.debian.org_2005_01_02
	(2014-02-07) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=4.0 tests=BAYES_00,FROMDEVELOPER,
	VERSION autolearn=ham autolearn_force=no
	version=3.4.0-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 12; hammy, 95; neutral, 33; spammy, 0.
	spammytokens: hammytokens:0.000-+--sk:buildd., 0.000-+--UD:buildd.debian.org,
	0.000-+--buildddebianorg, 0.000-+--buildd.debian.org, 0.000-+--H*UA:NeoMutt
Return-path: <bunk@debian.org>
Received: from mail.stusta.mhn.de ([2001:4ca0:200:3:200:5efe:8d54:4505])
	by buxtehude.debian.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.84_2)
	(envelope-from <bunk@debian.org>)
	id 1cSpHu-0000MI-30
	for 822369-done@bugs.debian.org; Sun, 15 Jan 2017 18:12:18 +0000
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.stusta.mhn.de (Postfix) with ESMTPSA id 3v1kwb5qXhz1y
	for <822369-done@bugs.debian.org>; Sun, 15 Jan 2017 19:12:15 +0100 (CET)
Date: Sun, 15 Jan 2017 20:12:03 +0200
From: Adrian Bunk <bunk@debian.org>
To: 822369-done@bugs.debian.org
Subject: 4.9.0 builds
Message-ID: <20170115181203.hre34x37wsalbrnu@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: NeoMutt/ (1.7.0)

Version: 4.9.0

Version 4.9.0 built successfully on the autobuilders:
  https://buildd.debian.org/status/package.php?p=xfsprogs

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
------------=_1484504105-2219-0--
