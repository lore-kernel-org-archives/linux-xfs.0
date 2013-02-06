Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BB1C97F63
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2013 20:28:11 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3A942AC001
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2013 18:28:11 -0800 (PST)
Received: from mail-pa0-f48.google.com (mail-pa0-f48.google.com
	[209.85.220.48]) by cuda.sgi.com with ESMTP id 4tUFblJsI5UhLNZh
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 05 Feb 2013 18:28:06 -0800 (PST)
Received: by mail-pa0-f48.google.com with SMTP id hz10so487490pad.35
	for <xfs@oss.sgi.com>; Tue, 05 Feb 2013 18:28:05 -0800 (PST)
Date: Wed, 6 Feb 2013 10:42:25 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 0/4] xfstests: seek data/hole and hole punching
	improvements
Message-ID: <20130206024225.GA11254@gmail.com>
References: <1359358371-21411-1-git-send-email-wenqing.lz@taobao.com>
	<511127C2.2010409@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <511127C2.2010409@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Jie Liu <jeff.liu@oracle.com>, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>, xfs@oss.sgi.com

On Tue, Feb 05, 2013 at 09:39:46AM -0600, Mark Tinguely wrote:
> On 01/28/13 01:32, Zheng Liu wrote:
> >Hi all,
> >
> >Here is my first try to improve seek data/hole and hole punching test
> >cases in xfstests.  The key issue in 255 and 285 is that they assume that
> >all file systems that are tested support unwritten extent preallocation.
> >Before 3.8 kernel it is correct.  But now ext4 file system has ability
> >to seek data/hole and punch a hole for a file w/o unwritten extent.  So
> >it is time to improve these test cases.
> >
> >In this patch series it calls _require_xfs_io_falloc in 255 and 285 to
> >make sure that unwritten extent is supprted by tested file system.  A
> >new argument '-t' is added into seek_sanity_test to check a file system
> >that supports seek data/hole or not.  In the mean time _require_seek_data_hole
> >is defined to be used by all tests.
> >
> >Further two new test cases are created to test seek data/hole and hole
> >punching w/o unwritten extent, which do the same thing like 255 and 285
> >except that they don't do some test cases which are related to unwritten
> >extent.
> >
> >Any comments or feedbacks are welcome.
> >
> >Thanks,
> >						- Zheng
> 
> Hi Zheng,
> 
> I wonder if reviving the idea of putting the SEEK_DATA/SEEK_HOLE
> feature into xfs_io would simplify the existing tests and future ones.
> 
> My last version of the SEEK_DATA/SEEK_HOLE xfs_io extension should be
> sightly changed to make the hole only test output to be consistent with
> the data test; namely, it should end with an EOF entry.
> 
> 	http://oss.sgi.com/archives/xfs/2012-11/msg00106.html
> 
> I know there will be some result filtering needed for holes which the C
> program based tests already provide.

Hi Mark,

Thanks for your comment.  I am fine with your idea of using xfs_io to
seek data/hole.  In next version I will try to use xfs_io to implement
_require_seek_data_hole().

Regards,
                                                - Zheng

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
