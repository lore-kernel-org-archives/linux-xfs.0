Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4EBC77F4E
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 04:29:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DB5A4AC008
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 02:29:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id B8CdB6uf2Kj30rjC for
	<xfs@oss.sgi.com>; Tue, 22 Apr 2014 02:28:59 -0700 (PDT)
Date: Tue, 22 Apr 2014 11:28:31 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/3] xfstests: add helper for zero range support check
In-Reply-To: <20140422091620.GA4980@infradead.org>
Message-ID: <alpine.LFD.2.00.1404221127240.7437@localhost.localdomain>
References: <20140421204023.GB960@wallace>
	<20140422062816.GB31337@infradead.org>
	<20140422091443.GG15995@dastard>
	<20140422091620.GA4980@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Tue, 22 Apr 2014, Christoph Hellwig wrote:

> Date: Tue, 22 Apr 2014 02:16:20 -0700
> From: Christoph Hellwig <hch@infradead.org>
> To: Dave Chinner <david@fromorbit.com>
> Cc: Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org,
>     xfs@oss.sgi.com, Eric Whitney <enwlinux@gmail.com>
> Subject: Re: [PATCH 1/3] xfstests: add helper for zero range support check
> 
> On Tue, Apr 22, 2014 at 07:14:43PM +1000, Dave Chinner wrote:
> > I don't really care either way, as long as all the checks are done
> > consistently. Send a patch to change them all... :)
> 
> My flink test already avoids the wrapper :)
> 
> So how about we stop adding them for now at least.

I agree,

even though I screwed up when using _require_xfs_io_command with
fzero :) I think that we can avoid the wrappers and just use
_require_xfs_io_command() with the command name.

-Lukas

> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
