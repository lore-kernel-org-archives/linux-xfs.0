Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 25 Jun 2008 06:56:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5PDuJMo030752
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 06:56:20 -0700
Date: Wed, 25 Jun 2008 09:57:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: TAKE 976035 - streamline init/exit path
Message-ID: <20080625135719.GA30735@infradead.org>
References: <20080625030057.973173A5D1@itchy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080625030057.973173A5D1@itchy>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 25, 2008 at 01:00:57PM +1000, Niv Sardi wrote:
> streamline init/exit path
> 
> Currently the xfs module init/exit code is a mess.  It's farmed out
> over a lot of function with very little error checking.  This patch
> makes sure we propagate all initialization failures properly and clean
> up after them.  Various runtime initializations are replaced with
> compile-time initializations where possible to make this easier.  The
> exit path is similarly consolidated.

Umm, this has been in for a long time.  Did the mail leave your mail
queue only now? :)
