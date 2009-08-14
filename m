Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7E0qDuF062152 for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 19:52:23 -0500
Received: from mail.jquigley.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED4033CB11A
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 17:52:57 -0700 (PDT)
Received: from mail.jquigley.com (main.jquigley.com [67.23.32.156]) by
	cuda.sgi.com with ESMTP id wpFtCDGCaka1sb3e for
	<xfs@oss.sgi.com>; Thu, 13 Aug 2009 17:52:57 -0700 (PDT)
Received: from [10.1.1.11] (OSH-NAT-213-122.onshore.net [66.146.213.122])
	(Authenticated sender: jquigley@mail.jquigley.com)
	by mail.jquigley.com (Postfix) with ESMTPSA id 8EBCB204116
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2009 00:52:27 +0000 (UTC)
Message-ID: <4A84B54A.8040807@jquigley.com>
Date: Thu, 13 Aug 2009 19:52:26 -0500
From: John Quigley <jquigley@jquigley.com>
MIME-Version: 1.0
Subject: Re: XFS corruption with failover
References: <4A8474D2.7050508@jquigley.com>	<20090813231739.5c7db91d@galadriel.home>
	<D052E217-FED0-4954-9095-078D0D8AF322@sgi.com>
In-Reply-To: <D052E217-FED0-4954-9095-078D0D8AF322@sgi.com>
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
> I don't think it's pushing too much. XFS was designed to
> survive such events.

And that was my understanding, based on all I've read about the design and intended usage.  XFS has been remarkably resilient in the face of various poor operating conditions, and this is the only environment under which failure has been observed.  It's for this reason that I assumed it's something we're doing wrong, and not an inherent issue with the file system.

- John Quigley

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
