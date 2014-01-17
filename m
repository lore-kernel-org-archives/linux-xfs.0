Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4ACB07F52
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 14:22:41 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D4FE9AC002
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 12:22:37 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id QN9tpjFWThqsV4XP for <xfs@oss.sgi.com>;
	Fri, 17 Jan 2014 12:22:36 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 69A7163BEBCB
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 14:22:36 -0600 (CST)
Message-ID: <52D9910C.9000205@sandeen.net>
Date: Fri, 17 Jan 2014 14:22:36 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 0/3 V2] xfs: allow logical-sector sized O_DIRECT for any fs
	sector size
References: <52D6CC91.6000408@redhat.com>
In-Reply-To: <52D6CC91.6000408@redhat.com>
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

Resend of the previous patch, now in 3 parts, incorporating some
of Dave's suggestions, and split up for SUPER-easy review.  ;)

I have explicitly not changed XFS_IOC_DIOINFO output for now; it
still reports the actual minimum sizes and alignments which will
be allowed by the filesystem (and block layer beneath it).

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
