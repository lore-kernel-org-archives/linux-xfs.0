Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E4DFC7CA4
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2016 05:51:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B4DAF304048
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2016 03:51:28 -0700 (PDT)
Received: from mail1.g1.pair.com (mail1.g1.pair.com [66.39.3.162]) by
	cuda.sgi.com with ESMTP id lA8NsAP5BfRUE0Ml (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 07 Jun 2016 03:51:26 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by mail1.g1.pair.com (Postfix) with SMTP id 80728547ADC
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2016 06:51:25 -0400 (EDT)
Received: from harpe.intellique.com (labo.djinux.com [82.225.196.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail1.g1.pair.com (Postfix) with ESMTPSA id 28A05547B78
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2016 06:51:25 -0400 (EDT)
Date: Tue, 7 Jun 2016 12:51:27 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: determining superblock version?
Message-ID: <20160607125127.6dd23aef@harpe.intellique.com>
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
To: xfs@oss.sgi.com

Hi all,

as you know kernel prior to 3.16 won't support properly v5 superblocks.
xfsprogs v 3.2.4 and higher defaults to v5 superblocks. This bit quite
a lot of people a year ago or so, when some distributions shipped 3.2.4
xfsprogs with older kernels.

Anyway, I was surprised to find no easy way to find out the superblock
version of an xfs FS. The best I've come across is

xfs_db /dev/this
sb
p

<snip>
versionnum = 0xb4a5
</snip>

So I suppose that the 5 in the end means that the superblock is v5? Can
anyone confirm please? The man page still pretends that the last number
should be 1 to 4, which is confusing.

Oh by the way I think the trick to create a v4 filesystem with mkfs.xfs
higher than 3.2.4 ( mkfs.xfs -m crc=0,finobt=0 /dev/this ) should be in
the FAQ, with a line like this:

Mounting the filesystem fails, and output from dmesg says "Version 5
superblock detected." What should I do?

v5 superblocks require a kernel v3.16 of higher. If you need your
xfs filesystem to be usable with older kernel, use the following
options to mkfs.xfs :

mkfs.xfs -m crc=0,finobt=0 /dev/this

-- 
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
