Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Jun 2007 07:00:06 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5PE03do014232
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 07:00:04 -0700
Message-ID: <467FCA62.8080800@sandeen.net>
Date: Mon, 25 Jun 2007 09:00:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] simplify vnode tracing calls
References: <467F5053.4040108@sandeen.net> <20070625062047.GB1307@infradead.org>
In-Reply-To: <20070625062047.GB1307@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Mon, Jun 25, 2007 at 12:19:15AM -0500, Eric Sandeen wrote:
>> Don't think I've sent this one yet... :)
> 
> Any chance we can keep the name lower-cases despite the simplified
> prototype?

Yeah, it is a bit of a mishmash this way isn't it.  SGI guys, do you
have a preference?  Christoph, how would you do it, vn_trace_enter(vp)
macro calling __vn_trace_enter() function?

> Also it might make sense to merge the previous patch into
> this one.

*shrug* either way.

-Eric
