Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B18BE7F52
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 00:51:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A01398F8039
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 22:51:04 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	gvz8H4XY0ggNZa7t for <xfs@oss.sgi.com>;
	Wed, 23 Apr 2014 22:51:02 -0700 (PDT)
Date: Thu, 24 Apr 2014 15:51:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 00/11] xfs: introduce the free inode btree
Message-ID: <20140424055101.GD15995@dastard>
References: <1397146116-42546-1-git-send-email-bfoster@redhat.com>
	<20140414094632.GC31578@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140414094632.GC31578@dastard>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Apr 14, 2014 at 07:46:32PM +1000, Dave Chinner wrote:
> On Thu, Apr 10, 2014 at 12:08:25PM -0400, Brian Foster wrote:
> > Hi all,
> > 
> > This is a minor rebase of the finobt series on the latest for-next
> > branch. The previous version (v4) is here:
> > 
> > http://oss.sgi.com/archives/xfs/2014-02/msg00763.html
> > 
> > The most recent series with review feedback is v3:
> > 
> > http://oss.sgi.com/archives/xfs/2014-02/msg00121.html
> > 
> > Brian
> 
> I've just had a look at this series, and I haven't found anything to
> complain about apart from a couple of stray whitespaces that I
> fixed. I'm going to run it through some finobt=0 test runs until i
> get a chance to look at the userspace patches. If I don't notice
> anything in the next couple of days, I'll merge the topic branch
> into the main tree....

All looks pretty good. I can fix the one little problem I noticed
myself, and so I think this is ready for merging. The userspace
stuff isn't directly necessary right away - that won't get merged
until 3.2 is released, but I don't see that as a problem for merging
the kernel code...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
