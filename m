Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CAD787F4E
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 02:14:27 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BAF18304067
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 00:14:24 -0800 (PST)
Received: from mail-lb0-f174.google.com (mail-lb0-f174.google.com
	[209.85.217.174]) by cuda.sgi.com with ESMTP id
	UQIA7NaRfFuE8g7y (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 20 Feb 2013 00:14:22 -0800 (PST)
Received: by mail-lb0-f174.google.com with SMTP id l12so5792630lbo.19
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 00:14:21 -0800 (PST)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 01/11] xfstests: add fio requirement V2
In-Reply-To: <20130220011854.GK10731@dastard>
References: <1361273843-16094-1-git-send-email-dmonakhov@openvz.org>
	<20130220011854.GK10731@dastard>
Date: Wed, 20 Feb 2013 12:14:17 +0400
Message-ID: <87y5ej767a.fsf@openvz.org>
MIME-Version: 1.0
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
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Wed, 20 Feb 2013 12:19:21 +1100, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Feb 19, 2013 at 03:37:13PM +0400, Dmitry Monakhov wrote:
> > FIO is very flexible io generator, I would call it IO swiss knife.
> > Currently we have tonns of hardcoded application which reproduces
> > some predefined scenario. This approach has obvious dissadvantages
> > 1) Lack of flexability: one written it is hard to modify it in future
> > 2) Code base is large, many routines written again and again
> > 
> > At the same time add new fio based tast is just add simle INI file.
> > This greatly simplify code review. I do beleve that some day we will
> > replace most of hardcoded io binaries with fio.
> > 
> > One who is planning to run $FIO_PROG should first check that system
> > contains appropriate version which is able to handle jobfile
> > for example:  _require_fio 286-job.fio
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> 
> Hi Dimitry,
> 
> Can you rebase this series on top of a current xfstests tree? It
Ohhh. I use  git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
> doesn't apply without conflicts or trying to land on top of existing
> files, so that makes it hard to actually test and do a final review
> on....
Will do ASAP.

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
