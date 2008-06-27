Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Jun 2008 09:10:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5RGAEhv032316
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 09:10:14 -0700
Date: Fri, 27 Jun 2008 12:11:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Fix disabled XFS POSIX ACL handling
Message-ID: <20080627161114.GA28296@infradead.org>
References: <20080627124354.18978.72867.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627124354.18978.72867.stgit@warthog.procyon.org.uk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: hch@infradead.org, tes@sgi.com, lachlan@sgi.com, xfs-masters@oss.sgi.com, xfs@oss.sgi.com

On Fri, Jun 27, 2008 at 01:43:54PM +0100, David Howells wrote:
> Fix XFS POSIX ACL handling when it's not enabled.  xfs_decode_acl() refers to
> return types that aren't defined under those circumstances.

The XFS tree already has a slightly different fix which should be in the
next Linux-next tree.
