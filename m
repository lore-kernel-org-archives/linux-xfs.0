Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Aug 2006 07:38:07 -0700 (PDT)
Received: from smtp101.sbc.mail.mud.yahoo.com (smtp101.sbc.mail.mud.yahoo.com [68.142.198.200])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7FEbeDW011399
	for <xfs@oss.sgi.com>; Tue, 15 Aug 2006 07:37:40 -0700
Date: Tue, 15 Aug 2006 07:37:09 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: 2.6.18-rc3-git3 - XFS - BUG: unable to handle kernel NULL pointer dereference at virtual address 00000078
Message-ID: <20060815143709.GA21591@tuatara.stupidest.org>
References: <20060808185405.B2528231@wobbly.melbourne.sgi.com> <9a8748490608100431m244207b1v9c9c5087233fcf3a@mail.gmail.com> <20060811083546.B2596458@wobbly.melbourne.sgi.com> <9a8748490608101544n29f863e7o7584ac64f1d4c210@mail.gmail.com> <9a8748490608101552w12822fa6m415a5fb5537c744d@mail.gmail.com> <9a8748490608110133v5f973cf6w1af340f59bb229ec@mail.gmail.com> <9a8748490608110325k25c340e2yac925eb226d1fe4f@mail.gmail.com> <20060814120032.E2698880@wobbly.melbourne.sgi.com> <9a8748490608140049t492742cx7f826a9f40835d71@mail.gmail.com> <20060815190343.A2743401@wobbly.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060815190343.A2743401@wobbly.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: Jesper Juhl <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Aug 15, 2006 at 07:03:43PM +1000, Nathan Scott wrote:

> Its not clear to me where the rename operation happens in all of
> this - does rsync create a local, temporary copy of the file and
> then rename it?

Yes, this is normally how rsync does it.
