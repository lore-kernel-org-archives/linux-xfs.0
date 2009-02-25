Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1PAGDSD199306 for <xfs@oss.sgi.com>; Wed, 25 Feb 2009 04:16:14 -0600
Received: from sovereign.computergmbh.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C5A2D1C07576
	for <xfs@oss.sgi.com>; Wed, 25 Feb 2009 02:15:43 -0800 (PST)
Received: from sovereign.computergmbh.de (sovereign.computergmbh.de
	[85.214.69.204]) by cuda.sgi.com with ESMTP id q5bTpsEyXN2jIHis
	for <xfs@oss.sgi.com>; Wed, 25 Feb 2009 02:15:43 -0800 (PST)
Date: Wed, 25 Feb 2009 11:15:10 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
Subject: xfsdump: specfile: remove Distribution/Packager tag
In-Reply-To: <20090224190731.GA22910@infradead.org>
Message-ID: <alpine.LSU.2.00.0902251114250.20946@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0902111802320.25232@fbirervta.pbzchgretzou.qr>
	<20090215172417.GA20256@infradead.org>
	<alpine.LSU.2.00.0902191625070.20437@fbirervta.pbzchgretzou.qr>
	<20090224190731.GA22910@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tuesday 2009-02-24 20:07, Christoph Hellwig wrote:
>On Thu, Feb 19, 2009 at 04:25:20PM +0100, Jan Engelhardt wrote:
>> On Sunday 2009-02-15 18:24, Christoph Hellwig wrote:
>> 
>> >Thanks, I'll put these in.  Can you submit equivalent patches for
>> >xfsdump and dmapi, too?
>> >
>> xfsdump and dmapi git repositories seem to have no .spec files.
>
>build/rpm/xfsdump.spec.in and build/rpm/dmapi.spec.in


parent b7b66942273709925184998fb08283e279e0366f ()
commit 0ba9509a63079457a356c07017ad0591968c3ae2
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Feb 25 11:13:03 2009 +0100

specfile: remove Distribution/Packager tag

There exist a number of rpm specfile tags that make it possible to
mislead users of the produced RPM package, because its presence
overrides anything that has been specified in ~/.rpmmacros (or the
configuration files of the build system used). Such is especially
annoying when Packager:/Vendor: is put in specfiles, because it is
then almost impossible to get the name/email of the person who
_really_ did the packaging (assuming s/he set it in their
.rpmmacros).

Such similarly applies to the Distribution: tag, which is why I
suggest its removal and let the build systems provide the proper
string instead.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 build/rpm/xfsdump.spec.in |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/build/rpm/xfsdump.spec.in b/build/rpm/xfsdump.spec.in
index 417dd84..59a6bb1 100644
--- a/build/rpm/xfsdump.spec.in
+++ b/build/rpm/xfsdump.spec.in
@@ -2,8 +2,6 @@ Summary: Administrative utilities for the XFS filesystem.
 Name: @pkg_name@
 Version: @pkg_version@
 Release: @pkg_release@
-Distribution: @pkg_distribution@
-Packager: Silicon Graphics, Inc. <http://www.sgi.com/>
 BuildRoot: @build_root@ 
 Requires: xfsprogs >= 3.0.0, attr >= 2.0.0
 Source: @pkg_name@-@pkg_version@.src.tar.gz
-- 
# Created with git-export-patch

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
