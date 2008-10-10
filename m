Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 17:14:48 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9A0Edbt008546
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 17:14:40 -0700
Message-ID: <48EEACD6.7070805@sgi.com>
Date: Fri, 10 Oct 2008 11:16:06 +1000
From: Peter Leckie <pleckie@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] XFS: don't block in xfs_qm_dqflush() during async writeback
References: <1223416677-8458-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1223416677-8458-1-git-send-email-david@fromorbit.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave Chinner wrote:
> Normally dquots are written back via delayed write mechanisms.  They
> are flushed to their backing buffer by xfssyncd, which is then
> pushed out by either AIL or xfsbufd flushing. The flush from the
> xfssyncd is supposed to be non-blocking, but xfs_qm_dqflush() always
> waits for pinned duots, which means that it will block for the
> length of time it takes to do a synchronous log force. This causes
> unnecessary extra log I/O to be issued whenever we try to flush a
> busy dquot.
>
> Avoid the log forces and blocking xfssyncd by making xfs_qm_dqflush()
> pay attention to what type of sync it is doing when it sees a pinned
> dquot and not waiting when doing non-blocking flushes.
>   
This patch looks good.

Thanks,
Pete
