Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 653AE7F50
	for <xfs@oss.sgi.com>; Wed,  9 Dec 2015 06:07:39 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ED396AC007
	for <xfs@oss.sgi.com>; Wed,  9 Dec 2015 04:07:35 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id wybazT70TcMyorFA (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 09 Dec 2015 04:07:32 -0800 (PST)
Date: Wed, 9 Dec 2015 12:49:02 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: v4.4-rc4 regression with direct-io
Message-ID: <20151209114902.GD3137@quack.suse.cz>
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

On Tue 08-12-15 21:51:09, Al Viro wrote:
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

Ah, thanks for fixing this up! I'm just wondering how the test program I
was using could have passed because pread() I'm doing there must have
returned ENOMEM... Argh, I see. I have tested the problem with ext4 which
uses DIO_LOCKING mode and in that case 'retval' gets overwritten to 0 by
filemap_write_and_wait() call :-|.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
