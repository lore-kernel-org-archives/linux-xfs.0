Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D072D7F50
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 15:51:21 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AF958304059
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 13:51:21 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id gPpAtHdhWJzrvCLz (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 08 Dec 2015 13:51:19 -0800 (PST)
Date: Tue, 8 Dec 2015 21:51:09 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: v4.4-rc4 regression with direct-io
Message-ID: <20151208215109.GR20997@ZenIV.linux.org.uk>
References: <20151208213902.GA4212@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151208213902.GA4212@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Jan Kara <jack@suse.cz>, stable@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, Avi Kivity <avi@scylladb.com>, Jens Axboe <axboe@fb.com>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, torvalds@linux-foundation.org

On Tue, Dec 08, 2015 at 02:39:02PM -0700, Ross Zwisler wrote:
> Hey Jan,
> 
> In my test setup this commit:
> 
> 74cedf9b6c60 ("direct-io: Fix negative return from dio read beyond eof")
> 
> causes a regression with XFS and the test generic/113.  The test used to
> pass, but with the above mentioned commit it just hangs indefinitely.
> 
> This commit went in between v4.4-rc3 and v4.4-rc4, and it looks like it was
> marked for stable?

See the tip of vfs.git#for-linus for fix...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
