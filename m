Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q12BqGlk048738 for <xfs@oss.sgi.com>; Thu, 2 Feb 2012 05:52:17 -0600
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id TNTamYrOekhngOOv for
	<xfs@oss.sgi.com>; Thu, 02 Feb 2012 03:52:15 -0800 (PST)
Received: from smtp.pobox.com (unknown [127.0.0.1])
	by b-sasl-quonix.pobox.com (Postfix) with ESMTP id C99185E6B
	for <xfs@oss.sgi.com>; Thu,  2 Feb 2012 06:52:14 -0500 (EST)
Received: from b-pb-sasl-quonix.pobox.com (unknown [127.0.0.1])
	by b-sasl-quonix.pobox.com (Postfix) with ESMTP id C144B5E6A
	for <xfs@oss.sgi.com>; Thu,  2 Feb 2012 06:52:14 -0500 (EST)
Received: from Brians-MacBook-Air.local (unknown [46.208.162.148]) (using
	TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits)) (No client
	certificate
	requested) by b-sasl-quonix.pobox.com (Postfix) with ESMTPSA id
	715BD5E65 for
	<xfs@oss.sgi.com>; Thu,  2 Feb 2012 06:52:14 -0500 (EST)
Received: from brian by Brians-MacBook-Air.local with local (Exim 4.77)
	(envelope-from <b.candler@pobox.com>) id LYRKYZ-0000ZA-A4 for
	xfs@oss.sgi.com; Thu, 02 Feb 2012 11:52:11 +0000
Date: Thu, 2 Feb 2012 11:52:11 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: Trailing garbage in event tracing output
Message-ID: <20120202115211.GA1259@nsrc.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Just a minor issue, but when I did some XFS tracing using the instructions
at http://lwn.net/Articles/341899/ I found that there was trailing garbage
in the filenames logged in xfs_lookup.  Example:

...
        bonnie++-26179 [000] 322388.834204: xfs_iunlock: dev 8:32 ino 0xfe1e6 flags ILOCK_SHARED caller xfs_free_eofblocks
        bonnie++-26179 [000] 322388.834212: xfs_lookup: dev 8:32 dp ino 0xfb50d name 000000295aSl688>v??*N
        bonnie++-26179 [000] 322388.834213: xfs_ilock: dev 8:32 ino 0xfb50d flags ILOCK_SHARED caller xfs_ilock_map_shared
...

(where I think the real filename was "000000295aSl688"). I would guess the
logger is expecting null-terminated strings but they aren't.

This is with the stock kernel from Ubuntu 11.10 server x86_64:
Linux storage1 3.0.0-15-server #26-Ubuntu SMP Fri Jan 20 19:07:39 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

Regards,

Brian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
