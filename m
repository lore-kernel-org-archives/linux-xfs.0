Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4CAgur6063093 for <xfs@oss.sgi.com>; Tue, 12 May 2009 05:42:57 -0500
Received: from pandora.asterdata.local (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 353B41D28082
	for <xfs@oss.sgi.com>; Tue, 12 May 2009 03:43:02 -0700 (PDT)
Received: from pandora.asterdata.local (71-6-94-85.static-ip.telepacific.net
	[71.6.94.85]) by cuda.sgi.com with ESMTP id GxGJuUBIw1cWWCYn
	for <xfs@oss.sgi.com>; Tue, 12 May 2009 03:43:02 -0700 (PDT)
Subject: configure issue.
From: Milind Dumbare <mdumbare@asterdata.com>
Date: Tue, 12 May 2009 16:12:55 +0530
Message-ID: <1242124975.3608.11.camel@alhena>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

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
