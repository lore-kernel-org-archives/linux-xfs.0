Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2C9357CBE
	for <xfs@oss.sgi.com>; Sat,  8 Aug 2015 19:13:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 027188F8035
	for <xfs@oss.sgi.com>; Sat,  8 Aug 2015 17:13:20 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	q41GwZidrHkS2nxG for <xfs@oss.sgi.com>;
	Sat, 08 Aug 2015 17:13:15 -0700 (PDT)
Date: Sun, 9 Aug 2015 10:11:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: why crc req on free-inobt & file-type-indir options?
Message-ID: <20150809001127.GI3902@dastard>
References: <55C41D75.4040504@tlinx.org> <55C43B70.4050300@sandeen.net>
	<55C468F0.2040707@tlinx.org> <20150807225531.GG3902@dastard>
	<55C55265.4080309@tlinx.org>
	<620A4212-818A-4375-90FC-DBB0B91A84DB@sandeen.net>
	<55C5709F.8030705@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55C5709F.8030705@tlinx.org>
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
To: "L.A. Walsh" <xfs@tlinx.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Fri, Aug 07, 2015 at 07:59:43PM -0700, L.A. Walsh wrote:
> 
> 
> Eric Sandeen wrote:
> >
> >>On Aug 7, 2015, at 5:50 PM, L.A. Walsh <xfs@tlinx.org> wrote:
> >>Q: should the versions of xfsdump&restore be the same as the rest of the xfsprogs?
> >Nope, they are separate packages with separate versioning.
> ---
> I see.  So how does one tell which version of xfsdump/restore should
> be used to "safely" dump (and restore) a file system made
> with version i.j.k of xfsprogs(mkfs.xfs) ?  Or is that possible?

xfsdump does not care what version of the XFS filesystem it operates
on as it does not access the raw on-disk srtuctures. i.e.
xfsdump/restore are just like any other userspace application that
uses standard syscalls and ioctls to read/write information to/from
the filesystem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
