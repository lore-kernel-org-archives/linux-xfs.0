Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 76D1C7F61
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 20:22:35 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E2808AC002
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 18:22:31 -0800 (PST)
Received: from mail-ie0-f180.google.com (mail-ie0-f180.google.com
	[209.85.223.180]) by cuda.sgi.com with ESMTP id
	YIpvkc6qCryk5WOJ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Mar 2015 18:22:30 -0800 (PST)
Received: by iecvy18 with SMTP id vy18so53378574iec.6
	for <xfs@oss.sgi.com>; Mon, 02 Mar 2015 18:22:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150303014733.GL18360@dastard>
References: <20150302010413.GP4251@dastard>
	<CA+55aFzGFvVGD_8Y=jTkYwgmYgZnW0p0Fjf7OHFPRcL6Mz4HOw@mail.gmail.com>
	<20150303014733.GL18360@dastard>
Date: Mon, 2 Mar 2015 18:22:29 -0800
Message-ID: <CA+55aFw+7V9DfxBA2_DhMNrEQOkvdwjFFga5Y67-a6yVeAz+NQ@mail.gmail.com>
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
Cc: Matt B <jackdachef@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>

On Mon, Mar 2, 2015 at 5:47 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> Anyway, the difference between good and bad is pretty clear, so
> I'm pretty confident the bisect is solid:
>
> 4d9424669946532be754a6e116618dcb58430cb4 is the first bad commit

Well, it's the mm queue from Andrew, so I'm not surprised. That said,
I don't see why that particular one should matter.

Hmm. In your profiles, can you tell which caller of "flush_tlb_page()"
 changed the most? The change from "mknnuma" to "prot_none" *should*
be 100% equivalent (both just change the page to be not-present, just
set different bits elsewhere in the pte), but clearly something
wasn't.

Oh. Except for that special "huge-zero-page" special case that got
dropped, but that got re-introduced in commit e944fd67b625.

There might be some other case where the new "just change the
protection" doesn't do the "oh, but it the protection didn't change,
don't bother flushing". I don't see it.

                          Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
