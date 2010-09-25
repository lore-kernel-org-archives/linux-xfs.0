Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8PH08HQ242242 for <xfs@oss.sgi.com>; Sat, 25 Sep 2010 12:00:10 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C91A912E7BF1
	for <xfs@oss.sgi.com>; Sat, 25 Sep 2010 10:13:50 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id mHwqaccynR2M9pWo for
	<xfs@oss.sgi.com>; Sat, 25 Sep 2010 10:13:50 -0700 (PDT)
Date: Sat, 25 Sep 2010 13:01:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Problem with file system on iSCSI FileIO
Message-ID: <20100925170103.GA2422@infradead.org>
References: <4C9B5786.4010205@open-e.com> <20100923143221.GA1989@infradead.org>
	<4C9B6B27.5050606@open-e.com>
	<20100924075505.GA24664@infradead.org>
	<4C9C875D.9050308@open-e.com>
	<20100925155611.GA21928@infradead.org>
	<AANLkTik=wkAkbexmO+4WCCT2pusRu-DTq1=yNwv9V5f0@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTik=wkAkbexmO+4WCCT2pusRu-DTq1=yNwv9V5f0@mail.gmail.com>
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
To: Richard Sharpe <realrichardsharpe@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Slawomir Nowakowski <slawomir.nowakowski@open-e.com>, xfs@oss.sgi.com

On Sat, Sep 25, 2010 at 09:54:46AM -0700, Richard Sharpe wrote:
> fileio uses submit_bio to submit the data and it defaults to
> WRITE_THROUGH, NV_CACHE and DIRECT_IO (at least in the trunk, but I
> suspect this has been the case for a long while) however, the person
> making the complaint might have switched off WRITE_THROUGH in the
> pursuit of performance, in which case a crash could corrupt things
> badly but it would depend on whether or not clearing WRITE_THROUGH
> also clears NV_CACHE and what the code assembling the caching mode
> page does (and I have only had a cursory glance at the vdisk code).

If the target uses submit_bio for logical files inside a filesystems
there are hundreds of ways to get exactly the corruption that Slawomir
sees.  How does it obtain the logical to physical mapping?  What locking
does it use agains other access to the file?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
