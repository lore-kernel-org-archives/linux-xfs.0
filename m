Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q63DVMG7094225 for <xfs@oss.sgi.com>; Tue, 3 Jul 2012 08:31:22 -0500
Received: from mail-ee0-f53.google.com (mail-ee0-f53.google.com
	[74.125.83.53]) by cuda.sgi.com with ESMTP id Rh2tF0OTfucV2JZX
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 Jul 2012 06:31:20 -0700 (PDT)
Received: by eekc41 with SMTP id c41so2979252eek.26
	for <xfs@oss.sgi.com>; Tue, 03 Jul 2012 06:31:19 -0700 (PDT)
Message-ID: <4FF2F41F.5000504@gmail.com>
Date: Tue, 03 Jul 2012 14:31:11 +0100
From: Kerin Millar <kerframil@gmail.com>
MIME-Version: 1.0
Subject: Backporting the concurrent direct IO write fix to 3.4
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

I recently became aware of commit 507630b2 (use shared ilock mode for
direct IO writes by default). I understand that this fixes a regression
which can have a notable impact upon MySQL performance. This is of
considerable interest to myself because my MySQL servers have to contend
with a really tough workload.

The patch applies cleanly to 3.4 stable but is it actually safe to use
it there? Or does it depend on other changes to XFS, such that I'd be
better off holding out for 3.5? Any advice would be greatly appreciated.

Cheers,

--Kerin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
