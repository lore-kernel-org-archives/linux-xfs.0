Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Oct 2008 15:46:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9NMUa9H013781
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 15:30:38 -0700
Date: Thu, 23 Oct 2008 18:32:21 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Fwd: [xfs-masters] [Bug 11813] New: xfs filesystem exported
	via nfs don't work in 2.6.27.3]
Message-ID: <20081023223221.GA32629@infradead.org>
References: <4900F34C.2090205@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4900F34C.2090205@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodwin <markgw@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, francois.valenduc@tvcablenet.be

On Fri, Oct 24, 2008 at 07:57:32AM +1000, Mark Goodwin wrote:
> looks like we better do something urgently to fix this.
> Any suggestions Christoph?

Francois Valenduc wrote on Bugzilla:
> With kernel 2.6.27.3, it's impossible to use a xfs filesystem  exported via
> NFS. I am using gentoo and I share a portage tree mounted on an xfs  
> filesystem
> via NFS. Each time packages are fetched, the emerge process is blocked. It
> seems the problematic commit is the following:
>
> commit c068663ae65e507814545b59a8e2090f48a85613

I can't reproduce this, and intuitively this doesn't make sense.
The symptoms are the ones one would see due to the bug that is fixed by
this commit.
