Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 14:25:32 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97LPTRn028758
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 14:25:29 -0700
Date: Tue, 7 Oct 2008 23:27:07 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] kill xfs_ialloc_log_di
Message-ID: <20081007212707.GA19580@lst.de>
References: <20081007202157.GB16485@lst.de> <48EBE1B1.3090605@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EBE1B1.3090605@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodwin <markgw@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, Oct 08, 2008 at 08:24:49AM +1000, Mark Goodwin wrote:
> 
> Can we verify dirty log replay immediately after a kernel update works?
> (has there been any log fmt revision or is this just pure cleanup?)

This one is purely cleanup, but I also verified the log replay.  The
changes Dave has in the pipe will change the log format.
