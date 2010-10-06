Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o96Ild1W110991 for <xfs@oss.sgi.com>; Wed, 6 Oct 2010 13:47:39 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BECEE304064
	for <xfs@oss.sgi.com>; Wed,  6 Oct 2010 11:48:40 -0700 (PDT)
Subject: [PATCH, RFC 0/6] xfsprogs: fix generate_obfuscate_name()
From: Alex Elder <aelder@sgi.com>
Date: Wed, 06 Oct 2010 13:48:40 -0500
Message-ID: <1286390920.1951.357.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

I'm sending this out for the moment with an "RFC" tag
because I don't consider this work done (I want to do
some refinements, basically).  But I wanted to get the
code out there for an initial review to see if there
are any major problems with what I'm proposing here.

This is fixing the problem in xfs_db metadump feature
in which the attempt to create an obfuscated filename
can result in an endless loop.

I've run it through all possible 6-character names
starting with 0x01 through 0x07 (and counting...)
and the new algorithm (which is basically contained
in patch 3 of the series) produces an alternate
path with the same hash as the original for all
cases.  I also ran all the test cases I identified
previously and all compute an alternate path without
hanging.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
