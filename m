Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o132mFs6205613 for <xfs@oss.sgi.com>; Tue, 2 Feb 2010 20:48:15 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72BB31C9B883
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2010 18:49:24 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id yH9rD321Jl0XDePx for
	<xfs@oss.sgi.com>; Tue, 02 Feb 2010 18:49:24 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id A3780109E852
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2010 20:49:23 -0600 (CST)
Message-ID: <4B68E433.9050309@sandeen.net>
Date: Tue, 02 Feb 2010 20:49:23 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfstests: routine to create scratch of certain size
References: <4B621D89.8070800@sandeen.net> <4B68D75A.9020105@sandeen.net>
In-Reply-To: <4B68D75A.9020105@sandeen.net>
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
To: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> This is needed for later enospc tests to be generic
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
> 
> V2: Address Christoph's comment about use of MKFS_OPTIONS;
> just do it like the other geom helper and explicitly -set-
> MKFS_OPTIONS for scratch, to set the size, then just call
> _scratch_mkfs
> 
> (this would override any global MKFS_OPTIONS setting, but
> I think that's ok for now, and not sure how these options might
> interact w/ previously set MKFS_OPTIONS anyway)

Scratch that, I'm not being diligent enough and didn't test
this :/  (yay for "simple" changes)

mke2fs takes the size arg at the end, after the device, so
we cannot just set up MKFS_OPTIONS

Sorry for the noise.

-Eric (who will try to be more dilient now...)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
