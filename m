Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2A2DF7CA1
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 13:28:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DCB988F8035
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 11:28:12 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id DgmcX5jD76eN0XbC (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 14 Jun 2016 11:28:10 -0700 (PDT)
Date: Tue, 14 Jun 2016 11:27:57 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [RFC PATCH-tip 2/6] locking/rwsem: Enable optional count-based
	spinning on reader
Message-ID: <20160614182757.GA15903@linux-80c1.suse>
References: <1465927959-39719-1-git-send-email-Waiman.Long@hpe.com>
	<1465927959-39719-3-git-send-email-Waiman.Long@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1465927959-39719-3-git-send-email-Waiman.Long@hpe.com>
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
To: Waiman Long <Waiman.Long@hpe.com>
Cc: linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, linux-ia64@vger.kernel.org, Scott J Norton <scott.norton@hpe.com>, Peter Zijlstra <peterz@infradead.org>, x86@kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ingo Molnar <mingo@redhat.com>, linux-alpha@vger.kernel.org, Douglas Hatch <doug.hatch@hpe.com>, Jason Low <jason.low2@hp.com>

On Tue, 14 Jun 2016, Waiman Long wrote:

>This patch provides a way for the kernel code to designate specific
>rwsems to be more aggressive in term of optimistic spinning that the
>writers will continue to spin for some additional count-based time to
>see if it can get the lock before sleeping. This aggressive spinning
>mode should only be used on rwsems where the readers are unlikely to
>go to sleep.

Yikes, exposing this sort of thing makes me _very_ uneasy, not to mention
the ad-hoc nature and its easiness to mess up. I'm not really for this, even
if it shows extraordinary performance boosts on benchmarks.

Thanks,
Davidlohr

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
