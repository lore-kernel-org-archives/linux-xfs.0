Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 38C827F61
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 20:37:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0A1A4304048
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 18:37:49 -0800 (PST)
Received: from mail-ie0-f169.google.com (mail-ie0-f169.google.com
	[209.85.223.169]) by cuda.sgi.com with ESMTP id
	wPieCXabFk2xfaRY (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Mar 2015 18:37:48 -0800 (PST)
Received: by iecrd18 with SMTP id rd18so53428679iec.8
	for <xfs@oss.sgi.com>; Mon, 02 Mar 2015 18:37:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+55aFw+7V9DfxBA2_DhMNrEQOkvdwjFFga5Y67-a6yVeAz+NQ@mail.gmail.com>
References: <20150302010413.GP4251@dastard>
	<CA+55aFzGFvVGD_8Y=jTkYwgmYgZnW0p0Fjf7OHFPRcL6Mz4HOw@mail.gmail.com>
	<20150303014733.GL18360@dastard>
	<CA+55aFw+7V9DfxBA2_DhMNrEQOkvdwjFFga5Y67-a6yVeAz+NQ@mail.gmail.com>
Date: Mon, 2 Mar 2015 18:37:47 -0800
Message-ID: <CA+55aFw+fb=Fh4M2wA4dVskgqN7PhZRGZS6JTMx4Rb1Qn++oaA@mail.gmail.com>
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
To: Dave Chinner <david@fromorbit.com>, Mel Gorman <mgorman@suse.de>
Cc: Matt B <jackdachef@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>

On Mon, Mar 2, 2015 at 6:22 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> There might be some other case where the new "just change the
> protection" doesn't do the "oh, but it the protection didn't change,
> don't bother flushing". I don't see it.

Hmm. I wonder.. In change_pte_range(), we just unconditionally change
the protection bits.

But the old numa code used to do

    if (!pte_numa(oldpte)) {
        ptep_set_numa(mm, addr, pte);

so it would actually avoid the pte update if a numa-prot page was
marked numa-prot again.

But are those migrate-page calls really common enough to make these
things happen often enough on the same pages for this all to matter?

Odd.

So it would be good if your profiles just show "there's suddenly a
*lot* more calls to flush_tlb_page() from XYZ" and the culprit is
obvious that way..

                       Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
