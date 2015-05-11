Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 20DD929DFB
	for <xfs@oss.sgi.com>; Mon, 11 May 2015 09:50:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 12E24304048
	for <xfs@oss.sgi.com>; Mon, 11 May 2015 07:50:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id SADh6UmDcCiffPVL for <xfs@oss.sgi.com>;
	Mon, 11 May 2015 07:50:10 -0700 (PDT)
Message-ID: <5550C1A1.20000@sandeen.net>
Date: Mon, 11 May 2015 09:50:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [ANNOUNCE, DISCUSS] xfsprogs: libxfs-4.1-update branch created
References: <20150511000508.GD16689@dastard>
	<20150511123917.GA43723@bfoster.bfoster>
In-Reply-To: <20150511123917.GA43723@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 5/11/15 7:39 AM, Brian Foster wrote:

...

> What's the proposition with regard to submission/review process? I don't
> think we necessarily need the userspace bits until there is some review
> feedback on the kernel bits because that just increases development and
> review overhead (though nothing precludes posting both, of course). Also
> (and I think we discussed this briefly at LSF), I assume it is
> reasonable to condense a kernel patch series to a single userspace "sync
> XYZ feature to xfsprogs" patch for the bits that port directly over,
> since we have the kernel git log for finer grained history..? Case in
> point: I could squash the sparse inode kernel patches into a single
> xfsprogs patch. The functional xfsprogs bits on top of that (e.g., mkfs,
> repair, etc.) would of course remain as independent patches that require
> indepenent review.

I'd prefer fine-grained, myself; that way, going forward, we can have a
more or less 1:1 commit history.  With libxfs in userspace up to date,
it should be pretty easy, if not even scriptable, and I think the minimal
extra time needed to keep the fine-grained history around would be useful.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
