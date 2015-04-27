Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 588117F51
	for <xfs@oss.sgi.com>; Mon, 27 Apr 2015 17:10:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E971BAC001
	for <xfs@oss.sgi.com>; Mon, 27 Apr 2015 15:10:28 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id EZaPsHkMPJfIFhch for <xfs@oss.sgi.com>;
	Mon, 27 Apr 2015 15:10:26 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 5A8A960EB562
	for <xfs@oss.sgi.com>; Mon, 27 Apr 2015 17:10:26 -0500 (CDT)
Message-ID: <553EB3D1.10602@sandeen.net>
Date: Mon, 27 Apr 2015 17:10:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Proposal/RFC: new metadata-specific UUID for V5 supers
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

Wanted to float this & see what people think...

Today, it's impossible (FSVO impossible) to change a V5 filesystem's
UUID, because that UUID is stamped into every bit of metadata.  If
not impossible, it's unimplemented and any implementation would be
terribly inefficient.

With 20/20 hindsight, an sb_meta_uuid field, separate from the sb_uuid
field that is userspace-visible, would have avoided this problem.

We can certainly add it, but it'd need to be an incompat change, because
old kernels would see this as catastrophic mismatching of every bit
of metadata on a V5 superblock filesystem.

Other than that little problem (o_O) it'd be trivial to implement.

Thoughts?

Thanks,
-Eric

p.s. Thanks to Zach for making me think about this, but I'm not
blaming him for my decision to propose it.  ;)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
