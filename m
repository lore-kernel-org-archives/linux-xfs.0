Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Aug 2008 19:04:35 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7524T7n027619
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 19:04:32 -0700
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A18D935C33C
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2008 19:05:44 -0700 (PDT)
Received: from mx1.suse.de (ns1.suse.de [195.135.220.2]) by cuda.sgi.com with ESMTP id IbKIDGtBoMHrglxv for <xfs@oss.sgi.com>; Mon, 04 Aug 2008 19:05:44 -0700 (PDT)
Date: Tue, 5 Aug 2008 04:05:39 +0200
From: Nick Piggin <npiggin@suse.de>
Subject: Re: [rfc][patch 3/3] xfs: use new vmap API
Message-ID: <20080805020539.GA15075@wotan.suse.de>
References: <20080728123438.GA13926@wotan.suse.de> <20080728123703.GC13926@wotan.suse.de> <4896A197.3090004@sgi.com> <200808042057.20607.nickpiggin@yahoo.com.au> <4897B05A.7040002@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4897B05A.7040002@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Linux Memory Management List <linux-mm@kvack.org>, xfs@oss.sgi.com, xen-devel@lists.xensource.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, dri-devel@lists.sourceforge.net

Assuming patch 1 gets merged upstream, I think Andrew would normally send
off 2 and 3 to the XFS maintainers at that point (ie. when its prerequisites
are upstream) for you to merge. 

On Tue, Aug 05, 2008 at 11:43:54AM +1000, Lachlan McIlroy wrote:
> Okay.  When the time comes will you push the XFS changes to mainline
> or would you like us to?
> 
> Nick Piggin wrote:
> >Thanks for taking a look. I'll send them over to -mm with patch 1,
> >then, for some testing.
> >
> >On Monday 04 August 2008 16:28, Lachlan McIlroy wrote:
> >>Looks good to me.
> >>
> >>Nick Piggin wrote:
> >>>Implement XFS's large buffer support with the new vmap APIs. See the vmap
> >>>rewrite patch for some numbers.
