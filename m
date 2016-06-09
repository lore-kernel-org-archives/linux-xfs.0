Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 13D9D7CA4
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 11:36:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 910F9AC001
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 09:36:24 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Q6pr2YTdVKfzUEPD for <xfs@oss.sgi.com>;
	Thu, 09 Jun 2016 09:36:22 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 887814A6
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 11:36:22 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 0/4] xfs: online relabeling [RFC]
Message-ID: <c1922d3d-208c-3699-0a36-26108a4f44de@sandeen.net>
Date: Thu, 9 Jun 2016 11:36:21 -0500
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
To: xfs-oss <xfs@oss.sgi.com>

Ok, this more or less works; not really up to snuff
for submission or merging, just sketching it out, but some
questions first:

1) Is there really any point to this? :) We did have one
   request, and btrfs can do it ...

2) Is using m_growlock horrible?  growfs is the only other
   thing that writes all supers, so I grabbed it.  We don't
   want multiple relabels stepping on each other.

3) Is there some way to actually force the primary to disk?
   Right now the label change isn't actually visible on the
   primary until unmount, which defeats the purpose.  I'm not
   sure if there's a straightforward/safe way to make it
   visible...

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
