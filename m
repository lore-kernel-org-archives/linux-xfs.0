Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6PHb3AA019461 for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 12:37:03 -0500
Subject: Re: [PATCH 00/12 v3] Remove number of macros from xfs_buf.h
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110722233933.14612.65879.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110722233933.14612.65879.sendpatchset@chandra-lucid.beaverton.ibm.com>
Date: Mon, 25 Jul 2011 12:36:58 -0500
Message-ID: <1311615418.2914.57.camel@doink>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Fri, 2011-07-22 at 16:39 -0700, Chandra Seetharaman wrote:
> Hello All,
> 
> Here are few patchset to remove some of the macro definitions from 
> fs/xfs/linux-2.6/xfs_buf.h.
> 
> Please review and comment.
> 
> This set is version 3:
> Incorporated changes suggested by Alex Elder in patches 3/12, 8/12,
> 9/12 and 12/12
> 
> Version 2:
> Incorporated changes suggested by hristoph Hellwig in patches 2/12, 3/12,
> 7/12 and 10/12.

I forgot to mention before that I got some
feedback that removing these macros affects
portability to other platforms (BSD specifically).

I don't really seek to do that, and would like to
keep it so that XFS *can* port to other platforms.
Here we just face a trade-off between preserving
support for other environments (especially those
not under active development) and keeping the
leading edge of development clean, free to evolve,
and unencumbered by external requirements.

I acknowledge that by accepting these I'm leaning
toward progress of XFS despite its effect on
portability non-Linux environments (or even older
Linux kernels).

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
