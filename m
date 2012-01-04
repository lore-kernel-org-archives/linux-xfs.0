Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q04H4uts159707 for <xfs@oss.sgi.com>; Wed, 4 Jan 2012 11:04:56 -0600
Received: from mail.in8.de (brockman.in8.de [85.214.220.56]) by cuda.sgi.com
	with ESMTP id DbeYkEuDU8B8DCKv for <xfs@oss.sgi.com>;
	Wed, 04 Jan 2012 09:04:53 -0800 (PST)
Message-ID: <4F0486B3.8010301@jan-o-sch.net>
Date: Wed, 04 Jan 2012 18:04:51 +0100
From: Jan Schmidt <mail@jan-o-sch.net>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: new check 278 to ensure btrfs backref
	integrity
References: <1324552138-30584-1-git-send-email-list.btrfs@jan-o-sch.net>
	<20120104163946.GA8153@infradead.org>
	<4F0485FE.8000405@sandeen.net>
In-Reply-To: <4F0485FE.8000405@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org, Jan Schmidt <list.btrfs@jan-o-sch.net>, xfs@oss.sgi.com

On 04.01.2012 18:01, Eric Sandeen wrote:
> 276 got merged on Dec 28 before my requests for fixup, I guess?  And it
> explicitly sets FSTYP=btrfs which is why it fails.
> 
> the 278 patch v2 in this thread works ok for me.
> 
> so munging the 278 patch here into the existing 276 should be the
> right approach.

Yeah we figured that out on irc some minutes ago :-)

I'm currently building v2 as an incremental patch to 276 (without rename
to 278) and send it as

   [PATCH] xfstests: fixup check 276

soon.

-Jan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
