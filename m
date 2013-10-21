Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E32787F56
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 10:09:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 62F1CAC001
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 08:09:54 -0700 (PDT)
Received: from dkim1.fusionio.com (dkim1.fusionio.com [66.114.96.53]) by
	cuda.sgi.com with ESMTP id DvBVjSYVtWhISe1s (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 21 Oct 2013 08:09:52 -0700 (PDT)
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 206017C0681
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 09:09:52 -0600 (MDT)
Date: Mon, 21 Oct 2013 11:09:50 -0400
From: Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH 2/8] xfstests: add regression test for kernel bz 60673
Message-ID: <20131021150950.GH6924@localhost.localdomain>
References: <1382120790-31060-1-git-send-email-jbacik@fusionio.com>
	<1382120790-31060-2-git-send-email-jbacik@fusionio.com>
	<5265422E.8000101@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5265422E.8000101@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>, xfs@oss.sgi.com

On Mon, Oct 21, 2013 at 10:03:10AM -0500, Eric Sandeen wrote:
> On 10/18/13 1:26 PM, Josef Bacik wrote:
> > There was a problem with send trying to overwrite a file that wasn't actually
> > the same.  This is a test to check this particular case where receive fails when
> > it should succeed properly.  I tested this to verify it fails without my fix and
> > passes with my fix.  Thanks,
> 
> 2 things - 
> 
> Why does the selinux context break things?  That seems like a problem w/ send
> if it can't work on a context-mounted fs?  (disabling it for now doesn't bother
> me, but I'm surprised that it's required).
> 

So it is the context that xfstests is using, not contexts itself.  Xfstests is
using the nfs context, and using selinux contexts intercepts all getxattr calls,
so when send tries to copy the xattrs for the file it calls getxattr, and
because we are using the nfs context it returns EOPNOTSUPP from selinux, it
never makes it down to btrfs.  When using the actual real context it works fine
because it calls down into the file system.

> ((I also wonder if I should get rid of that context in general and use it only
> for tests which fail without it))
> 
> Rather than all the cd'ing around (to /) what if you just do something like:
> 
> SEND_TEST_DIR=$TEST_DIR/$tmp_dir/send
> 
> mkdir $SEND_TEST_DIR
> touch $SEND_TEST_DIR/baz
> touch $SEND_TEST_DIR/blah
> mkdir $SEND_TEST_DIR/foo
> touch $SEND_TEST_DIR/foo/bar
> 
> that seems a bit cleaner to me vs. the cd back and forth.
> 

Yeah I can do that, thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
