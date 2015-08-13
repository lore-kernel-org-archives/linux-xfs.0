Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 73D117F50
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 02:06:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 02F07AC004
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 00:06:24 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id l0xLVcbBWBsjxawp (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Aug 2015 00:06:23 -0700 (PDT)
Date: Thu, 13 Aug 2015 00:06:23 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: Fix attr leaf block definition
Message-ID: <20150813070623.GA15348@infradead.org>
References: <1439387594-8747-1-git-send-email-jack@suse.com>
	<20150813012940.GO3902@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150813012940.GO3902@dastard>
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
Cc: xfs@oss.sgi.com, Jan Kara <jack@suse.com>

On Thu, Aug 13, 2015 at 11:29:40AM +1000, Dave Chinner wrote:
> This situation is the same - the xfs_attr_leafblock variables are
> only accessed by helper functions that return pointers. Can you
> modify the declaration to match the xfs_attr3_leafblock declaration?

Yes, I think that's the best approach.

> FWIW, if gcc 4.8.3 is producing non-working xfsprogs code due to
> these declarations, then I have to wonder if it is also generating
> bad kernel code. There's also a bigger issue: XFS uses the array[1]
> declaration technique for several variable size structures across
> the code base. Are all of these declarations resulting in gcc 4.8.3
> doing the wrong thing? Or does the problem only manifest when the
> array definition is followed by more variables?
> 
> If the problem does not manifest in the second case, why is this
> inconsistency not considered a broken compiler optimisation?
> 
> Hence I'm guessing we need to convert all the "array[1]"
> definitions for variable sized arrays in XFS structures to "array[]"
> to avoid gcc making wrong assumptions about the code? i.e: all of
> these in kernel space:

C compilers are moving away from beeing the portable assemblers
we (ab)use them for, and add all kinds of optimizations that
are questionable from our POV and sometimes make behavior illegal
that's required for low level programming.

That being said a one element array in the middle of a structure
is totally bogus, and I wondered what crack the authors of the
code smoked when I killed most of these during the initial btree
refactoring and CRC work.  That's unlike a one element array
at the end of a structure which was the only way to do a variable
length array before the [0] GNU extention and [] from C99.  
I don't expect a compiler to trip over those any time soon, but
I'd still prefer to convert them to the modern portable form.

I suspect the reason why you can I haven't seen this bug is tht the
kernel uses very conservative optimization flags, while Jan probably
used some more aggressive SuSE default to compile an xfsprogs
package.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
