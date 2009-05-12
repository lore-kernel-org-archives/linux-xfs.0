Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4CBuZZC067991 for <xfs@oss.sgi.com>; Tue, 12 May 2009 06:56:36 -0500
Received: from padma.gslab.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 6DD4327CAFA
	for <xfs@oss.sgi.com>; Tue, 12 May 2009 04:56:41 -0700 (PDT)
Received: from padma.gslab.com (padma.gslab.com [59.163.66.102]) by
	cuda.sgi.com with SMTP id Tj4p5uxZ7dpBwIKM for
	<xfs@oss.sgi.com>; Tue, 12 May 2009 04:56:41 -0700 (PDT)
Received: from [172.20.25.198] (unknown [172.20.25.198])
	(Authenticated sender: milind)
	by padma.gslab.com (Postfix) with ESMTP id 88E2E17701C0
	for <xfs@oss.sgi.com>; Tue, 12 May 2009 17:26:38 +0530 (IST)
Subject: configure issue
From: Milind <milind@gslab.com>
Date: Tue, 12 May 2009 17:20:03 +0530
Message-Id: <1242129003.3608.12.camel@alhena>
Mime-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

I came across this problem when I was doing ./configure of xfsprogs.

I had to install gettext from sources (as xfsprogs needed it) which
resided in my toolchain and while doing configure xfsprogs's configure
couldn't fine msgfmt, msgmerge and xgettext even if I do PATH=<path to
my gettext/bin/>:$PATH.

if I manually set MSGFMT, MSGMERGE to their binary paths this works.

Is this not expected?

When I looked at the sources if I change configure:12316 as follows

- as_dummy="/usr/bin:/usr/local/bin:/usr/freeware/bin"
+ as_dummy="/usr/bin:/usr/local/bin:/usr/freeware/bin:$PATH"

this works for MSGFMT

-Miline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
