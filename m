Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 77F997F73
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 12:42:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 58751304062
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 10:42:35 -0700 (PDT)
Received: from Ishtar.hs.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id rmX9GFggvV97bvpn (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Oct 2014 10:42:33 -0700 (PDT)
Received: from [192.168.4.12] (Athenae [192.168.4.12])
	by Ishtar.hs.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id
	s91HfY6x080212 for <xfs@oss.sgi.com>; Wed, 1 Oct 2014 10:41:36 -0700
Message-ID: <542C3CCE.7020508@tlinx.org>
Date: Wed, 01 Oct 2014 10:41:34 -0700
From: L Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: configureQ: is -enable-static & -disable-shared supported?
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Might be something in my (SuSE) gcc/ld setup, but trying to build static 
and disabled shared
doesn't give an error  -- it just builds shared.  Is this expected (i.e. 
static
not really supported?)

tnx

input to config:

unset LDFLAGS
unset CFLAGS
export PKG_USER=root
export PKG_GROUP=root

configure  -disable-shared --disable-gettext --enable-readline 
--enable-termcap --enable-static



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
