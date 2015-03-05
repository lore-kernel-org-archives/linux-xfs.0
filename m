Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7AB517F3F
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 11:02:25 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6A1B3304053
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 09:02:22 -0800 (PST)
Received: from fieldses.org (fieldses.org [173.255.197.46]) by cuda.sgi.com
	with ESMTP id IYDjPHfpPVWtgRcw for <xfs@oss.sgi.com>;
	Thu, 05 Mar 2015 09:02:18 -0800 (PST)
Date: Thu, 5 Mar 2015 12:02:17 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: panic on 4.20 server exporting xfs filesystem
Message-ID: <20150305170217.GC15674@fieldses.org>
References: <20150304020826.GD19439@fieldses.org>
	<20150304155421.GE1627@fieldses.org>
	<20150304220900.GX18360@dastard>
	<20150304222709.GI1627@fieldses.org>
	<20150304224557.GY4251@dastard> <54F78BE5.1020608@sandeen.net>
	<20150304225623.GZ4251@dastard>
	<20150305040849.GJ1627@fieldses.org>
	<20150305131731.GA16235@lst.de>
	<20150305150138.GA15674@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150305150138.GA15674@fieldses.org>
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

On Thu, Mar 05, 2015 at 10:01:38AM -0500, J. Bruce Fields wrote:
> On Thu, Mar 05, 2015 at 02:17:31PM +0100, Christoph Hellwig wrote:
> > On Wed, Mar 04, 2015 at 11:08:49PM -0500, J. Bruce Fields wrote:
> > > Ah-hah:
> > > 
> > > 	static void
> > > 	nfsd4_cb_layout_fail(struct nfs4_layout_stateid *ls)
> > > 	{
> > > 		...
> > > 		nfsd4_cb_layout_fail(ls);
> > > 
> > > That'd do it!
> > > 
> > > Haven't tried to figure out why exactly that's getting called, and why
> > > only rarely.  Some intermittent problem with the callback path, I guess.
> > > 
> > > Anyway, I think that solves most of the mystery....
> > 
> > Ooops, that was a nasty git merge error in the last rebase, see the fix
> > below.
> 
> Thanks!

And with that fix things look good.

I'm still curious why the callbacks are failling.  It's also logging
"nfsd: client 192.168.122.32 failed to respond to layout recall".

I may not get a chance to debug for another week or two.

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
