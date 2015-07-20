Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6F5407F5A
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 08:57:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 091F9AC005
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 06:57:48 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id uk7qDhBCnXzlyYdT (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 20 Jul 2015 06:57:47 -0700 (PDT)
Received: from zmail22.collab.prod.int.phx2.redhat.com
	(zmail22.collab.prod.int.phx2.redhat.com [10.5.83.26])
	by mx3-phx2.redhat.com (8.13.8/8.13.8) with ESMTP id t6KDvkYI020661
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 09:57:46 -0400
Date: Mon, 20 Jul 2015 09:57:46 -0400 (EDT)
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <1213913978.543970.1437400666553.JavaMail.zimbra@redhat.com>
In-Reply-To: <2035333009.511763.1437398166766.JavaMail.zimbra@redhat.com>
Subject: xfsprogs: useless code blocks
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
To: xfs-oss <xfs@oss.sgi.com>

Hi all,

I found these useless bits of code in xfsprogs:

repair/incore_ino.c:575-576: 
if (ino_rec->ino_startnum == 0)
  ino_rec = ino_rec;

This one is pretty clear. It is there since 2001 (commit 2bd0ea187 
by nathans@sgi.com, who didn't wrote here since 2006, so I find 
CC-ing him useless). It looks like a forgotten code which doesn't 
do anything, but I ask in case it is a hidden bug.

And:

db/check.c:3035, 3037: Always true expression, as be32_to_cpu() 
translates to __u32 type and unsigned can't be less than zero.

be32_to_cpu(free->hdr.nvalid) < 0 ||

Is there any reason for these tests? I get different type sizes, or
endians as platform dependent, but signed/unsigned? Or it is
a big/little endian conversion hack?

Cheers,
Jan

-- 
Jan Tulak
jtulak@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
