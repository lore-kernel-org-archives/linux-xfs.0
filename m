Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 659927F4E
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2014 15:57:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 022E6AC007
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2014 13:57:17 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	hgPmozFQ0JGotKGq for <xfs@oss.sgi.com>;
	Mon, 22 Sep 2014 13:57:16 -0700 (PDT)
Date: Tue, 23 Sep 2014 06:57:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/10] xfs: add trie generator and supporting code for
	UTF-8.
Message-ID: <20140922205714.GN4267@dastard>
References: <20140918195650.GI19952@sgi.com>
 <20140918201518.GJ4482@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140918201518.GJ4482@sgi.com>
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
Cc: linux-fsdevel@vger.kernel.org, tinguely@sgi.com, olaf@sgi.com, xfs@oss.sgi.com

On Thu, Sep 18, 2014 at 03:15:19PM -0500, Ben Myers wrote:
> From: Olaf Weber <olaf@sgi.com>
> 
> mkutf8data.c is the source for a program that generates utf8data.h, which
> contains the trie that utf8norm.c uses. The trie is generated from the
> Unicode 7.0.0 data files. The format of the utf8data[] table is described
> in utf8norm.c.
> 
> Supporting functions for UTF-8 normalization are in utf8norm.c with the
> header utf8norm.h. Two normalization forms are supported: nfkdi and nfkdicf.
> 
>   nfkdi:
>    - Apply unicode normalization form NFKD.
>    - Remove any Default_Ignorable_Code_Point.
> 
>   nfkdicf:
>    - Apply unicode normalization form NFKD.
>    - Remove any Default_Ignorable_Code_Point.
>    - Apply a full casefold (C + F).
> 
> For the purposes of the code, a string is valid UTF-8 if:
> 
>  - The values encoded are 0x1..0x10FFFF.
>  - The surrogate codepoints 0xD800..0xDFFFF are not encoded.
>  - The shortest possible encoding is used for all values.
> 
> The supporting functions work on null-terminated strings (utf8 prefix) and
> on length-limited strings (utf8n prefix).
> 
> Signed-off-by: Olaf Weber <olaf@sgi.com>
> 
> ---
> [v2: the trie is now separated into utf8norm.ko;
>      utf8version is now a function and exported;
>      introduced CONFIG_XFS_UTF8. -bpm]
> ---
>  fs/xfs/Kconfig               |    8 +
>  fs/xfs/Makefile              |    2 +-
>  fs/xfs/utf8norm/Makefile     |   37 +
>  fs/xfs/utf8norm/mkutf8data.c | 3239 ++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/utf8norm/utf8norm.c   |  649 +++++++++
>  fs/xfs/utf8norm/utf8norm.h   |  116 ++

Again, nothing XFS specific here. It's being built as a separate
module and the only thing that XFS uses are exported functions, so
it really should be generic library code....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
