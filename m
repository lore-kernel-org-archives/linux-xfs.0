Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 474167CA3
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 14:11:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 92D91AC005
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 12:11:34 -0700 (PDT)
Received: from na01-by2-obe.outbound.protection.outlook.com
	(mail-by2on0130.outbound.protection.outlook.com
	[207.46.100.130]) by cuda.sgi.com with ESMTP id
	IRSCI9F6UNcU3Qff (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 14 Jun 2016 12:11:32 -0700 (PDT)
Message-ID: <576056DB.5050701@hpe.com>
Date: Tue, 14 Jun 2016 15:11:23 -0400
From: Waiman Long <waiman.long@hpe.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH-tip 2/6] locking/rwsem: Enable optional count-based
	spinning on reader
References: <1465927959-39719-1-git-send-email-Waiman.Long@hpe.com>
	<1465927959-39719-3-git-send-email-Waiman.Long@hpe.com>
	<20160614182757.GA15903@linux-80c1.suse>
In-Reply-To: <20160614182757.GA15903@linux-80c1.suse>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, linux-ia64@vger.kernel.org, Scott J Norton <scott.norton@hpe.com>, Peter Zijlstra <peterz@infradead.org>, x86@kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ingo Molnar <mingo@redhat.com>, linux-alpha@vger.kernel.org, Douglas Hatch <doug.hatch@hpe.com>, Jason Low <jason.low2@hp.com>

On 06/14/2016 02:27 PM, Davidlohr Bueso wrote:
> On Tue, 14 Jun 2016, Waiman Long wrote:
>
>> This patch provides a way for the kernel code to designate specific
>> rwsems to be more aggressive in term of optimistic spinning that the
>> writers will continue to spin for some additional count-based time to
>> see if it can get the lock before sleeping. This aggressive spinning
>> mode should only be used on rwsems where the readers are unlikely to
>> go to sleep.
>
> Yikes, exposing this sort of thing makes me _very_ uneasy, not to mention
> the ad-hoc nature and its easiness to mess up. I'm not really for 
> this, even
> if it shows extraordinary performance boosts on benchmarks.
>
> Thanks,
> Davidlohr

I understand your concern. I will see if there is a way to autotune 
instead of using explicit enablement.

Cheers,
Longman

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
