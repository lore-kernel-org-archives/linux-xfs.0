Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0DMw8eg197802 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 16:58:08 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: Re: xfstests: Clean up build output
Date: Wed, 13 Jan 2010 16:59:04 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6967@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20100113105018.GP17483@discord.disaster>
From: "Alex Elder" <aelder@sgi.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

> We don't need to see every compiler command line for every file that
> is compiled. This makes it hard to see warnings and errors during
> compile. For progress notification, we really only need to see the
> directory/file being operated on.
> 
> Turn down the verbosity of output by suppressing various make output
> and provide better overall visibility of which directory is being
> operated on, what the operation is and what is being done to the
> files by the build/clean process.
> 
> While doing this, remove explicit target-per-file rules in the
> subdirectories being built and replace them with target based rules
> using the buildrules hooks for doing this.  This results in the
> makefiles being simpler, smaller and more consistent.
> 
> This patch does not address the dmapi subdirectory of the xfstests
> build system.
> 
> The old style verbose builds can still be run via "make V=1 ..."
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>

Didn't get this in my mail box but it looks good to me.

Reviewed-by: Alex Elder <aelder@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
