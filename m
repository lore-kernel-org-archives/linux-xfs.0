Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Apr 2008 20:47:43 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3G3khgt024563
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2008 20:46:44 -0700
From: Niv Sardi <xaiki@cxhome.ath.cx>
Subject: Re: [PATCH] split xfs_ioc_xattr
References: <20080319204014.GA23644@lst.de> <ncciqylf7q0.fsf@sgi.com>
	<20080414032940.GA10579@lst.de>
Date: Wed, 16 Apr 2008 13:47:13 +1000
In-Reply-To: <20080414032940.GA10579@lst.de> (Christoph Hellwig's message of
	"Mon, 14 Apr 2008 05:29:40 +0200")
Message-ID: <ncclk3ejwam.fsf@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig <hch@lst.de> writes:

> On Mon, Apr 14, 2008 at 01:14:47PM +1000, Niv Sardi wrote:
>> 
>> 
>> Christoph Hellwig <hch@lst.de> writes:
>> > The three subcases of xfs_ioc_xattr don't share any semantics and almost
>> > no code, so split it into three separate helpers.
>> >
>> > Signed-off-by: Christoph Hellwig <hch@lst.de>
>> 
>> Looks good to me, aren't the likely() unlinkely() deprecated ? shouldn't
>> they be killed ?
>
> Why would they be deprecated?

just an impression I had from on of Dave's comment to one of my patches:
« Can we kill all the likely() crap out of here? Modern hardware
  branch predictors are far better than static prediction hints. »

But it looks like a matter of taste…

I'll push it in.
-- 
Niv Sardi
