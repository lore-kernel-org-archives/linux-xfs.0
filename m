Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7C0FF7F37
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 12:27:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 12A5EAC003
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 10:27:35 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id e3D3QzXRjzb8oXdQ for
	<xfs@oss.sgi.com>; Thu, 19 Mar 2015 10:27:34 -0700 (PDT)
Date: Thu, 19 Mar 2015 18:27:31 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: panic on 4.20 server exporting xfs filesystem
Message-ID: <20150319172731.GA16329@lst.de>
References: <20150304224557.GY4251@dastard> <54F78BE5.1020608@sandeen.net>
	<20150304225623.GZ4251@dastard>
	<20150305040849.GJ1627@fieldses.org>
	<20150305131731.GA16235@lst.de>
	<20150305150138.GA15674@fieldses.org>
	<20150305170217.GC15674@fieldses.org>
	<20150305204749.GA17934@fieldses.org>
	<20150305205922.GF18360@dastard>
	<20150306204715.GA27257@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150306204715.GA27257@fieldses.org>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-nfs@vger.kernel.org, xfs@oss.sgi.com

FYI, I've now managed to reproduce the issue.  I haven't had time
to dig deeper, but it smells a lot like a callback path issue.

Can you send the recursion fix to Linus ASAP and I'll send you a patch
to turn the nopnfs option into a pnfs one, so we're at least doing
fine for 4.0 in any case.  I hope to debug this and may even have
a real fix soon, but so far I don't know how long it will take.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
