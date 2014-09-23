Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2C1AE29DF9
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 15:15:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0BE8A304032
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 13:15:43 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [193.170.194.197]) by
	cuda.sgi.com with ESMTP id mZTA34kEFsGX1Baa (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Sep 2014 13:15:42 -0700 (PDT)
Date: Tue, 23 Sep 2014 22:15:40 +0200
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC v2] Unicode/UTF-8 support for XFS
Message-ID: <20140923201540.GB15923@two.firstfloor.org>
References: <20140918195650.GI19952@sgi.com>
	<87lhpbhfgg.fsf@tassilo.jf.intel.com>
	<20140922184145.GH4482@sgi.com>
	<20140922192958.GJ4120@two.firstfloor.org>
	<54219C17.3090104@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54219C17.3090104@sgi.com>
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
To: Olaf Weber <olaf@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, Ben Myers <bpm@sgi.com>, Andi Kleen <andi@firstfloor.org>, tinguely@sgi.com, xfs@oss.sgi.com

> You only pay the space cost if you use it, similar to the nls tables.

The way Linux module loading works these things are loaded by default,
not when someone needs it.

So no, you (or rather every unfortunate Linux XFS user) would pay it always,
unless you black list the module or rebuild the kernel.

> A big part of the table does decompositions for Korean: eliminating
> the Hangul decompositions removes 156320 bytes, leaving 89936 bytes.

Are there regular ranges or other redundancies in the Korean encoding
that could be used to compress paths?

Doing some basic research other people already answered this:

Please use the ICU or google tables referenced below. Apparently
smaller is possible too, but 40-50k seems more reasonable.

I'm just gonna make the claim that whatever performance you
get from a larger table is dwarfed by the cache miss overhead.

----

http://macchiato.com/unicode/normalization_footprint.htm

http://www.macchiato.com/unicode/nfc-faq

NFC normalization requires large tables, right?
Like many other cases, there is a tradeoff between size and performance.
You can use very small tables, at some cost in performance. (Even there,
the actual performance cost depends on how often normalization needs to
be invoked, as discussed above.)

To see an analysis of the situation, see Normalization Footprint. It is
a bit out of date, but gives a sense of the magnitude. For comparison,
ICU's optimized tables for NFC take 44 kB (UTF-16) and Google's
optimized tables for NFC take 46 kB (UTF-8).


-Andi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
