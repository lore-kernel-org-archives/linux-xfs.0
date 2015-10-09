Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6F5417F84
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 14:48:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 54D30304039
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 12:48:42 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id zsbH4Kt4JGDF5ELm for <xfs@oss.sgi.com>;
	Fri, 09 Oct 2015 12:48:40 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 8EA8763C77A5
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 14:48:40 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 0/5 V2] fix (mostly) minor nits spotted by gcc sanitization
Message-ID: <56181A17.9080503@sandeen.net>
Date: Fri, 9 Oct 2015 14:48:39 -0500
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

newer gcc supports -fsanitize=undefined, which spits out
errors when the code does something ... undefined.

These are a handful of the (IMHO) obvious and unobtrusive
fixes that knock down the noise.

One more patch than last time, found a couple things in
metadump as well.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
