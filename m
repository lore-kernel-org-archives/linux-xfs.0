Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 14BAD29DF8
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 15:28:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F33418F8037
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 13:28:20 -0700 (PDT)
Received: from mail-wg0-f48.google.com (mail-wg0-f48.google.com
	[74.125.82.48]) by cuda.sgi.com with ESMTP id 9U8udE5GI6osUG5G
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 17 Jun 2013 13:28:20 -0700 (PDT)
Received: by mail-wg0-f48.google.com with SMTP id f11so2793090wgh.27
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 13:28:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC2B=ZGm4W=oFY+8sWAefhH79qK5N7yma4qQh_AQaOGiQDUWhw@mail.gmail.com>
References: <CAC2B=ZFP_Fg34aFpk857stgB7MGcrYs9tybRS-ttw1CXNeU41Q@mail.gmail.com>
	<20130615020414.GB29338@dastard>
	<CAC2B=ZEUkd+ADnQLUKj9S-3rdo2=93WbW0tbLbwwHUvkh6v7Rw@mail.gmail.com>
	<CAC2B=ZGgr5WPWOEehHDHKekM8yHgQ3QS4HMzM8+j217AfEoPyQ@mail.gmail.com>
	<20130616001130.GE29338@dastard>
	<CAC2B=ZFZskLnp5baVJK+R1xrpOfTkr1QXpA9jyHvxfk5Wd4yDg@mail.gmail.com>
	<419435719.1662203.1371431489790.JavaMail.root@redhat.com>
	<20130617024603.GJ29338@dastard>
	<1597962722.1767244.1371447710942.JavaMail.root@redhat.com>
	<CAC2B=ZENLd7hoP=U08hyb6xFw6ye0nL5MMW+iDnTXTcoKCYEvA@mail.gmail.com>
	<20130617111347.GL29338@dastard>
	<CAC2B=ZGm4W=oFY+8sWAefhH79qK5N7yma4qQh_AQaOGiQDUWhw@mail.gmail.com>
Date: Mon, 17 Jun 2013 22:28:19 +0200
Message-ID: <CAAxjCEwhwqFhPbJsJGYUCqwF5qc7iZpNJpELOkR-9NNuPzFxBw@mail.gmail.com>
Subject: Re: definitions for /proc/fs/xfs/stat
From: Stefan Ring <stefanrin@gmail.com>
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
To: Mark Seger <mjseger@gmail.com>
Cc: Nathan Scott <nathans@redhat.com>, Linux fs XFS <xfs@oss.sgi.com>

> I asked around and people believe the cache is on the order of a few GB and
> the test ran I was intentionally large enough to overshadow any cache
> effects, running for about a minute and doing 100K 1K file creates.  The
> disk write data was close to a sustained 475MB/sec and would have easily
> filled the cache in the first handful of seconds which would have produced
> enough backpressure to slow down the write rate which it never did.

If a limited number of blocks gets written over and over, you won't
ever fill the cache.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
