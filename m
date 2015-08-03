Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6F2B429DF6
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 15:10:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5CF82304053
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 13:10:04 -0700 (PDT)
Received: from mail-wi0-f179.google.com (mail-wi0-f179.google.com
	[209.85.212.179]) by cuda.sgi.com with ESMTP id
	FfhyWrDmTf0YGVqh (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 13:10:01 -0700 (PDT)
Received: by wibud3 with SMTP id ud3so150089764wib.1
	for <xfs@oss.sgi.com>; Mon, 03 Aug 2015 13:10:00 -0700 (PDT)
Received: from teal.hq.k1024.org (178-83-234-80.dynamic.hispeed.ch.
	[178.83.234.80]) by smtp.gmail.com with ESMTPSA id
	gj6sm15161541wib.22.2015.08.03.13.09.59 for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
	Mon, 03 Aug 2015 13:09:59 -0700 (PDT)
Date: Mon, 3 Aug 2015 22:09:58 +0200
From: Iustin Pop <iustin@k1024.org>
Subject: Question about ftype
Message-ID: <20150803200958.GA14819@teal.hq.k1024.org>
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

Hi all,

I recently saw that a newly created filesystem has ftype=1. Reading the
man pages of mkfs.xfs and xfs_admin/xfs_db and not finding anything
about changing ftype (xfsprogs 3.2.4) leads me to believe that this
feature can only be set at mkfs time, but could someone confirm if it is
indeed so?

thanks,
iustin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
