Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 13 Oct 2008 23:10:32 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9E6AUZR028109
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 23:10:30 -0700
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by relay1.corp.sgi.com (Postfix) with SMTP id EE7308F807F
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 23:12:09 -0700 (PDT)
Received: from boing.melbourne.sgi.com (boing.melbourne.sgi.com [134.14.55.141]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id RAA18540 for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 17:12:08 +1100
Message-ID: <48F43838.9040606@sgi.com>
Date: Tue, 14 Oct 2008 17:12:08 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: TAKE 988255 - fix instant oops with tracing enabled
References: <20081014011747.AC14E58FA1E9@chook.melbourne.sgi.com> <20081014020556.GH10716@disturbed> <48F42F12.1010409@sgi.com> <20081014054103.GK10716@disturbed>
In-Reply-To: <20081014054103.GK10716@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Dave Chinner wrote:
> On Tue, Oct 14, 2008 at 03:33:06PM +1000, Lachlan McIlroy wrote:
>> Dave Chinner wrote:
>>> On Tue, Oct 14, 2008 at 12:17:47PM +1100, Lachlan McIlroy wrote:
>>>> fix instant oops with tracing enabled
>>>>
>>>> We can only read inode->i_count if the inode is actually there and not
>>>> a NULL pointer.  This was introduced in one of the recent sync patches.
>>>>
>>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>> BTW, this now means that other pending patches won't apply cleanly....
>>>
>> Yeah this patch hunk didn't apply but was easy to hand merge.  It also
>> didn't compile because of a missing comma from the 4th last line.  Can
>> you please make sure each of your patch series compile on their own?
> 
> I do make sure every patch compiles given the config options a
> mainline kernel allows. However, the CONFIG_XFS_TRACE option is not
> present in mainline-derived kernels so it's not obvious when
> problems occur inside code that isn't easily configurable on
> such a kernel....
> 
> As it is, I haven't done a CONFIG_XFS_TRACE build for several months
> because I've found that I haven't needed tracing to find problems
> esoteric problems. Using watchpoints, breakpoints and single
> stepping catches problems as they occur rather than needing tracing
> to try to work out what went wrong after a problem has occurred.
> 
OOI, can anyone comment on any suggestions for other tracing mechanisms.
I recall Christoph mentioning something in the past but it wasn't
ready yet or something???.
I'd really like to be able to access tracing output via proc
instead of just within kdb,
as I have used in the past with Greg Banks qtrace patches.

--Tim
