Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EDF427F63
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 02:19:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EE4068F8033
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 00:19:39 -0700 (PDT)
Received: from mail-we0-f172.google.com (mail-we0-f172.google.com
	[74.125.82.172]) by cuda.sgi.com with ESMTP id ZDd1c7TfjrX6mfs4
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 14 Jul 2014 00:19:38 -0700 (PDT)
Received: by mail-we0-f172.google.com with SMTP id x48so1864688wes.3
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 00:19:37 -0700 (PDT)
Received: from teal.hq.k1024.org (178-83-234-80.dynamic.hispeed.ch.
	[178.83.234.80]) by mx.google.com with ESMTPSA id
	ed15sm27853512wic.9.2014.07.14.00.19.36 for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
	Mon, 14 Jul 2014 00:19:37 -0700 (PDT)
Date: Mon, 14 Jul 2014 09:19:35 +0200
From: Iustin Pop <iusty@k1024.org>
Subject: xfsrestore -t and default location of housekeeping dir
Message-ID: <20140714071935.GB29541@teal.hq.k1024.org>
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

Hi,

While testing a just-made dump with via 'xfsrestore -t', I learned that
the default housekeepingdir path is still under the original filesystem.
My xfsrestore therefore failed, since that filesystem was read-only.

Since '-t' should denote a pure no-op operation, with no changes, would
it make more sense to default the housekeeping location to a temporary
location if it is used?

thanks,
iustin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
