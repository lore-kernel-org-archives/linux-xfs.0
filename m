Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 17FCF7F4E
	for <xfs@oss.sgi.com>; Mon, 23 Mar 2015 00:37:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 02F1D304039
	for <xfs@oss.sgi.com>; Sun, 22 Mar 2015 22:37:20 -0700 (PDT)
Received: from mail-qc0-f178.google.com (mail-qc0-f178.google.com
	[209.85.216.178]) by cuda.sgi.com with ESMTP id
	aH7u7nL96OvLTBtm (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 22 Mar 2015 22:37:18 -0700 (PDT)
Received: by qcbkw5 with SMTP id kw5so137239767qcb.2
	for <xfs@oss.sgi.com>; Sun, 22 Mar 2015 22:37:17 -0700 (PDT)
Date: Mon, 23 Mar 2015 01:37:15 -0400
From: Taesoo Kim <taesoo@gatech.edu>
Subject: Re: [PATCH] xfs: use GFP_NOFS argument in radix_tree_preload
Message-ID: <20150323053715.GK5170@taesoo.org>
References: <1427087183-20391-1-git-send-email-sanidhya.gatech@gmail.com>
	<20150323052449.GO28621@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150323052449.GO28621@dastard>
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
Cc: sanidhya@gatech.edu, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, blee@gatech.edu, Sanidhya Kashyap <sanidhya.gatech@gmail.com>, csong84@gatech.edu, changwoo@gatech.edu

Hi Dave,

Thank you for letting us know. Since we are not an expert of XFS (nor
want to be), we really want to let you guys know it's potential bug
that you might miss (we are helping you!). And that's why Sanidhya
asked (rather than sending a patch) at the first place.

I agree that the comment is misleading and not correct, but probably
encouraging a student who spend times to clean up your mistake
might be better way to influence him rather than shouting :)

Taesoo

On 03/23/15 at 04:24pm, Dave Chinner wrote:
> On Mon, Mar 23, 2015 at 01:06:23AM -0400, Sanidhya Kashyap wrote:
> > From: Byoungyoung Lee <blee@gatech.edu>
> > 
> > Following the convention of other file systems, GFP_NOFS
> > should be used as an argument for radix_tree_preload() instead
> > of GFP_KERNEL.
> 
> "convention of other filesystems" is not a reason for changing from
> GFP_KERNEL to GFP_NOFS. There are rules for when GFP_NOFS needs to
> be used, and so we only need to change the code if one of those
> rules are triggered. i.e. inside a transaction, holding a lock that
> memory reclaim might require to make progress (e.g. ip->i_ilock,
> buffer locks, etc). The context in which the allocation is made will
> tell you whether GFP_KERNEL is safe or not.
> 
> So while the change probably needs to be made, it needs to be made
> for the right reasons. I haven't looked at the code, but I have
> a pretty good idea of the context the allocation is being made
> under. I'd suggest documenting the call path down to
> xfs_mru_cache_insert(), because that will tell you exactly what
> context the allocaiton is being made in and hence tell everyone else
> the real reason we need to make this change...
> 
> Call me picky, pendantic and/or annoying, but if you are looking at
> validating/correcting allocation flags then you need to understand
> the rules and context in which the allocation is being made...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
