Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Feb 2008 20:59:18 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m164x5RS023720
	for <xfs@oss.sgi.com>; Tue, 5 Feb 2008 20:59:08 -0800
Date: Tue, 5 Feb 2008 23:55:32 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Possible fix for 2.6.24 xfs_file_readdir crash
Message-ID: <20080206045532.GA16437@infradead.org>
References: <20080205052418.GU155259@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205052418.GU155259@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Sven Geggus <lists@fuchsschwanzdomain.de>, xfs@oss.sgi.com, Tobias Ulmer <tu@emlix.com>, Andrea Perotti <andreamtp@goodfellow.it>

Looks good to me.  Well not really good but like fixing the corner case.
We really need to get rid of this stupid loop.  I'll put fixing nfsd
up higher in my todo list.
