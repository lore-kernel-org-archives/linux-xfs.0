Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 76EEE7F37
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 15:32:37 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0C1E3AC006
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 13:32:33 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cBFjzHEgOcltBnYn for
	<xfs@oss.sgi.com>; Mon, 06 Jan 2014 13:32:32 -0800 (PST)
Message-ID: <52CB20ED.1010705@redhat.com>
Date: Mon, 06 Jan 2014 15:32:29 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: kill lib/random.c
References: <1389038323-8304-1-git-send-email-jbacik@fb.com>
In-Reply-To: <1389038323-8304-1-git-send-email-jbacik@fb.com>
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
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 1/6/14, 1:58 PM, Josef Bacik wrote:
> I was trying to reproduce something with fsx and I noticed that no matter what
> seed I set I was getting the same file.  Come to find out we are overloading
> random() with our own custom horribleness for some unknown reason.  So nuke the
> damn thing from orbit and rely on glibc's random().  With this fix the -S option
> actually does something with fsx.  Thanks,

Hm, old comments seem to indicate that this was done <handwave> to make random
behave the same on different architectures (i.e. same result from same seed,
I guess?)  I . . . don't know if that is true of glibc's random(), is it?

I'd like to dig into the history just a bit before we yank this, just to
be sure.

-Eric

> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  lib/Makefile |   3 +-
>  lib/random.c | 240 -----------------------------------------------------------
>  2 files changed, 1 insertion(+), 242 deletions(-)
>  delete mode 100644 lib/random.c
> 
> diff --git a/lib/Makefile b/lib/Makefile
> index c7348ce..a9e32bc 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -16,8 +16,7 @@ LT_AGE = 0
>  #
>  CFILES = dataascii.c databin.c datapid.c file_lock.c forker.c \
>  	pattern.c open_flags.c random_range.c string_to_tokens.c \
> -	str_to_bytes.c tlibio.c write_log.c \
> -	random.c
> +	str_to_bytes.c tlibio.c write_log.c
>  
>  default: depend $(LTLIBRARY)
>  
> diff --git a/lib/random.c b/lib/random.c
> deleted file mode 100644
> index eb23cd9..0000000
> --- a/lib/random.c
> +++ /dev/null
> @@ -1,240 +0,0 @@
> -/**************************************************************************
> - *
> - * random.c -- pseudo random number generator
> - * Copyright (C) 1994  Chris Wallace (csw@bruce.cs.monash.edu.au)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> - *
> - *
> - **************************************************************************/
> -
> -#include <sys/types.h>
> -
> -/*
> - * modified by dxm@sgi.com so that this file acts as a drop in replacement
> - * for srandom and random.
> - */
> -
> -/*
> - *	A random number generator called as a function by
> - *	random (iseed)	or	irandm (iseed)
> - *	The parameter should be a pointer to a 2-element int32_t vector.
> - *	The first function returns a double uniform in 0 .. 1.
> - *	The second returns a int32_t integer uniform in 0 .. 2**31-1
> - *	Both update iseed[] in exactly the same way.
> - *	iseed[] must be a 2-element integer vector.
> - *	The initial value of the second element may be anything.
> - *
> - *	The period of the random sequence is 2**32 * (2**32-1)
> - *	The table mt[0:127] is defined by mt[i] = 69069 ** (128-i)
> - */
> -
> -#define MASK ((int32_t) 593970775)
> -/*	or in hex, 23674657	*/
> -
> -#define SCALE ((double) 1.0 / (1024.0 * 1024.0 * 1024.0 * 2.0))
> -/*	i.e. 2 to power -31	*/
> -
> -static int32_t mt [128] =   {
> -      902906369,
> -     2030498053,
> -     -473499623,
> -     1640834941,
> -      723406961,
> -     1993558325,
> -     -257162999,
> -    -1627724755,
> -      913952737,
> -      278845029,
> -     1327502073,
> -    -1261253155,
> -      981676113,
> -    -1785280363,
> -     1700077033,
> -      366908557,
> -    -1514479167,
> -     -682799163,
> -      141955545,
> -     -830150595,
> -      317871153,
> -     1542036469,
> -     -946413879,
> -    -1950779155,
> -      985397153,
> -      626515237,
> -      530871481,
> -      783087261,
> -    -1512358895,
> -     1031357269,
> -    -2007710807,
> -    -1652747955,
> -    -1867214463,
> -      928251525,
> -     1243003801,
> -    -2132510467,
> -     1874683889,
> -     -717013323,
> -      218254473,
> -    -1628774995,
> -    -2064896159,
> -       69678053,
> -      281568889,
> -    -2104168611,
> -     -165128239,
> -     1536495125,
> -      -39650967,
> -      546594317,
> -     -725987007,
> -     1392966981,
> -     1044706649,
> -      687331773,
> -    -2051306575,
> -     1544302965,
> -     -758494647,
> -    -1243934099,
> -      -75073759,
> -      293132965,
> -    -1935153095,
> -      118929437,
> -      807830417,
> -    -1416222507,
> -    -1550074071,
> -      -84903219,
> -     1355292929,
> -     -380482555,
> -    -1818444007,
> -     -204797315,
> -      170442609,
> -    -1636797387,
> -      868931593,
> -     -623503571,
> -     1711722209,
> -      381210981,
> -     -161547783,
> -     -272740131,
> -    -1450066095,
> -     2116588437,
> -     1100682473,
> -      358442893,
> -    -1529216831,
> -     2116152005,
> -     -776333095,
> -     1265240893,
> -     -482278607,
> -     1067190005,
> -      333444553,
> -       86502381,
> -      753481377,
> -       39000101,
> -     1779014585,
> -      219658653,
> -     -920253679,
> -     2029538901,
> -     1207761577,
> -    -1515772851,
> -     -236195711,
> -      442620293,
> -      423166617,
> -    -1763648515,
> -     -398436623,
> -    -1749358155,
> -     -538598519,
> -     -652439379,
> -      430550625,
> -    -1481396507,
> -     2093206905,
> -    -1934691747,
> -     -962631983,
> -     1454463253,
> -    -1877118871,
> -     -291917555,
> -    -1711673279,
> -      201201733,
> -     -474645415,
> -      -96764739,
> -    -1587365199,
> -     1945705589,
> -     1303896393,
> -     1744831853,
> -      381957665,
> -     2135332261,
> -      -55996615,
> -    -1190135011,
> -     1790562961,
> -    -1493191723,
> -      475559465,
> -          69069
> -		};
> -
> -double 
> -_random (int32_t is [2])
> -{
> -	int32_t it, leh, nit;
> -
> -	it = is [0];
> -	leh = is [1];
> -	if (it <= 0)	
> -		it = (it + it) ^ MASK;
> -	else
> -		it = it + it;
> -	nit = it - 1;
> -/*	to ensure all-ones pattern omitted    */
> -	leh = leh * mt[nit & 127] + nit;
> -	is [0] = it;    is [1] = leh;
> -	if (leh < 0) leh = ~leh;
> -	return (SCALE * ((int32_t) (leh | 1)));
> -}
> -
> -
> -
> -int32_t 
> -_irandm (int32_t is [2])
> -{
> -	int32_t it, leh, nit;
> -
> -	it = is [0];
> -	leh = is [1];
> -	if (it <= 0)	
> -		it = (it + it) ^ MASK;
> -	else
> -		it = it + it;
> -	nit = it - 1;
> -/*	to ensure all-ones pattern omitted    */
> -	leh = leh * mt[nit & 127] + nit;
> -	is [0] = it;    is [1] = leh;
> -	if (leh < 0) leh = ~leh;
> -	return (leh);
> -}
> -
> -/*
> - * make this a drop in replacement for random and srandom
> - *
> - * XXX not thread safe I guess.
> - */
> -
> -static int32_t saved_seed[2];
> -
> -long random(void)
> -{
> -    return _irandm(saved_seed);
> -}
> -
> -void srandom(unsigned seed)
> -{
> -    saved_seed[0]=seed;
> -    saved_seed[1]=0;
> -    _irandm(saved_seed);
> -}
> -
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
