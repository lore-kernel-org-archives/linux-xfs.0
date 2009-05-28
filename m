Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4SGF0ru262074 for <xfs@oss.sgi.com>; Thu, 28 May 2009 11:15:00 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EFBB52B7FDF
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 09:15:14 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id fvEZUlQVXOG0TP4k for <xfs@oss.sgi.com>;
	Thu, 28 May 2009 09:15:14 -0700 (PDT)
Message-ID: <4A1EB888.8000800@sandeen.net>
Date: Thu, 28 May 2009 11:15:04 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/9] Make libxfs.h optional
References: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>	<1243450413-12681-3-git-send-email-sandeen@sandeen.net>	<20090528095749.GB651@infradead.org>
	<4A1EA6E5.50805@sandeen.net> <20090528153517.GA15293@infradead.org>
In-Reply-To: <20090528153517.GA15293@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Thu, May 28, 2009 at 09:59:49AM -0500, Eric Sandeen wrote:
>> Christoph Hellwig wrote:
>>> On Wed, May 27, 2009 at 01:53:26PM -0500, Eric Sandeen wrote:
>>>> libxfs.h is really only needed for the loggen test;
>>>> make it config-time optional.
>>> Maybe we should just move loggen into xfsprogs?
>> Perhaps, though it has no use outside of qa ... even if we do that it'll
>> take a while to trickle into people's xfsprogs, so any problem with
>> putting this patch in for now, even if we move loggen?
> 
> I will send a patch to add loggen to xfsprogs ASAP.  After that we can
> remove loggen and thus the requirement for libxfs.h from xfstests
> completely.  The tests that use loggen would ismply check for a
> xfs_loggen binary  in their PATH and not run, so far less drama then
> the current situation.

Ok, sounds fine.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
