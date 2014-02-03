Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 474067F5E
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 21:19:39 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DF7B4AC002
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 19:19:35 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	wAFQ6fSbg0mbfc8V for <xfs@oss.sgi.com>;
	Sun, 02 Feb 2014 19:19:31 -0800 (PST)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1WAA4E-0006BY-Vw
	for xfs@oss.sgi.com; Mon, 03 Feb 2014 14:19:27 +1100
Date: Mon, 3 Feb 2014 14:19:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/5] metadump: discontiguous directory block support
Message-ID: <20140203031926.GP13997@dastard>
References: <1390472635-17225-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1390472635-17225-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

ping?

On Thu, Jan 23, 2014 at 09:23:50PM +1100, Dave Chinner wrote:
> Hi folks,
> 
> In making xfs_repair handle discontiguous directory blocks properly,
> it uncovered the fact that xfs_metadump has never handled
> discontiguous directory blocks properly. It doesn't handle
> discontiguous block format directories, and there are a couple of
> other cases where it is just says "too hard" and gives up, leading
> to un-obfuscated, corrupt or missing directory blocks in the
> metadump image. xfs/291 on CRC enabled filesystems was causing all
> three of these conditions to occur.
> 
> This patchset fixes metadump to fully support all forms of
> discontiguous directory blocks. It changes the obfuscation code from
> reading and extent at a time and trying to slice and dice the
> objects within it - which will never work for objects that need CRC
> recalculation as a result of obfuscation - to dealing with
> individual objects. This does affect IO patterns somewhat - single
> large contiguous IOs turn into multiple smaller sequential IOs - but
> it means that we can use the object verifiers to do CRC
> recalculation correctly.
> 
> It also means we can walk the extent tree to gather discontiguous
> extents into a single buffer to build an object fom multiple IOs.
> This is what all the other directory block IO does, and we need to
> do it here too.
> 
> The result is that the code is simpler and more obvious in what it
> does - the "walk over a large extent" code is generic rather than
> object specific, and the discontiguous block code is separated from
> the single block object code. Hence both cases are clearer and
> easier to understand.
> 
> And it works, unlike the old code.
> 
> FWIW, with this fixed and xfs/291 passing, the only remaining
> outstanding work that is blocking a 3.2.0 release is to trap IO
> verifier errors in repair so we repair/rebuild objects based on CRC
> errors.
> 
> Comments, flames, thoughts all welcome.
> 
> Cheers,
> 
> Dave.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
