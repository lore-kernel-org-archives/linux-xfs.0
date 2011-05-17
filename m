Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4HGTYrP192092 for <xfs@oss.sgi.com>; Tue, 17 May 2011 11:29:34 -0500
Received: from sycorax.lbl.gov (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5F6BD45E5B8
	for <xfs@oss.sgi.com>; Tue, 17 May 2011 09:29:32 -0700 (PDT)
Received: from sycorax.lbl.gov (sycorax.lbl.gov [128.3.11.121]) by
	cuda.sgi.com with ESMTP id C45TQkaG9f228EPH for
	<xfs@oss.sgi.com>; Tue, 17 May 2011 09:29:32 -0700 (PDT)
From: Alex Romosan <romosan@sycorax.lbl.gov>
Subject: Re: system hangs 2.6.39-rc7 xfs related
References: <87ei3y7aei.fsf@sycorax.lbl.gov>
	<20110517155018.GB17735@infradead.org>
Date: Tue, 17 May 2011 09:29:22 -0700
In-Reply-To: <20110517155018.GB17735@infradead.org> (message from Christoph
	Hellwig on Tue, 17 May 2011 11:50:19 -0400)
Message-ID: <87r57xl28t.fsf@sycorax.lbl.gov>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Christoph Hellwig <hch@infradead.org> writes:

> On Mon, May 16, 2011 at 11:44:37AM -0700, Alex Romosan wrote:
>> my system just sort of locked up and everything that's trying to write
>> to disk is stuck. dmesg gives me this:
>
> This looks quite similar to a few other XFS issues in the .39 cycle.
> Can you upgrade to latest Linus HEAD which has fixes for these similar
> issues and see if that fixes your issues?

i'll give it a try, but it might take some time before i can figure out
if the fixes work as i still haven't figured out a way to reproduce
this consistently (having a lot of processes write to disk at the same
time increases the likelihood of it happening but doesn't guarantee it).

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
