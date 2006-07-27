Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 27 Jul 2006 16:22:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6RNLPDW010623
	for <xfs@oss.sgi.com>; Thu, 27 Jul 2006 16:21:36 -0700
Date: Fri, 28 Jul 2006 09:20:36 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: [PATCH] [xfs] Add lock annotations to xfs_trans_update_ail and xfs_trans_delete_ail
Message-ID: <20060728092035.C2196410@wobbly.melbourne.sgi.com>
References: <1153938323.12517.58.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1153938323.12517.58.camel@josh-work.beaverton.ibm.com>; from josht@us.ibm.com on Wed, Jul 26, 2006 at 11:25:23AM -0700
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josh Triplett <josht@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>, xfs@oss.sgi.com

On Wed, Jul 26, 2006 at 11:25:23AM -0700, Josh Triplett wrote:
> xfs_trans_update_ail and xfs_trans_delete_ail get called with the AIL lock
> held, and release it.  Add lock annotations to these two functions (abstracted
> like the AIL lock itself) so that sparse can check callers for lock pairing,
> and so that sparse will not complain about these functions since they
> intentionally use locks in this manner.

Thanks Josh, looks good - I'll get it merged.  I'd prefer to just
open code the use of __acquires/__releases for clarity, but I can
easily make that change before merging.

cheers.

-- 
Nathan
