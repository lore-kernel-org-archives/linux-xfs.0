Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p43HZAL9022728 for <xfs@oss.sgi.com>; Tue, 3 May 2011 12:35:10 -0500
Subject: Re: [PATCH] xfstests: clean up fallocate configuration tests
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <4DBF492E.3040400@sandeen.net>
References: <4DBF492E.3040400@sandeen.net>
Date: Tue, 3 May 2011 12:38:43 -0500
Message-ID: <1304444323.2853.28.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, 2011-05-02 at 19:15 -0500, Eric Sandeen wrote:
> When I added fallocate support to fsx I inadvertently added
> a duplicate fallocate test.
> 
> Consolidate them both into one test (the link test, not the
> compile test) and make all tests use "true" rather than "yes"
> to be more consistent with other tests.

Looks reasonable to me.  I learned a little something
about autoconf while looking at this.  Glad you're an
expert :)

I do see that AC_TRY_COMPILE() is now considered obsolete
so at some point maybe we should update to use the suggested
alternatives (AC_COMPILE_IFELSE() in this example).

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
