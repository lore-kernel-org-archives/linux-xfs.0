Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Jun 2008 02:07:25 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5R97MoC031739
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 02:07:23 -0700
Date: Fri, 27 Jun 2008 05:08:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Fix use after free when closing log/rt devices
Message-ID: <20080627090822.GA17374@infradead.org>
References: <48647746.5010007@sgi.com> <20080627063219.GA25015@infradead.org> <48648B2B.3080709@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48648B2B.3080709@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodwin <markgw@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Jun 27, 2008 at 04:39:39PM +1000, Mark Goodwin wrote:
> do we have any QA tests that test external log?

Most QA tests will use the external log if you set it up that way.  But
ithout slab poisoning this won't be noticed either.
