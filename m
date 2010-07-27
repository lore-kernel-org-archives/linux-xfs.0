Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6R8D0bC173962 for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 03:13:01 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8344A475524
	for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 01:16:04 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id ok6WunnRh2QfcrkS for <xfs@oss.sgi.com>;
	Tue, 27 Jul 2010 01:16:04 -0700 (PDT)
Date: Tue, 27 Jul 2010 10:15:38 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/8] Add test of quota accounting using fsx
Message-ID: <20100727081538.GB3358@quack.suse.cz>
References: <1274710459-11446-1-git-send-email-jack@suse.cz>
	<1274710459-11446-5-git-send-email-jack@suse.cz>
	<4C0FD43D.3040803@sandeen.net>
	<20100615095505.GB3347@quack.suse.cz>
	<4C4E0229.5040002@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C4E0229.5040002@sandeen.net>
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
Cc: hch@infradead.org, ext4 development <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Mon 26-07-10 16:46:17, Eric Sandeen wrote:
> On 06/15/2010 04:55 AM, Jan Kara wrote:
> > On Wed 09-06-10 12:49:49, Eric Sandeen wrote:
> >> Jan Kara wrote:
> >>> Run fsx (and also several fsx threads in parallel) and verify that
> >>> quota accounting is correct after they finish.
> >>
> >> Jan, I'm having trouble with this one on XFS for some reason, with our 
> >> RHEL6 kernel and quota-3.17...
> >   OK, attached is an improvement to the XFSQA tests after which all quota
> > tests pass for XFS just fine.
> >   The second patch is just minor general improvement of _require_scratch
> > macro.
> >   Could they be added to XFSQA repository? Thanks.
> 
> Jan, I've got some ext4 failures reported on these, although I can't hit
> them, so not quite sure what's going on.
> 
> In 231:
> 
> +< fsgqa     --     760       0       0              3     0     0
> +---
> +> fsgqa     --     764       0       0              3     0     0
> +14c14
> +< fsgqa     --     760       0       0              3     0     0
> +---
> +> fsgqa     --     764       0       0              3     0     0
> 
> after the quotacheck & repquota we have 4 more blocks.  Maybe this
> is due to my accounting of metadata blocks at write time, and not
> before ... would it be reasonable to put a sync call as the first
> line of check_usage() ?
  Just last week a change went into xfstests which introduces a generic
quota checking function and uses sync before getting quota usage. I think
xfstests passed for me with ext4 after this change but I've now restarted
the tests to recheck it.
  
> Also in 233:
> 
> +< #501      --   15392       0       0            998     0     0
> +< #501      --   15392   32000   32000            998  1000  1000
> +---
> +> #501      +-   32084   32000   32000  7days     998  1000  1000
> +> #501      --   32084       0       0            998     0     0
> 
> "7days" magically appeared after the quotacheck.  Not sure what's going
> on there...
  That's because the usage after checking exceeded block soft limit and
thus grace time has been set. So it's the same problem as in the above
test.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
