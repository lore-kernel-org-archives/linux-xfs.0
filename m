Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A5B5E29DF5
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 17:14:45 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9595F8F8037
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 15:14:42 -0800 (PST)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24]) by
	cuda.sgi.com with ESMTP id VmhaLTRM0nrNRLFj for
	<xfs@oss.sgi.com>; Tue, 08 Dec 2015 15:14:41 -0800 (PST)
Date: Tue, 8 Dec 2015 16:14:38 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: v4.4-rc4 regression with direct-io
Message-ID: <20151208231438.GA8497@linux.intel.com>
References: <20151208213902.GA4212@linux.intel.com>
	<20151208215109.GR20997@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151208215109.GR20997@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Avi Kivity <avi@scylladb.com>, Jan Kara <jack@suse.cz>, stable@vger.kernel.org, xfs@oss.sgi.com, Jens Axboe <axboe@fb.com>, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, torvalds@linux-foundation.org, Steven Whitehouse <swhiteho@redhat.com>

On Tue, Dec 08, 2015 at 09:51:09PM +0000, Al Viro wrote:
> On Tue, Dec 08, 2015 at 02:39:02PM -0700, Ross Zwisler wrote:
> > Hey Jan,
> > 
> > In my test setup this commit:
> > 
> > 74cedf9b6c60 ("direct-io: Fix negative return from dio read beyond eof")
> > 
> > causes a regression with XFS and the test generic/113.  The test used to
> > pass, but with the above mentioned commit it just hangs indefinitely.
> > 
> > This commit went in between v4.4-rc3 and v4.4-rc4, and it looks like it was
> > marked for stable?
> 
> See the tip of vfs.git#for-linus for fix...

I've confirmed that this fixes my test case.  Thanks!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
