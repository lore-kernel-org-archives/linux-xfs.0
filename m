Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 983057F4E
	for <xfs@oss.sgi.com>; Sun,  5 Oct 2014 16:52:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7865E30405F
	for <xfs@oss.sgi.com>; Sun,  5 Oct 2014 14:52:53 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	i9a34TZx4gFmdoUB for <xfs@oss.sgi.com>;
	Sun, 05 Oct 2014 14:52:48 -0700 (PDT)
Date: Mon, 6 Oct 2014 08:52:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/16] lib/utf8norm.c: reduce the size of utf8data[]
Message-ID: <20141005215244.GE12693@dastard>
References: <20141003214758.GY1865@sgi.com>
 <20141003215455.GC1865@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141003215455.GC1865@sgi.com>
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
Cc: linux-fsdevel@vger.kernel.org, olaf@sgi.com, xfs@oss.sgi.com

On Fri, Oct 03, 2014 at 04:54:55PM -0500, Ben Myers wrote:
> From: Olaf Weber <olaf@sgi.com>
> 
> Remove the Hangul decompositions from the utf8data trie, and do
> algorithmic decomposition to calculate them on the fly. To store
> the decomposition the caller of utf8lookup()/utf8nlookup() must
> provide a 12-byte buffer, which is used to synthesize a leaf with
> the decomposition. Trie size is reduced from 245kB to 90kB.
> 
> This change also contains a number of robustness fixes to the
> trie generator mkutf8data.c.

Please separate out the robustness fixes or merge them back into the
original patch. e.g. Bulk renaming of code like this:


>  static int
> -utf8key(unsigned int key, char keyval[])
> -{
> -	int keylen;
> -
> -	if (key < 0x80) {
> -		keyval[0] = key;
> -		keylen = 1;
> -	} else if (key < 0x800) {
> -		keyval[1] = key & UTF8_V_MASK;
> -		keyval[1] |= UTF8_N_BITS;
> -		key >>= UTF8_V_SHIFT;
....
> +utf8encode(char *str, unsigned int val)
> +{
> +	int len;
> +
> +	if (val < 0x80) {
> +		str[0] = val;
> +		len = 1;
> +	} else if (val < 0x800) {
> +		str[1] = val & UTF8_V_MASK;
> +		str[1] |= UTF8_N_BITS;
> +		val >>= UTF8_V_SHIFT;

Doesn't belong in a patch that introduces special hangul character
handling....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
