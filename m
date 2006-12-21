Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Dec 2006 15:33:29 -0800 (PST)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBLNXNqw026283
	for <xfs@oss.sgi.com>; Thu, 21 Dec 2006 15:33:24 -0800
Subject: Re: Review: Clear unwritten flag on during partial page truncation
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <20061221113724.GK33919298@melbourne.sgi.com>
References: <20061220062813.GU44411608@melbourne.sgi.com>
	 <1166681818.5572.190.camel@edge>
	 <20061221113724.GK33919298@melbourne.sgi.com>
Content-Type: text/plain
Date: Fri, 22 Dec 2006 09:04:58 +1100
Message-Id: <1166738698.5572.194.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com

On Thu, 2006-12-21 at 22:37 +1100, David Chinner wrote:
> > ...
> > the same lines.  But alot of effort, with the possibility of it not
> > being merged at all, as it touches code outside XFS.  D'oh.
> 
> Yep, pretty much my thinking as well.
> 
> I forgot about that hack in xfs_count_page_state() - we should
> be able to remove that with this change, right?
> 

Hmm, yes, quite possibly ... worth testing out anyway, but I think
you may be right there.

cheers.

-- 
Nathan
