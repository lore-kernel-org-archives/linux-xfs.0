Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Apr 2008 20:50:02 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3S3nh0V028686
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 20:49:49 -0700
Date: Sun, 27 Apr 2008 23:50:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_page_state_convert()
Message-ID: <20080428035023.GA14275@infradead.org>
References: <200804270246.58828.vda.linux@googlemail.com> <20080427232317.GB103491721@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080427232317.GB103491721@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 09:23:17AM +1000, David Chinner wrote:
> No. That code is complex enough with only one copy of it around. I don't
> want two copies that differ subtly and hence have two different sets
> of nasty, rarely hit corner cases in them.

Actually the split makes some sense.  I had a ready patch to split out
releasepage which makes the whole code a lot nicer.  I didn't go forward
with it because I had this idea that it would get replaced by Chris
extent_map stuff ASAP..
