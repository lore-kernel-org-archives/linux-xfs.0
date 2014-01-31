Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B8CD37F84
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 09:47:55 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 20CECAC00C
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 07:47:55 -0800 (PST)
Received: from mail-qc0-f173.google.com (mail-qc0-f173.google.com
	[209.85.216.173]) by cuda.sgi.com with ESMTP id
	ZEVbUwu9GCt0LHBG (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 31 Jan 2014 07:47:54 -0800 (PST)
Received: by mail-qc0-f173.google.com with SMTP id i8so7227849qcq.18
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 07:47:53 -0800 (PST)
Date: Fri, 31 Jan 2014 10:47:51 -0500
From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: [PATCH] xfstests: avoid ext4/306 failures caused by incompatible
	mount options
Message-ID: <20140131154750.GA2385@wallace>
References: <20140129204502.GC2165@wallace> <20140129213838.GF30419@thunk.org>
	<52E9761F.7070903@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52E9761F.7070903@redhat.com>
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
To: sandeen@redhat.com
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Theodore Ts'o <tytso@mit.edu>, Eric Whitney <enwlinux@gmail.com>

* Eric Sandeen <esandeen@redhat.com>:
> On 1/29/14, 3:38 PM, Theodore Ts'o wrote:
> > On Wed, Jan 29, 2014 at 03:45:02PM -0500, Eric Whitney wrote:
> >> ext4/306 will fail when mounting the ext3 file system it creates if an
> >> ext3-incompatible mount option is applied by _scratch_mount.  This can
> >> happen if EXT_MOUNT_OPTIONS is defined appropriately in the test
> >> environment.  For example, the block_validity option is commonly used
> >> to enhance ext4 testing, and it is not supported by ext3.  Fix this by
> >> not including any mount options defined by the test environment.
> > 
> > I'm not sure I understand why the test is insisting that the file
> > system be mounted using ext3.  If the file system is created without
> > the extents flag, all of the files will be created using indirect
> > blocks, and fundamentally what this test is getting at is that after
> > we grow the file system using resize2fs, the new blocks are available
> > to be allocated and attached to an indirect block file.
> > 
> > We can do this by using ext4; I'm not sure why this test is trying to
> > use ext3 to set up the test flie system.  It might be better to get
> > rid of the requirement to create the file system using ext3, since it
> > will make the test runnable even if the ext3 file system hasn't been
> > configured into the system and CONFIG_EXT23_AS_EXT4 is not enabled.
> > 
> > IIRC, Eric Sandeen wrote this test --- Eric, am I missing some reason
> > why it was necessary to use ext3 here?
> 
> Nope.  Tomayto, tomahto - I think the original report had trouble with
> an ext3 filesystem, so that's how I wrote the testcase.
> 
> It could be fixed either way, I think.
> 

If using ext3 doesn't add any additional value to the test, using ext4
instead certainly simplifies it.  I'll post a V2 shortly.

Thanks,
Eric


> -Eric
> 
> > 
> > 					- Ted
> > 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
