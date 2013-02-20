Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6756E7F4E
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 19:19:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 572D78F8033
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 17:19:27 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	DzVqqFGqHa5etfcG for <xfs@oss.sgi.com>;
	Tue, 19 Feb 2013 17:19:22 -0800 (PST)
Date: Wed, 20 Feb 2013 12:19:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/11] xfstests: add fio requirement V2
Message-ID: <20130220011854.GK10731@dastard>
References: <1361273843-16094-1-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1361273843-16094-1-git-send-email-dmonakhov@openvz.org>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Tue, Feb 19, 2013 at 03:37:13PM +0400, Dmitry Monakhov wrote:
> FIO is very flexible io generator, I would call it IO swiss knife.
> Currently we have tonns of hardcoded application which reproduces
> some predefined scenario. This approach has obvious dissadvantages
> 1) Lack of flexability: one written it is hard to modify it in future
> 2) Code base is large, many routines written again and again
> 
> At the same time add new fio based tast is just add simle INI file.
> This greatly simplify code review. I do beleve that some day we will
> replace most of hardcoded io binaries with fio.
> 
> One who is planning to run $FIO_PROG should first check that system
> contains appropriate version which is able to handle jobfile
> for example:  _require_fio 286-job.fio
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Hi Dimitry,

Can you rebase this series on top of a current xfstests tree? It
doesn't apply without conflicts or trying to land on top of existing
files, so that makes it hard to actually test and do a final review
on....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
