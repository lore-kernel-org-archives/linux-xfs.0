Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6A1E27F55
	for <xfs@oss.sgi.com>; Mon,  8 Jul 2013 16:51:52 -0500 (CDT)
Date: Mon, 8 Jul 2013 16:51:51 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH V2] xfstests: generic/313, test sgid inheritance on subdirs
Message-ID: <20130708215151.GK20932@sgi.com>
References: <51A68175.9020202@redhat.com> <51A7B03E.2080909@sandeen.net>
	<20130612192320.GA12955@andromeda.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130612192320.GA12955@andromeda.usersys.redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

Hey Carlos & Eric,

On Wed, Jun 12, 2013 at 04:23:20PM -0300, Carlos Maiolino wrote:
> I'm personally working on this bug with Eric, and the test properly trigger the
> bug on 100% of the test runs, but, it should also ensure that
> `irix_sgid_inherit` sysctl is set to 0, if not, the test will fail.
> 
> follow is a suggestion for a better changelog:
> 
> Tests if subdirectories created on the filesystem will properly inherit sgid bit
> when this is set on the parent directory, once the process has the properly
> permissions to create a subdirectory, this, should inherit parent's sgid bit if
> this is set and irix_sgid_inherit sysctl is disabled.

I applied this and tested with Carlos's latest patch:

generic/313      - output mismatch (see /root/xfstests/results/generic/313.out.bad)
    --- tests/generic/313.out   2013-07-08 16:27:41.787710646 -0500
    +++ /root/xfstests/results/generic/313.out.bad      2013-07-08 16:47:46.052683735 -0500
    @@ -1,3 +1,3 @@
     QA output created by 313
    -drwxr-sr-x. TEST_DIR/313-dir/subdir
    +drwxr-sr-x TEST_DIR/313-dir/subdir
     drwxrwsr-x+ TEST_DIR/313-dir/subdir2
     ...
     (Run 'diff -u tests/generic/313.out /root/xfstests/results/generic/313.out.bad' to see the entire diff)

Looks like there could be a problem with ls?  Have you seen that?

Thanks,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
