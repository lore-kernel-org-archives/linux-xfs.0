Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2PFKgxW101373 for <xfs@oss.sgi.com>; Wed, 25 Mar 2009 10:20:52 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A0E681C6D70C
	for <xfs@oss.sgi.com>; Wed, 25 Mar 2009 08:20:15 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com
	with ESMTP id pC7yiYmVSHf4yYi6 for <xfs@oss.sgi.com>;
	Wed, 25 Mar 2009 08:20:15 -0700 (PDT)
Date: Wed, 25 Mar 2009 11:19:47 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1/5] [XFS] Use xfs_sync_inodes() for device flushing
In-Reply-To: <20090320043027.GO26138@disturbed>
Message-ID: <Pine.LNX.4.64.0903251115310.27750@hs20-bc2-1.build.redhat.com>
References: <1237114679-18808-1-git-send-email-david@fromorbit.com>
	<1237114679-18808-2-git-send-email-david@fromorbit.com>
	<Pine.LNX.4.64.0903170857050.26754@hs20-bc2-1.build.redhat.com>
	<20090318041752.GN26138@disturbed>
	<Pine.LNX.4.64.0903181207390.19233@hs20-bc2-1.build.redhat.com>
	<20090320043027.GO26138@disturbed>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com



On Fri, 20 Mar 2009, Dave Chinner wrote:

> On Wed, Mar 18, 2009 at 12:14:51PM -0400, Mikulas Patocka wrote:
> > On Wed, 18 Mar 2009, Dave Chinner wrote:
> > > On Tue, Mar 17, 2009 at 09:08:36AM -0400, Mikulas Patocka wrote:
> > > > On Sun, 15 Mar 2009, Dave Chinner wrote:
> > What I find scary is those two recursive pagelocks being held without 
> > trylock. The sequence is like:
> > 
> > lock iolock 1
> > lock pagelock 1
> > --- submit request to xfssyncd, that does
> > trylock iolock 2
> > lock pagelock 2
> 
> Those two pages will be on different inodes, so locking through all
> paths to pagelock 2 except for page writeback will be protected by the iolocks...
> 
> > ... now suppose that this is racing with another process that takes 
> > pagelock without taking iolock first (memory manager trying to flush files 
> > mmaped for write or so). It can do
> > 
> > lock pagelock 2
> > ... and submit flush request to a thread that is actually waiting to get 
> > pagelock 2.
> 
> Which, AFAIK, is never done in XFS. Once we have a page locked in
> the writeback path we either dispatch it in an IO or unlock it
> directly before continuing. There should not be a case like you
> describe occurring (it is a bug if that does happen).
> 
> > --- I don't know --- is there a possibility to reserve filesystem space 
> > for write-mapped files at the time of the first page fault? (so that the 
> > space won't be allocated at the time of a flush?).
> 
> ->page_mkwrite

This is called without page lock so it is ok.

So I think there is no deadlock possibility.

But I still say that it is scary to take two pagelocks recursively and 
there is risk that someone will forget about these specific requirements 
after few years and make a bug.

Mikulas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
