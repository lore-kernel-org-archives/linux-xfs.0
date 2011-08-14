Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7E0iPYX175989 for <xfs@oss.sgi.com>; Sat, 13 Aug 2011 19:44:25 -0500
Received: from test.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7BA82136E8E8
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2011 17:46:11 -0700 (PDT)
Received: from test.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id IMdyoc1YNSeOZMGb for
	<xfs@oss.sgi.com>; Sat, 13 Aug 2011 17:46:11 -0700 (PDT)
Date: Sat, 13 Aug 2011 20:44:17 -0400
From: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: xfstests #62 broken on ext4
Message-ID: <20110814004417.GA3524@thunk.org>
References: <E1QsFMR-0001iq-Vt@tytso-glaptop>
	<20110813201419.GA6442@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110813201419.GA6442@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-ext4@vger.kernel.org, Stefan Behrens <sbehrens@giantdisaster.de>, xfs@oss.sgi.com

On Sat, Aug 13, 2011 at 04:14:19PM -0400, Christoph Hellwig wrote:
> On Sat, Aug 13, 2011 at 10:38:51AM -0400, Theodore Ts'o wrote:
> > 
> > Xfstests #62 was recently enabled by commit b2b36d0a4.
> > 
> > However, this test is failing for ext4 because ext4 doesn't support
> > extended attributes on anything other than regular files and
> > directories.  This is behavior is documented in the attr(5) man page:
> 
> As explained to you before that is not the reason why it fails.  The
> reason is that Andreas Gruenbacher changed return values for certain
> xattr operations in commit 55b23bde19c08f14127a27d461a4e079942c7258.

Apologies, I hadn't yet read your mail message while I started digging
into this failure this morning, and the fact that the files got
reordered from what was expected in the output file confused me into
thinking ext4 was failing tests that where the 062.out file expected
successes, and I juped to conclusions.

I see there's an sort command at the very end of _extend_test_bed(), I
presume we should also add a similar "LC_COLLATE=POSIX sort" to the
other "find" command pipelines, and it's easy enough to filter out the
lost+found directory by adding a "! -name lost+found".

     	  	       		    		 - Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
