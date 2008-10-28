Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 19:53:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9S2rK3a002326
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 19:53:22 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C32881495763
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 19:53:18 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id jVqXXaxVC71P99oj for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 19:53:18 -0700 (PDT)
Date: Tue, 28 Oct 2008 13:53:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] kill sys_cred
Message-ID: <20081028025315.GN4985@disturbed>
References: <20081027133635.GB761@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027133635.GB761@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Oct 27, 2008 at 09:36:35AM -0400, Christoph Hellwig wrote:
> capable_cred has been unused for a while so we can kill it and sys_cred.
> That also means the cred argument to xfs_setattr and
> xfs_change_file_space can be removed now.
> 
> (First sent on Semptember 29th)
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com
