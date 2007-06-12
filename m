Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Jun 2007 18:45:03 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5C1iwWt030529
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2007 18:45:00 -0700
Date: Tue, 12 Jun 2007 11:44:52 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: xfs_fsr allocation group optimization
Message-ID: <20070612014452.GK86004887@sgi.com>
References: <1181544692.19145.44.camel@gentoo-johan.transmode.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181544692.19145.44.camel@gentoo-johan.transmode.se>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Johan Andersson <johan@e-626.net>
Cc: xfs@oss.sgi.com

On Mon, Jun 11, 2007 at 08:51:32AM +0200, Johan Andersson wrote:
> Does anyone know of a good way to find one filename that points o a
> certain inode?

We need an rmap....

We have some prototype linux code that does parent pointers (i.e.
each inode has a back pointer to it's parent inode), but that, IIUC,
is a long way from prime-time. Tim?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
