Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7E0tRfu062357 for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 19:55:37 -0500
Received: from mail.jquigley.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B75253CB216
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 17:56:11 -0700 (PDT)
Received: from mail.jquigley.com (main.jquigley.com [67.23.32.156]) by
	cuda.sgi.com with ESMTP id EkDbDBiV5FgDxh9x for
	<xfs@oss.sgi.com>; Thu, 13 Aug 2009 17:56:11 -0700 (PDT)
Received: from [10.1.1.11] (OSH-NAT-213-122.onshore.net [66.146.213.122])
	(Authenticated sender: jquigley@mail.jquigley.com)
	by mail.jquigley.com (Postfix) with ESMTPSA id 05388204116
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2009 00:56:10 +0000 (UTC)
Message-ID: <4A84B629.3080208@jquigley.com>
Date: Thu, 13 Aug 2009 19:56:09 -0500
From: John Quigley <jquigley@jquigley.com>
MIME-Version: 1.0
Subject: Re: XFS corruption with failover
References: <4A8474D2.7050508@jquigley.com>
	<E037F1E5-2CC8-4F6E-92ED-AFE7BE6EBD1B@sgi.com>
In-Reply-To: <E037F1E5-2CC8-4F6E-92ED-AFE7BE6EBD1B@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
Cc: XFS Development <xfs@oss.sgi.com>

Felix Blyakher wrote:
> This is an IO error. Is the block device (/dev/sde) accessible
> from the server #2 OK? Can you dd from that device?

Interesting suggestion; I don't recall having seen any indication of IO errors, but I'm testing again this evening, and will report back on what I find with dd.

> That's not a good time to run xfs_repair. There were no
> indication that the filesystem is corrupted.

Interesting again.  I ran the tool merely because I had no other recourse to remedy this.

> Let's take for a sec "NFS server #2" out of the picture.
> Can you mount the filesystem from the original server
> after it reboots?

This has been tested and fails, so it does appear to be a corruption issue on the stable media.  Based on your first comment, I'm re-running tests to verify that the ISCSI volumes are fully online and ready to accept IO before mounting the file system.

Thank you very much.

- John Quigley

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
