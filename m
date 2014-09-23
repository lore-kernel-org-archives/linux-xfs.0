Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 74F227F3F
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 11:13:18 -0500 (CDT)
Message-ID: <54219C17.3090104@sgi.com>
Date: Tue, 23 Sep 2014 18:13:11 +0200
From: Olaf Weber <olaf@sgi.com>
MIME-Version: 1.0
Subject: Re: [RFC v2] Unicode/UTF-8 support for XFS
References: <20140918195650.GI19952@sgi.com>
	<87lhpbhfgg.fsf@tassilo.jf.intel.com>
	<20140922184145.GH4482@sgi.com>
	<20140922192958.GJ4120@two.firstfloor.org>
In-Reply-To: <20140922192958.GJ4120@two.firstfloor.org>
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
To: Andi Kleen <andi@firstfloor.org>, Ben Myers <bpm@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, tinguely@sgi.com, xfs@oss.sgi.com

On 22-09-14 21:29, Andi Kleen wrote:
>>> So 250kB bloat -- and what does this fix exactly?
>>
>> We're trying to address the size issue by only loading the module when
>
> I'm not sure this is really addressing it.

You only pay the space cost if you use it, similar to the nls tables.

>> it's needed, but yeah it's big.  Open to suggestions on how best to deal
>> with that.  I understand the sticker shock.
>
> I don't even understand why you need the whole table.
>
> You want to not compare some special symbols, and a few other symbols
> are equivalent to others.  But most symbols are only identical to themselves.
>
> Couldn't you have a much smaller table that only expresses
> the exceptions?

The trie tells you whether a given sequence of bytes is a UTF-8 encoded 
unicode codepoint, and if so, it gives the unicode version in which the 
codepoint was assigned an interpretation (if any), the canonical combining 
class (required for normalization), and the decomposition and case fold (if 
any).

A big part of the table does decompositions for Korean: eliminating the 
Hangul decompositions removes 156320 bytes, leaving 89936 bytes.

Hangul decomposition uses two or three unicode code points and a terminating 
NUL byte in a UTF-8 string. The code points each require a three-byte UTF-8 
sequence, so the total is 7 bytes per 2-part decomposition, and 10 bytes per 
3-part decomposition.

With that in mind, the 156320 additional bytes spent on Hangul are accounted 
for as follows:

  22344 bytes : 11172 leaves * 2 byte leaf size
   2793 bytes :   399 2-part decompositions at 7 bytes each
107730 bytes : 10773 3-part decompositions at 10 bytes each

This adds up to 132867 bytes of data, with the remainder, 23453 bytes, spent 
on additional internal trie nodes.

>> As far as telling the customer "don't do that", my guess is that they
>> would just go elsewhere.  There are several other options for
>> filesystems that support unicode.
>
> They could put some code into their user app that generates
> an unique representation.

This assumes a single app, and that they control the source of that app.

Olaf

-- 
Olaf Weber                 SGI               Phone:  +31(0)30-6696796
                            Veldzigt 2b       Fax:    +31(0)30-6696799
Technical Lead             3454 PW de Meern  Vnet:   955-6796
Storage Software           The Netherlands   Email:  olaf@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
