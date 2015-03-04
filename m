Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3A0227F47
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 20:08:35 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 28E7B304048
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 18:08:32 -0800 (PST)
Received: from fieldses.org (fieldses.org [173.255.197.46]) by cuda.sgi.com
	with ESMTP id kv2cw8XwiHbXDHBL for <xfs@oss.sgi.com>;
	Tue, 03 Mar 2015 18:08:27 -0800 (PST)
Date: Tue, 3 Mar 2015 21:08:26 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: panic on 4.20 server exporting xfs filesystem
Message-ID: <20150304020826.GD19439@fieldses.org>
References: <20150303221033.GB19439@fieldses.org>
	<20150303224456.GV4251@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150303224456.GV4251@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-nfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, Mar 04, 2015 at 09:44:56AM +1100, Dave Chinner wrote:
> On Tue, Mar 03, 2015 at 05:10:33PM -0500, J. Bruce Fields wrote:
> > I'm getting mysterious crashes on a server exporting an xfs filesystem.
> > 
> > Strangely, I've reproduced this on
> > 
> > 	93aaa830fc17 "Merge tag 'xfs-pnfs-for-linus-3.20-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs
> > 
> > but haven't yet managed to reproduce on either of its parents
> > (24a52e412ef2 or 781355c6e5ae).  That might just be chance, I'll try
> > again.
> 
> I think you'll find that the bug is only triggered after that XFS
> merge because it's what enabled block layout support in the server,
> i.e.  nfsd4_setup_layout_type() is now setting the export type to
> LAYOUT_BLOCK_VOLUME because XFS has added the necessary functions to
> it's export ops.

Doh--after all the discussion I didn't actually pay attention to what
happened in the end.  OK, I see, you're right, it's all more-or-less
dead code till that merge.

Christoph's code was passing all my tests before that, so maybe we
broke something in the merge process.

Alternatively, it could be because I've added more tests--I'll rerun my
current tests on his original branch....

> > I can also try a serial console or something, but for now I'm not
> > getting a lot of information about the crashes.
> 
> Really need a stack trace - even a photo of the screen with the
> stack trace on it will do for starters. ;)

Yeah, I'll let you know when I have something.

By the way, Christoph, an unrelated question: how are the devices found,
and what are the chances of a client writing to the wrong block device?

(E.g., if they're addressed based on a uuid that doesn't change on
cloning the block device, and if the client had access to another device
with an identical copy of the filesystem, could it end up writing to
that instead?)

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
