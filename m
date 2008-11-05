Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 04 Nov 2008 23:33:48 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA57XRn3013562
	for <xfs@oss.sgi.com>; Tue, 4 Nov 2008 23:33:28 -0800
Date: Wed, 5 Nov 2008 02:33:28 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] XFS update for 2.6.28
Message-ID: <20081105073328.GA16726@infradead.org>
References: <20081031045737.ECE0E58AE1E9@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031045737.ECE0E58AE1E9@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs@oss.sgi.com, akpm@linux-foundation.org

Now that the pull request was to late can we at least cherry pick some
fixes?

That'd be at least:

>       [XFS] Account for allocated blocks when expanding

>       [XFS] Fix use-after-free with log and quotas
>       [XFS] Unlock inode before calling xfs_idestroy()
>       [XFS] Wait for all I/O on truncate to zero file size

and we probably want the log allocation failure handling patch from Dave
that's not in yet, as it is on the regression list.
