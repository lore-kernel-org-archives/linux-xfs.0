Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Oct 2006 01:07:34 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9D87OaG003514
	for <xfs@oss.sgi.com>; Fri, 13 Oct 2006 01:07:27 -0700
Date: Fri, 13 Oct 2006 18:06:31 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: [patch] Fix xfs_iunpin() sets I_DIRTY_SYNC after clear_inode().
Message-ID: <A8B8A403673D06CB0221176D@boing.melbourne.sgi.com>
In-Reply-To: <20061013014651.GC19345@melbourne.sgi.com>
References: <45237CCE.4010007@ah.jp.nec.com>
 <20061006032617.GC11034@melbourne.sgi.com>
 <20061011064357.GN19345@melbourne.sgi.com> <452E32FF.8010109@ah.jp.nec.com>
 <20061013014651.GC19345@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, Takenori Nagano <t-nagano@ah.jp.nec.com>
Cc: xfs@oss.sgi.com



--On 13 October 2006 11:46:51 AM +1000 David Chinner <dgc@sgi.com> wrote:

>> Now, I am trying to ease the degradation.
>> Do you have any idea for resolving the degradation?
>
> Did you see a degradation with your original fix? I suspect
> not.
>
> I think that the lsn based flush is tripping over a sync
> transaction "optimisation" - if the previous log buffer needs
> syncing or is currently being synced, then we don't try to flush the
> active log buffer straight away - we wait for the previous log
> buffer to complete it's I/O in the hope that we get more
> transactions into the current log buffer.

You're referring to the code in xlog_state_sync() for the
XLOG_STATE_ACTIVE case with the big header comment.
It looks to be the one place where we sleep (sv_wait) even
when we haven't got XFS_LOG_SYNC set (which we don't have here AFAICT).
In this case, waiting for the previous iclog to the given
lsn's iclog.

--Tim
