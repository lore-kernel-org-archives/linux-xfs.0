Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 08B397F3F
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 07:42:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 87C37AC006
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 05:42:40 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id SPx5vfTKrit4ROvu (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 12 May 2014 05:42:35 -0700 (PDT)
Date: Mon, 12 May 2014 08:42:32 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH -v2] check: add support for an external file containing
	tests to exclude
Message-ID: <20140512124232.GB31376@thunk.org>
References: <20140416001530.GU15995@dastard>
	<1397624302-9577-1-git-send-email-tytso@mit.edu>
	<20140416064018.GJ15995@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140416064018.GJ15995@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Apr 16, 2014 at 04:40:18PM +1000, Dave Chinner wrote:
> On Wed, Apr 16, 2014 at 12:58:22AM -0400, Theodore Ts'o wrote:
> > Currently the -X option is intended to specify a set of expunging
> > files which are stored in each test/* subdirectory.  As described in
> > the commit description for 0b1e8abd4, in order to exclude the test
> > generic/280, the -X option is used as follows:
> > 
> >     $ cat tests/generic/3.0-stable-avoid
> >     280
> >     $ sudo ./check -X 3.0-stable-avoid generic/280
> > 
> > However, it is sometimes useful to store the set of expunged tests in
> > a single file, outside of tests/* subdirectories.  This commit enables
> > the following:
> > 
> >     $ cat /root/conf/data_journal.exclude
> >     generic/068
> >     ext4/301
> >     $ sudo ./check -E /root/conf/data_journal.exclude -g auto
> > 
> > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> Looks good.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

This patch has apparently not hit the xfstests repository.  Would you
like me to resend it?

Thanks,

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
