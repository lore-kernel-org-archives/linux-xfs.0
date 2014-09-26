Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D82CC7FBC
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 09:06:28 -0500 (CDT)
Message-ID: <542572DE.6070106@sgi.com>
Date: Fri, 26 Sep 2014 16:06:22 +0200
From: Olaf Weber <olaf@sgi.com>
MIME-Version: 1.0
Subject: Re: [RFC v2] Unicode/UTF-8 support for XFS
References: <20140918195650.GI19952@sgi.com>
	<87lhpbhfgg.fsf@tassilo.jf.intel.com>
	<20140922184145.GH4482@sgi.com>
	<20140922192958.GJ4120@two.firstfloor.org>
	<54219C17.3090104@sgi.com>
	<20140923201540.GB15923@two.firstfloor.org>
	<5422A5F8.5040703@sgi.com>
In-Reply-To: <5422A5F8.5040703@sgi.com>
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

On 24-09-14 13:07, Olaf Weber wrote:
> On 23-09-14 22:15, Andi Kleen wrote:
>
>>> A big part of the table does decompositions for Korean: eliminating
>>> the Hangul decompositions removes 156320 bytes, leaving 89936 bytes.
>>
>> Are there regular ranges or other redundancies in the Korean encoding
>> that could be used to compress paths?
>
> Yes, though at the expense of more complicated code and interfaces. in
> particular, lookups that want a normalized string would need to provide a
> 10-byte buffer to store it in.

I spent some time working on this, and the effect on the lookup code isn't 
as bad as I'd thought. The updated code should be posted early next week.

With this change, the table size for the full trie becomes 89952 bytes. Of 
this, 66400 bytes are spent on the NFKD + Ignorables, an additional 20992 
bytes on NFDK + Ignorables + Case Fold. The remainder, 2560 bytes, are 
additional info for older unicode versions.

Note that the NFDK + Ignorables + Case Fold trie forwards to the NFKD + 
Ignorables where they overlap. A stand-alone version would be 71750 bytes.

As noted before these tables also contain the Canonical Combining Class and 
unicode version information for the code points. The latter allows for 
supporting multiple unicode versions using a single combined table.

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
