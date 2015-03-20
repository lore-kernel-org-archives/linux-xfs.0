Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F25647F37
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 16:56:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BE46D8F8089
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 14:56:57 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id WogLfYsyBiQUDoz8 for <xfs@oss.sgi.com>;
	Fri, 20 Mar 2015 14:56:55 -0700 (PDT)
Message-ID: <550C97A5.1040807@sandeen.net>
Date: Fri, 20 Mar 2015 16:56:53 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] mkfs: default to CRC enabled filesystems
References: <1426720967-8215-1-git-send-email-david@fromorbit.com>
	<550AE35D.40006@sandeen.net> <20150319231323.GK10105@dastard>
	<550C3C39.8050400@sandeen.net> <20150320214719.GJ28621@dastard>
In-Reply-To: <20150320214719.GJ28621@dastard>
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
Cc: xfs@oss.sgi.com

On 3/20/15 4:47 PM, Dave Chinner wrote:
> On Fri, Mar 20, 2015 at 10:26:49AM -0500, Eric Sandeen wrote:

...

>> I don't see how this requires xfstests rework, though?
> 
> About 50 tests fail with:

>     +warning: finobt not supported without CRC support, disabled.

> When run with MKFS_OPTIONS="-m crc=0".

Ok, I didn't mean it shouldn't be automatically disabled, I just meant
it should probably reject invalid option combinations on the cmdline.
 
> i.e. finobt is not specified, but mkfs issues warnings about it.
> 
> I've reworked the patch, anyway, so there's no need to continue the
> discussion on this...

Heh, ok.  <EOM>

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
