Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 25 Oct 2008 13:18:50 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9PKIfTu028508
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:18:42 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C906D12A973E
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:18:41 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id rGhkvYCUEqp14GPY for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:18:41 -0700 (PDT)
Date: Sat, 25 Oct 2008 16:18:40 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: check for dmapi headers
Message-ID: <20081025201840.GB28002@infradead.org>
References: <490362FB.5000300@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490362FB.5000300@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sat, Oct 25, 2008 at 01:18:35PM -0500, Eric Sandeen wrote:
> I'm no autoconf wizard, but I think this does the trick to allow
> xfstests build to succeed when dmapi headers are missing, as
> they probably will be for any distro that doesn't ship with
> dmapi in the kernel, or dmapi userspace.
> 
> AFAIK the dmapi-related tests all fail gracefully with "not run."

Looks sane to me, although the dmapi library can of course be shipped
without kernel support - it's just rather useless that way :)
