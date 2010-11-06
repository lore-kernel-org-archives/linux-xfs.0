Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA6Ht6YG005783 for <xfs@oss.sgi.com>; Sat, 6 Nov 2010 12:55:07 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D935715B4A3
	for <xfs@oss.sgi.com>; Sat,  6 Nov 2010 10:56:32 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id eAgeOqcreXTSsUaO for
	<xfs@oss.sgi.com>; Sat, 06 Nov 2010 10:56:32 -0700 (PDT)
Date: Sat, 6 Nov 2010 13:56:31 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfs: fix a few compiler warnings with
	CONFIG_XFS_QUOTA=n
Message-ID: <20101106175631.GA13315@infradead.org>
References: <20101106114226.GA25395@infradead.org>
	<20101106114256.GC25395@infradead.org>
	<87aalmtk66.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87aalmtk66.fsf@basil.nowhere.org>
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
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sat, Nov 06, 2010 at 06:51:29PM +0100, Andi Kleen wrote:
> Christoph Hellwig <hch@infradead.org> writes:
> 
> > Andi Kleen reported that gcc-4.5 gives lots of warnings for him inside the
> > XFS code.  It turned out most of them are due to the quota stubs beeing
> > macros, and gcc now complaining about macros evaluating to 0 that are not
> > assigned to variables.
> 
> Thanks. BTW I believe this was already fixed in my big warning patchkit
> from some time ago, unfortunately that didn't make it in :-/
> 
> A gcc 4.6 build is also still incredibly noisy.

I'll tacked the dir warnings your reported next, and after that I'll
look into more of the gcc 4.6 warnings. But that's 2.6.38 material,
while this one is simple enough to still sneak it into 2.6.37.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
