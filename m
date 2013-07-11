Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F36767F50
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 12:53:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DACE1304062
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 10:53:29 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Kj2nuHCVhKG0ggzL for
	<xfs@oss.sgi.com>; Thu, 11 Jul 2013 10:53:29 -0700 (PDT)
Date: Thu, 11 Jul 2013 14:53:16 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH V2] xfstests: generic/313, test sgid inheritance on subdirs
Message-ID: <20130711175315.GB10711@andromeda.usersys.redhat.com>
References: <51A68175.9020202@redhat.com> <51A7B03E.2080909@sandeen.net>
	<20130612192320.GA12955@andromeda.usersys.redhat.com>
	<20130708215151.GK20932@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130708215151.GK20932@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Mon, Jul 08, 2013 at 04:51:51PM -0500, Ben Myers wrote:
> Hey Carlos & Eric,
> 
> On Wed, Jun 12, 2013 at 04:23:20PM -0300, Carlos Maiolino wrote:
> > I'm personally working on this bug with Eric, and the test properly trigger the
> > bug on 100% of the test runs, but, it should also ensure that
> > `irix_sgid_inherit` sysctl is set to 0, if not, the test will fail.
> > 
> > follow is a suggestion for a better changelog:
> > 
> > Tests if subdirectories created on the filesystem will properly inherit sgid bit
> > when this is set on the parent directory, once the process has the properly
> > permissions to create a subdirectory, this, should inherit parent's sgid bit if
> > this is set and irix_sgid_inherit sysctl is disabled.
> 
> I applied this and tested with Carlos's latest patch:
> 
> generic/313      - output mismatch (see /root/xfstests/results/generic/313.out.bad)
>     --- tests/generic/313.out   2013-07-08 16:27:41.787710646 -0500
>     +++ /root/xfstests/results/generic/313.out.bad      2013-07-08 16:47:46.052683735 -0500
>     @@ -1,3 +1,3 @@
>      QA output created by 313
>     -drwxr-sr-x. TEST_DIR/313-dir/subdir
>     +drwxr-sr-x TEST_DIR/313-dir/subdir
>      drwxrwsr-x+ TEST_DIR/313-dir/subdir2
>      ...
>      (Run 'diff -u tests/generic/313.out /root/xfstests/results/generic/313.out.bad' to see the entire diff)
> 
> Looks like there could be a problem with ls?  Have you seen that?
> 
> Thanks,
> Ben
> 
Actually I don't think this is a problem, but the way newer `ls` versions are
displaying the object permissions (the 'dot' at the end of the permissions,
indicating there are no extra attributes).

I'm going to take a look on what's going on, but I still believe it's just a
matter of add the 'dot' to the xfstests correct output.

I had this same problem when testing my patch and needed to fix it locally, but
missed to warn you guys, my apologies

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
