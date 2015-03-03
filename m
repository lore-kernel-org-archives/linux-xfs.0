Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DE4557F5F
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 00:56:19 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C96D98F8068
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 22:56:16 -0800 (PST)
Received: from mail-ie0-f177.google.com (mail-ie0-f177.google.com
	[209.85.223.177]) by cuda.sgi.com with ESMTP id
	jMGKaE0or3NRgeBm (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Mar 2015 22:56:15 -0800 (PST)
Received: by iebtr6 with SMTP id tr6so54611275ieb.7
	for <xfs@oss.sgi.com>; Mon, 02 Mar 2015 22:56:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150303052004.GM18360@dastard>
References: <20150302010413.GP4251@dastard>
	<CA+55aFzGFvVGD_8Y=jTkYwgmYgZnW0p0Fjf7OHFPRcL6Mz4HOw@mail.gmail.com>
	<20150303014733.GL18360@dastard>
	<CA+55aFw+7V9DfxBA2_DhMNrEQOkvdwjFFga5Y67-a6yVeAz+NQ@mail.gmail.com>
	<CA+55aFw+fb=Fh4M2wA4dVskgqN7PhZRGZS6JTMx4Rb1Qn++oaA@mail.gmail.com>
	<20150303052004.GM18360@dastard>
Date: Mon, 2 Mar 2015 22:56:14 -0800
Message-ID: <CA+55aFyczb5asoTwhzaJr1JdRi1epg1A6cFJgnzMMZj6U0gFWA@mail.gmail.com>
Subject: Re: [regression v4.0-rc1] mm: IPIs from TLB flushes causing
	significant performance degradation.
From: Linus Torvalds <torvalds@linux-foundation.org>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Matt B <jackdachef@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-mm <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>

On Mon, Mar 2, 2015 at 9:20 PM, Dave Chinner <david@fromorbit.com> wrote:
>>
>> But are those migrate-page calls really common enough to make these
>> things happen often enough on the same pages for this all to matter?
>
> It's looking like that's a possibility.

Hmm. Looking closer, commit 10c1045f28e8 already should have
re-introduced the "pte was already NUMA" case.

So that's not it either, afaik. Plus your numbers seem to say that
it's really "migrate_pages()" that is done more. So it feels like the
numa balancing isn't working right.

But I'm not seeing what would cause that in that commit. It really all
looks the same to me. The few special-cases it drops get re-introduced
later (although in a different form).

Mel, do you see what I'm missing?

                     Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
