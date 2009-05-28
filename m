Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4SExkwU259790 for <xfs@oss.sgi.com>; Thu, 28 May 2009 09:59:46 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7BD702B6208
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 07:59:59 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id 9yAIifuP1aWvtJc4 for <xfs@oss.sgi.com>;
	Thu, 28 May 2009 07:59:59 -0700 (PDT)
Message-ID: <4A1EA6E5.50805@sandeen.net>
Date: Thu, 28 May 2009 09:59:49 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/9] Make libxfs.h optional
References: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>	<1243450413-12681-3-git-send-email-sandeen@sandeen.net>
	<20090528095749.GB651@infradead.org>
In-Reply-To: <20090528095749.GB651@infradead.org>
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
> On Wed, May 27, 2009 at 01:53:26PM -0500, Eric Sandeen wrote:
>> libxfs.h is really only needed for the loggen test;
>> make it config-time optional.
> 
> Maybe we should just move loggen into xfsprogs?

Perhaps, though it has no use outside of qa ... even if we do that it'll
take a while to trickle into people's xfsprogs, so any problem with
putting this patch in for now, even if we move loggen?

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
