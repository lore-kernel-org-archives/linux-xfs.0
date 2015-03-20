Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EAD867F37
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 01:49:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AB0288F8070
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 23:49:34 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id R9EKKNKLyjGanfyt for
	<xfs@oss.sgi.com>; Thu, 19 Mar 2015 23:49:29 -0700 (PDT)
Date: Fri, 20 Mar 2015 07:49:25 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: panic on 4.20 server exporting xfs filesystem
Message-ID: <20150320064925.GB626@lst.de>
References: <20150304225623.GZ4251@dastard>
	<20150305040849.GJ1627@fieldses.org>
	<20150305131731.GA16235@lst.de>
	<20150305150138.GA15674@fieldses.org>
	<20150305170217.GC15674@fieldses.org>
	<20150305204749.GA17934@fieldses.org>
	<20150305205922.GF18360@dastard>
	<20150306204715.GA27257@fieldses.org>
	<20150319172731.GA16329@lst.de>
	<20150319184714.GB20852@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150319184714.GB20852@fieldses.org>
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-nfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Mar 19, 2015 at 02:47:14PM -0400, J. Bruce Fields wrote:
> Also, there's the problem that when this is turned on a client can end
> up doing unnecessary LAYOUTGET.  Do we have a plan for that?
> 
> Possibilities:
> 
> 	- Just depend on export flags: but some clients may have direct
> 	  access and some not.  If the clients with direct access or all
> 	  easily identifiable by IP subnet, maybe it's not a big deal.
> 	  Still, seems like an administrative hassle.

We defintively want this to avoid getting into problems.

> 
> 	- Do nothing, assume the client can deal with this with some
> 	  kind of heuristics, and/or that the GETLAYOUT calls can be
> 	  made very cheap.  Not sure if that's true.

The calls itself are cheap, the cliet processing of them isn't.  I think we
should just stop issueing GETLAYOUT calls on the client side if we keep
errors again and again.  One option might be to add negative device id
cache entries, similar to how negative dentries work in the dcache.

> 	- Use something like GETDEVLICELIST so the client can figure out
> 	  in one go whether any layouts on a given filesystem will work.
> 	  I forget what the problems with GETDEVICELIST were.

The way the device IDs rules are written in NFS it is inherently racy.

If I could go back 10 years in time I'd rewrite device ids to be stateids
bound to a fsid, and a lot of things could be fixed up neatly that way..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
