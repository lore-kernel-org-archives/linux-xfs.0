Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 089457F37
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 13:47:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D94FE304053
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 11:47:16 -0700 (PDT)
Received: from fieldses.org (fieldses.org [173.255.197.46]) by cuda.sgi.com
	with ESMTP id TqVeKoP2YzEnplTL for <xfs@oss.sgi.com>;
	Thu, 19 Mar 2015 11:47:15 -0700 (PDT)
Date: Thu, 19 Mar 2015 14:47:14 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: panic on 4.20 server exporting xfs filesystem
Message-ID: <20150319184714.GB20852@fieldses.org>
References: <54F78BE5.1020608@sandeen.net> <20150304225623.GZ4251@dastard>
	<20150305040849.GJ1627@fieldses.org>
	<20150305131731.GA16235@lst.de>
	<20150305150138.GA15674@fieldses.org>
	<20150305170217.GC15674@fieldses.org>
	<20150305204749.GA17934@fieldses.org>
	<20150305205922.GF18360@dastard>
	<20150306204715.GA27257@fieldses.org>
	<20150319172731.GA16329@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150319172731.GA16329@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-nfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Mar 19, 2015 at 06:27:31PM +0100, Christoph Hellwig wrote:
> FYI, I've now managed to reproduce the issue.  I haven't had time
> to dig deeper, but it smells a lot like a callback path issue.
> 
> Can you send the recursion fix to Linus ASAP and I'll send you a patch
> to turn the nopnfs option into a pnfs one, so we're at least doing
> fine for 4.0 in any case.

Sure, sounds good.

Also, there's the problem that when this is turned on a client can end
up doing unnecessary LAYOUTGET.  Do we have a plan for that?

Possibilities:

	- Just depend on export flags: but some clients may have direct
	  access and some not.  If the clients with direct access or all
	  easily identifiable by IP subnet, maybe it's not a big deal.
	  Still, seems like an administrative hassle.

	- Do nothing, assume the client can deal with this with some
	  kind of heuristics, and/or that the GETLAYOUT calls can be
	  made very cheap.  Not sure if that's true.

	- Use something like GETDEVLICELIST so the client can figure out
	  in one go whether any layouts on a given filesystem will work.
	  I forget what the problems with GETDEVICELIST were.

> I hope to debug this and may even have
> a real fix soon, but so far I don't know how long it will take.

OK, thanks.

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
