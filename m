Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E2B227F3F
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 06:07:43 -0500 (CDT)
Message-ID: <5422A5F8.5040703@sgi.com>
Date: Wed, 24 Sep 2014 13:07:36 +0200
From: Olaf Weber <olaf@sgi.com>
MIME-Version: 1.0
Subject: Re: [RFC v2] Unicode/UTF-8 support for XFS
References: <20140918195650.GI19952@sgi.com>
	<87lhpbhfgg.fsf@tassilo.jf.intel.com>
	<20140922184145.GH4482@sgi.com>
	<20140922192958.GJ4120@two.firstfloor.org>
	<54219C17.3090104@sgi.com>
	<20140923201540.GB15923@two.firstfloor.org>
In-Reply-To: <20140923201540.GB15923@two.firstfloor.org>
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
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-fsdevel@vger.kernel.org, Ben Myers <bpm@sgi.com>, tinguely@sgi.com, xfs@oss.sgi.com

On 23-09-14 22:15, Andi Kleen wrote:

>> A big part of the table does decompositions for Korean: eliminating
>> the Hangul decompositions removes 156320 bytes, leaving 89936 bytes.
>
> Are there regular ranges or other redundancies in the Korean encoding
> that could be used to compress paths?

Yes, though at the expense of more complicated code and interfaces. in 
particular, lookups that want a normalized string would need to provide a 
10-byte buffer to store it in.

> Doing some basic research other people already answered this:
>
> Please use the ICU or google tables referenced below. Apparently
> smaller is possible too, but 40-50k seems more reasonable.

Riffing off the http://macchiato.com/unicode/normalization_footprint.htm 
link you provided, looking at the NFKD case. For Unicode 3.0.0 that link 
gives 3483 NFKD normalizations (exlcuding Hangul), and gives 26,918 bytes as 
the size of a simple lookup table (key/offset pairs, with the offset 
pointing into a string table).

In Unicode 7.0.0 I count 5721 NFKD normalizations (again excluding Hangul). 
  As NUL-terminated UTF-8 strings these take 23390 bytes.  Using a 
key-offset table I need 3 bytes for the key (code points are 21 bits) and 2 
bytes for an offset. Total is 5721 * (3 + 2) + 23390 = 51995 bytes. Stealing 
4 bits from the key field and 1 from the offset to store the size of the 
normalized string I can remove the NUL bytes from the string table and 
reduce total size to 46274 bytes.

The trie implementation used here would use 66283 bytes to store the same 
information, but it also provides unicode version and canonical combining 
class for all codepoints. There are 10268 leaves in this case, with the size 
of each leaf being 1 byte for version, one for ccc, plus the size of the 
decomposition, if any. So a quick estimate on the space used just for the 
NFKD data is some 45747 bytes.

I'm pretty certain that a trie that only stores the NFKD would be smaller 
than 45747 bytes as it would need fewer internal nodes, but didn't do the 
experiment. But as you can see, for just the NFKD part and excluding Hangul, 
the size of the trie is within the ballpark of the numbers you gave.

Case folding adds a partial trie that forwards to the "main" trie for parts 
that are identical. This adds 2672 extra leaves and 20171 extra bytes. The 
data for the normalization corrections adds another 3328 bytes. With a bit 
of rounding, total size comes to 89840 bytes.

 > I'm just gonna make the claim that whatever performance you
 > get from a larger table is dwarfed by the cache miss overhead.

That's possible, though it seems plausible you'd only suffer from this doing 
actual Hangul decomposition: all the data related to this (trie nodes, trie 
leaves, and strings) sits in one contiguous block in memory.

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
