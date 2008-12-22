Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMKnwop026376 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 14:50:04 -0600
Date: Mon, 22 Dec 2008 15:49:57 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/20] xfs-cmds staging tree
Message-ID: <20081222204956.GA23453@infradead.org>
References: <20081222163831.755809000@bombadil.infradead.org>
	<494FF9B3.9030103@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <494FF9B3.9030103@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Mark Goodwin <markgw@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Dec 23, 2008 at 07:33:55AM +1100, Mark Goodwin wrote:
>
>
> Christoph Hellwig wrote:
>> This is the staging tree of xfs patches.  Given that Barry is gone now it seem
>> like no one cares about userspace and I'll play patch monkey for now.
>
> Thanks Christoph. Lachlan and I were just discussing yesterday that
> it's time to set up a git repository for xfs-cmds on oss. This would
> contain all the userspace stuff: attr, acl, xfsprogs, dmapi, xfsdump
> and xfstests.
>
> Anyone have a reason not to keep all of this together in the one tree?
> I guess we'd need branches for 'master' (aka dev) and 'stable' or  
> something ..?

Yes, that's a plan.  Can you set it up in a way that we can push
directly to, similar to how Nathan does it for pcp?  Nathan would also
like to push to the xfs-cmds tree for the debian packaging, btw.

One thing we were discussing is if it's really a good idea to have all
these together.  acl and attr aren't really related to XFS, and it might
be a good idea to just have them maintained directly by Andreas.
xfsprogs is I think mostly by terrain these days with Barry gone,
xfstests is something I'd voluntter Eric for as he's been doing good
work on it.  xfsdump still has a maintainer with Bill Kendall, and dmapi
would probably be best left to the DMF group at SGI.  xfsmisc might be
better off as a scripts/ directory inside xfsprogs.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
