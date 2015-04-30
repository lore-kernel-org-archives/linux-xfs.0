Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AFB057F37
	for <xfs@oss.sgi.com>; Thu, 30 Apr 2015 00:07:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7F87A304032
	for <xfs@oss.sgi.com>; Wed, 29 Apr 2015 22:07:07 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 1bVM7LeUDFOTFChV for <xfs@oss.sgi.com>;
	Wed, 29 Apr 2015 22:07:05 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 6ECF8658ADAC
	for <xfs@oss.sgi.com>; Thu, 30 Apr 2015 00:07:05 -0500 (CDT)
Message-ID: <5541B878.7050502@sandeen.net>
Date: Thu, 30 Apr 2015 00:07:04 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH RFC 1/2] xfs: add sb_meta_uuid field to superblock
References: <553EB3D1.10602@sandeen.net> <5541B47A.2070906@sandeen.net>
In-Reply-To: <5541B47A.2070906@sandeen.net>
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

hohum, having done all that, it now occurs to me that perhaps
a simpler approach would be to add an sb_user_uuid in this same slot.

We could then set that to anything we want, with no other code changes,
and "all" we'd need is a blkid update to look there to see if it's set,
and some minor work in xfs_db to allow us to set it.  o_O

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
