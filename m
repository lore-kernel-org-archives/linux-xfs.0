Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Oct 2007 23:07:40 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9G67XbG026920
	for <xfs@oss.sgi.com>; Mon, 15 Oct 2007 23:07:35 -0700
Date: Tue, 16 Oct 2007 16:07:26 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: Fix dbflush panic in xfs_qm_sync
Message-ID: <20071016060726.GR995458@sgi.com>
References: <4713F7D3.2090201@sgi.com> <4714498A.8090902@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4714498A.8090902@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Donald Douwsma <donaldd@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Oct 16, 2007 at 03:18:02PM +1000, Lachlan McIlroy wrote:
> Could mp->m_quotainfo become NULL after this check but before we
> lock the list with xfs_qm_mplist_lock()?  There doesn't seem to
> be any locking to protect changes to this field?

Possible - in theory. Likely - no. We do the same unlocked check in a
few places...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
