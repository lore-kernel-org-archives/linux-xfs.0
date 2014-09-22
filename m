Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5A0C87F4E
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2014 14:30:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ED109AC004
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2014 12:30:01 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [193.170.194.197]) by
	cuda.sgi.com with ESMTP id uDna5WuBUHRCrmyB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 22 Sep 2014 12:30:00 -0700 (PDT)
Date: Mon, 22 Sep 2014 21:29:58 +0200
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC v2] Unicode/UTF-8 support for XFS
Message-ID: <20140922192958.GJ4120@two.firstfloor.org>
References: <20140918195650.GI19952@sgi.com>
	<87lhpbhfgg.fsf@tassilo.jf.intel.com>
	<20140922184145.GH4482@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140922184145.GH4482@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>, tinguely@sgi.com, olaf@sgi.com, xfs@oss.sgi.com

> > So 250kB bloat -- and what does this fix exactly?
> 
> We're trying to address the size issue by only loading the module when

I'm not sure this is really addressing it.

> it's needed, but yeah it's big.  Open to suggestions on how best to deal
> with that.  I understand the sticker shock.

I don't even understand why you need the whole table.

You want to not compare some special symbols, and a few other symbols
are equivalent to others.  But most symbols are only identical to themselves.

Couldn't you have a much smaller table that only expresses
the exceptions?

> As far as telling the customer "don't do that", my guess is that they
> would just go elsewhere.  There are several other options for
> filesystems that support unicode.

They could put some code into their user app that generates
an unique representation.

-Andi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
