Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1S8aepU169821 for <xfs@oss.sgi.com>; Tue, 28 Feb 2012 02:36:40 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	wa3INatMVb5wLbDs (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 28 Feb 2012 00:36:39 -0800 (PST)
Date: Tue, 28 Feb 2012 03:36:38 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] V2 xfs: fix deadlock in xfs_rtfree_extent with
	kernel v2.6.37
Message-ID: <20120228083638.GC22995@infradead.org>
References: <33390983.post@talk.nabble.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <33390983.post@talk.nabble.com>
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
To: Kamal Dasu <kdasu.kdev@gmail.com>
Cc: xfs@oss.sgi.com

On Sat, Feb 25, 2012 at 07:57:02AM -0800, Kamal Dasu wrote:
> 
> Christoph,
> 
> I have not been able to create a simple test case for this yet.
> 
> Currently the only way I have is to use an a time shift recording
> application 
> that stores video streams on a real-time subvolume.  Sometimes when such
> a stream is deleted I see the problem. I have not  figured out how to create
> a 
> test to consistently get allocation where the bit map span multiple extents
> while 
> freeing  the inode. 
> 
> I am still trying to come with a simple test case. 
> If you have any ideas let me know I will be happy to try it out.
> 
> I have also posted a equivalent post for the 3.3 kernel branch.
> http://old.nabble.com/-PATCH--xfs%3A-fix-deadlock-in-xfs_rtfree_extent-with-kernel-v3.x-to33375114.html

That's the mail I replied to :)

Either way - I'd love to get a good test case for it eventually, but for
now let's put in the obvious fix even if we don't have a good
reproducer.

Alex, I'd suggest this is a 3.3-rc issue as it's a regression, even if
an old one.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
