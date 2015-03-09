Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 10A637F4E
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 14:46:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8B96FAC001
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 12:46:04 -0700 (PDT)
Received: from fieldses.org (fieldses.org [173.255.197.46]) by cuda.sgi.com
	with ESMTP id jrdHVbGF13QvyGHM for <xfs@oss.sgi.com>;
	Mon, 09 Mar 2015 12:45:59 -0700 (PDT)
Date: Mon, 9 Mar 2015 15:45:59 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: panic on 4.20 server exporting xfs filesystem
Message-ID: <20150309194559.GC2627@fieldses.org>
References: <20150304222709.GI1627@fieldses.org>
	<20150304224557.GY4251@dastard> <54F78BE5.1020608@sandeen.net>
	<20150304225623.GZ4251@dastard>
	<20150305040849.GJ1627@fieldses.org>
	<20150305131731.GA16235@lst.de>
	<20150305150138.GA15674@fieldses.org>
	<20150305170217.GC15674@fieldses.org>
	<20150305204749.GA17934@fieldses.org>
	<20150308153056.GA24037@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150308153056.GA24037@lst.de>
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

On Sun, Mar 08, 2015 at 04:30:56PM +0100, Christoph Hellwig wrote:
> On Thu, Mar 05, 2015 at 03:47:49PM -0500, J. Bruce Fields wrote:
> > nfsd: client 192.168.122.32 failed to respond to layout recall.   Fencing..
> > nfsd: fence failed for client 192.168.122.32: -2!
> > nfsd: client 192.168.122.32 failed to respond to layout recall.   Fencing..
> > nfsd: fence failed for client 192.168.122.32: -2!
> 
> There is no userspace elper to do the fencing, so unfortunately this
> is expecvted.
> 
> > receive_cb_reply: Got unrecognized reply: calldir 0x1 xpt_bc_xprt ffff88005639a000 xid c21abd62
> 
> Now this looks like some issue with the low-level callback path.  I've never
> seen tis before, but from looking at receive_cb_reply this happens if
> xprt_lookup_rqst can't find a rpc_rqst structured for the xid.  Looks like
> we might be corrupting the request list / xid allocation somewhere?
> 
> I can prepare a patch for you to aid with xid tracing if you want.

I'll take a look when I get back.  But before that I'd like to
understand why the layout seems to be left here blocking writes forever,
instead of getting cleaned up after a lease period with no layout
return.

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
