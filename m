Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3A4287F37
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 15:10:45 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B9552AC004
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 13:10:44 -0800 (PST)
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65]) by
	cuda.sgi.com with ESMTP id vWbxwNGb6yxQbSzM (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2016 13:10:41 -0800 (PST)
Received: from dovecot03.posteo.de (dovecot03.posteo.de [172.16.0.13])
	by mout01.posteo.de (Postfix) with ESMTPS id 0DD1920970
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 22:10:36 +0100 (CET)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3pg4Lh4sJhz5vND
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 22:10:36 +0100 (CET)
Resent-Message-ID: <20160112210801.GA10044@nyan>
Resent-To: xfs@oss.sgi.com
Message-Id: <cover.1452632647.git.felix.janda@posteo.de>
From: Felix Janda <felix.janda@posteo.de>
Date: Tue, 12 Jan 2016 22:04:07 +0100
Subject: [PATCH 0/6] xfsdump: Compile with musl libc
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Six simple patches fixing compilation on linux systems using the musl
c library.

Felix Janda (6):
  invutil/invidx: include <fcntl.h> for O_CREAT
  dump/content.c: Include <linux/limits.h> for XATTR_LIST_MAX
  common/main.c: Replace nonstandard SIGCLD by SIGCHLD
  librmt/rmtopen: Prefer <signal.h> over <sys/signal.h>
  dump/var.c: Include <limits.h> for PATH_MAX
  Prefer stdint types over __uint*_t and __int*_t

 common/content_inode.h | 4 ++--
 common/hsmapi.c        | 2 +-
 common/main.c          | 2 +-
 doc/xfsdump.html       | 8 ++++----
 dump/content.c         | 1 +
 dump/var.c             | 1 +
 inventory/inv_oref.h   | 2 +-
 inventory/inv_priv.h   | 4 ++--
 inventory/inventory.h  | 2 +-
 invutil/invidx.c       | 1 +
 librmt/rmtopen.c       | 2 +-
 11 files changed, 16 insertions(+), 13 deletions(-)

-- 
2.4.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
