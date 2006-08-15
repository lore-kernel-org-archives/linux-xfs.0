Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Aug 2006 07:52:11 -0700 (PDT)
Received: from mailer.gwdg.de (mailer.gwdg.de [134.76.10.26])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7FEpfDW015101
	for <xfs@oss.sgi.com>; Tue, 15 Aug 2006 07:51:42 -0700
Date: Tue, 15 Aug 2006 16:47:56 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: 2.6.18-rc3-git3 - XFS - BUG: unable to handle kernel NULL pointer
 dereference at virtual address 00000078
In-Reply-To: <20060815143709.GA21591@tuatara.stupidest.org>
Message-ID: <Pine.LNX.4.61.0608151644460.9359@yvahk01.tjqt.qr>
References: <20060808185405.B2528231@wobbly.melbourne.sgi.com>
 <9a8748490608100431m244207b1v9c9c5087233fcf3a@mail.gmail.com>
 <20060811083546.B2596458@wobbly.melbourne.sgi.com>
 <9a8748490608101544n29f863e7o7584ac64f1d4c210@mail.gmail.com>
 <9a8748490608101552w12822fa6m415a5fb5537c744d@mail.gmail.com>
 <9a8748490608110133v5f973cf6w1af340f59bb229ec@mail.gmail.com>
 <9a8748490608110325k25c340e2yac925eb226d1fe4f@mail.gmail.com>
 <20060814120032.E2698880@wobbly.melbourne.sgi.com>
 <9a8748490608140049t492742cx7f826a9f40835d71@mail.gmail.com>
 <20060815190343.A2743401@wobbly.melbourne.sgi.com> <20060815143709.GA21591@tuatara.stupidest.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: Nathan Scott <nathans@sgi.com>, Jesper Juhl <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com


>> Its not clear to me where the rename operation happens in all of
>> this - does rsync create a local, temporary copy of the file and
>> then rename it?
>
>Yes, this is normally how rsync does it.

If file already exists {
    foreach block {
        copy block either from disk or from the 
        source operand, whichever is never, to temp file
    }
}

When rsync catches a signal {
    move the tempfile to the original name
}





Jan Engelhardt
-- 
