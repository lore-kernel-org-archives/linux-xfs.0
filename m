Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2665D7F37
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 03:58:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9FC09AC001
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 01:58:44 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	CpBRTHrLpwyDhuXQ for <xfs@oss.sgi.com>;
	Fri, 24 May 2013 01:58:42 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [patch 0/2] xfs: yet more fixes for 3.10-rc3
Date: Fri, 24 May 2013 18:58:06 +1000
Message-Id: <1369385888-17214-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1369312240-5925-1-git-send-email-david@fromorbit.com>
References: <1369312240-5925-1-git-send-email-david@fromorbit.com>
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
Cc: bpm@sgi.com

The first disabled swap extents for CRC enabled filesystems as it
"corrupts" owner information in the BMBT blocks. The second fixes
the suid/sgid truncate issue that Dave Jones reported. This one is
definitely a stable kernel candidate.

-dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
