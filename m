Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 May 2008 06:21:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4MDLGAD003007
	for <xfs@oss.sgi.com>; Thu, 22 May 2008 06:21:17 -0700
Date: Thu, 22 May 2008 09:22:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] xfsqa 078 - use rmdir to remove directories
Message-ID: <20080522132205.GA4972@infradead.org>
References: <20080522061120.GP173056135@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522061120.GP173056135@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, May 22, 2008 at 04:11:20PM +1000, David Chinner wrote:
> 
> If test 078 fails and you try to run it again immediately, it
> will execute a 'rm -f' on a directory which will fail. This should
> be a rmdir....

Looks good.  rm -rf woul also do it, although slightly more dangerous :)
