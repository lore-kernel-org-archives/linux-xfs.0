Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54670 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733161AbfETQMC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 12:12:02 -0400
Date: Mon, 20 May 2019 12:12:00 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [Bug 203655] XFS: Assertion failed: 0, xfs_log_recover.c, line:
 551
Message-ID: <20190520161200.GB32784@bfoster>
References: <bug-203655-201763@https.bugzilla.kernel.org/>
 <bug-203655-201763-WLgC3hGYRF@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-203655-201763-WLgC3hGYRF@https.bugzilla.kernel.org/>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-xfs@vger.kernel.org

On Mon, May 20, 2019 at 04:02:06PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=203655
> 
> Eric Sandeen (sandeen@sandeen.net) changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |sandeen@sandeen.net
> 
> --- Comment #2 from Eric Sandeen (sandeen@sandeen.net) ---
> I think the question here is whether the ASSERT() is valid - we don't ever want
> to assert on disk corruption, it should only be for "this should never happen
> in the code" scenarios.
> 

Makes sense. It's not clear to me whether that's the intent of the bug,
but regardless I think it would be reasonable to kill off that
particular assert. We already warn and return an error.

Brian

> -- 
> You are receiving this mail because:
> You are watching the assignee of the bug.
