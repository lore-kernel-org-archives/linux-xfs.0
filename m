Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8C5807F4E
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 17:39:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2BEF4AC005
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 15:39:38 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	80ZRA8hPxSCFaudj for <xfs@oss.sgi.com>;
	Mon, 18 Feb 2013 15:39:36 -0800 (PST)
Date: Tue, 19 Feb 2013 10:39:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs speculative preallocation -- fragmentation issue with sparse
	file handling?
Message-ID: <20130218233934.GD26694@dastard>
References: <51229835.5090707@redhat.com> <51229C21.4040102@sgi.com>
	<5122B93E.7060702@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5122B93E.7060702@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com, Mark Tinguely <tinguely@sgi.com>, Dave Chinner <dchinner@redhat.com>

On Mon, Feb 18, 2013 at 06:29:02PM -0500, Brian Foster wrote:
> On 02/18/2013 04:24 PM, Mark Tinguely wrote:
> > On 02/18/13 15:08, Brian Foster wrote:
> > ... the patched version increases in doubles
> > 
> > +    if (imap[0].br_startblock == HOLESTARTBLOCK)
> > +        return 0;
> > 
> >     vvvvvv
> > +    if (imap[0].br_blockcount <= (MAXEXTLEN >> 1))
> > +        return imap[0].br_blockcount;
> >     ^^^^^^
> > 
> > +    return XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
> > +}
> > 
> > have you experimented without the middle if statement.
> > If I remember correctly when I reviewed the code, that should be moving
> > code closer to the original code; namely use the file size as the
> > preallocation value.
> > 
> 
> Just a quick update...
> 
> I've tested the change above and a suggestion Dave made on IRC to return
> (imap[0].br_blockcount << 1) and both resolve the immediate issue. I
> need to verify the original test case still works and I'll post a patch.
> Thanks...

Though I think you'll find Mark's suggestion reverts preallocation
on sparse files back to the old, undesirable behaviour as it will
prealloc based on the file size on the second 4k of the write at
EOF....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
