Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 05:55:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9ECtFA5021730
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 05:55:17 -0700
Date: Tue, 14 Oct 2008 08:56:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: TAKE 988255 - fix instant oops with tracing enabled
Message-ID: <20081014125650.GB13296@infradead.org>
References: <20081014011747.AC14E58FA1E9@chook.melbourne.sgi.com> <20081014020556.GH10716@disturbed> <48F42F12.1010409@sgi.com> <20081014054103.GK10716@disturbed> <48F43838.9040606@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F43838.9040606@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 14, 2008 at 05:12:08PM +1100, Timothy Shimmin wrote:
> OOI, can anyone comment on any suggestions for other tracing mechanisms.
> I recall Christoph mentioning something in the past but it wasn't
> ready yet or something???.
> I'd really like to be able to access tracing output via proc
> instead of just within kdb,
> as I have used in the past with Greg Banks qtrace patches.

Yah, I've been working on doing that and wire it up with trace_mark.
I'll move it up on my TODO list a little..
