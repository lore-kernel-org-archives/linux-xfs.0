Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Mar 2008 00:45:35 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2K7jQ3s006117
	for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 00:45:28 -0700
Date: Thu, 20 Mar 2008 03:45:58 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] XFSQA 141: support 64k pagesize
Message-ID: <20080320074558.GD19969@infradead.org>
References: <20080320063427.GB103491721@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320063427.GB103491721@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Mar 20, 2008 at 05:34:27PM +1100, David Chinner wrote:
> Make the file larger and read 64k from it instead of 16k
> so that it pulls in a full page from the middle of the file.

Looks good.
