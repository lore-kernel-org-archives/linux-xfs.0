Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9FE5Nud132354 for <xfs@oss.sgi.com>; Fri, 15 Oct 2010 09:05:23 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BEF53AC002
	for <xfs@oss.sgi.com>; Fri, 15 Oct 2010 07:06:30 -0700 (PDT)
Message-ID: <4CB85FE6.4040005@sgi.com>
Date: Fri, 15 Oct 2010 09:06:30 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfsrestore: change nrh_t to be 64 bits instead of 32
References: <20101012215322.749700656@sgi.com>	
	<20101012215400.639300973@sgi.com>
	<1287081912.2362.575.camel@doink>
In-Reply-To: <1287081912.2362.575.camel@doink>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: aelder@sgi.com
Cc: xfs@oss.sgi.com

On 10/14/2010 01:45 PM, Alex Elder wrote:
> On Tue, 2010-10-12 at 16:53 -0500, wkendall@sgi.com wrote:
>> plain text document attachment (namreg_64bit)
>> An nrh_t refers to a byte offset in a file containing all the pathname
>> components from a dump. At an average filename length of 20
>> characters, an nrh_t would overflow on a dump containing ~214 million
>> directory entries.
>
> This is a good change.  The value of an nrh_t is (opaquely)
> assigned as a 64-bit file offset, so it makes sense it should
> also be 64 bits.  Much better way of computing HDLMAX also.
>
> Do you know why NODESZ (= 48) is defined as a constant, and
> used separate from sizeof (struct node)?  Is the format of
> a node structure recorded persistently somewhere?  I don't
> know this code well enough to recognize whether the change
> to the node_t definition affects only in-memory structures.

The nodes are stored on disk in the event of a cumulative
restore (level 0 + level 1 + ...) or when resuming a previously
interrupted xfsrestore session. So persistent, but temporary.

There is no versioning of any of the data structures that
xfsrestore stores on disk. It's assumed that you're running
on a system with the same endianness, same page size and same
xfsrestore build.

At a minimum this should be documented in the man page. I'll
also look at what can be done about detecting this at runtime.

Bill


>
> Provided there are no ill effects due to changing the
> node struct to hold the 64-bit name registry handle:
>
> Reviewed-by: Alex Elder<aelder@sgi.com>
>
>>
>> Signed-off-by: Bill Kendall<wkendall@sgi.com>
>>
>> Index: xfsdump-kernel.org/restore/namreg.h
>> ===================================================================
>> --- xfsdump-kernel.org.orig/restore/namreg.h
>> +++ xfsdump-kernel.org/restore/namreg.h
>> @@ -26,8 +26,8 @@
>>
>>   /* nrh_t - handle to a registered name
>>    */
>> -typedef size32_t nrh_t;
>> -#define NRH_NULL	SIZE32MAX
>> +typedef size64_t nrh_t;
>> +#define NRH_NULL	SIZE64MAX
>>
>>
>>   /* namreg_init - creates the name registry. resync is TRUE if the
>> Index: xfsdump-kernel.org/restore/namreg.c
>> ===================================================================
>> --- xfsdump-kernel.org.orig/restore/namreg.c
>> +++ xfsdump-kernel.org/restore/namreg.c
>> @@ -72,26 +72,20 @@ typedef struct namreg_tran namreg_tran_t
>>    */
>>   #define CHKBITCNT		2
>>   #define	CHKBITSHIFT		( NBBY * sizeof( nrh_t ) - CHKBITCNT )
>> -#define	CHKBITLOMASK		( ( 1<<  CHKBITCNT ) - 1 )
>> +#define	CHKBITLOMASK		( ( 1ULL<<  CHKBITCNT ) - 1 )
>>   #define	CHKBITMASK		( CHKBITLOMASK<<  CHKBITSHIFT )
>>   #define CHKHDLCNT		CHKBITSHIFT
>> -#define CHKHDLMASK		( ( 1<<  CHKHDLCNT ) - 1 )
>> -#define CHKGETBIT( h )		( ( h>>  CHKBITSHIFT )&  CHKBITLOMASK )
>> -#define CHKGETHDL( h )		( h&  CHKHDLMASK )
>> -#define CHKMKHDL( c, h )	( ( ( c<<  CHKBITSHIFT )&  CHKBITMASK )	\
>> +#define CHKHDLMASK		( ( 1ULL<<  CHKHDLCNT ) - 1 )
>> +#define CHKGETBIT( h )		( ( (h)>>  CHKBITSHIFT )&  CHKBITLOMASK )
>> +#define CHKGETHDL( h )		( (h)&  CHKHDLMASK )
>> +#define CHKMKHDL( c, h )	( ( ( (c)<<  CHKBITSHIFT )&  CHKBITMASK )	\
>>   				  |					\
>> -				  ( h&  CHKHDLMASK ))
>> +				  ( (h)&  CHKHDLMASK ))
>>   #define HDLMAX			( ( off64_t )CHKHDLMASK )
>>
>>   #else /* NAMREGCHK */
>>
>> -#define HDLMAX			( ( ( off64_t )1			\
>> -				<<					\
>> -				    ( ( off64_t )NBBY			\
>> -				      *					\
>> -				      ( off64_t )sizeof( nrh_t )))	\
>> -				  -					\
>> -				  ( off64_t )2 ) /* 2 to avoid NRH_NULL */
>> +#define HDLMAX			( NRH_NULL - 1 )
>>
>>   #endif /* NAMREGCHK */
>>
>> Index: xfsdump-kernel.org/restore/tree.c
>> ===================================================================
>> --- xfsdump-kernel.org.orig/restore/tree.c
>> +++ xfsdump-kernel.org/restore/tree.c
>> @@ -166,19 +166,18 @@ typedef struct tran tran_t;
>>   #define NODESZ	48
>>
>>   struct node {
>> -	xfs_ino_t n_ino;		/* 8  8 ino */
>> -	nrh_t n_nrh;		/* 4 12 handle to name in name registry */
>> -	dah_t n_dah;		/* 4 16 handle to directory attributes */
>> -	nh_t n_hashh;		/* 4 20 hash array */
>> -	nh_t n_parh;		/* 4 24 parent */
>> -	nh_t n_sibh;		/* 4 28 sibling list */
>> -	nh_t n_sibprevh;	/* 4 32 prev sibling list - dbl link list */
>> -	nh_t n_cldh;		/* 4 36 children list */
>> -	nh_t n_lnkh;		/* 4 40 hard link list */
>> -	gen_t n_gen;		/* 2 42 generation count mod 0x10000 */
>> -	u_char_t n_flags;	/* 1 43 action and state flags */
>> -	u_char_t n_nodehkbyte;	/* 1 44 given to node abstraction */
>> -	int32_t pad;		/* 4 48 padding to 8 byte boundary */
>> +	xfs_ino_t n_ino;	/* 8  8 ino */
>> +	nrh_t n_nrh;		/* 8 16 handle to name in name registry */
>> +	dah_t n_dah;		/* 4 20 handle to directory attributes */
>> +	nh_t n_hashh;		/* 4 24 hash array */
>> +	nh_t n_parh;		/* 4 28 parent */
>> +	nh_t n_sibh;		/* 4 32 sibling list */
>> +	nh_t n_sibprevh;	/* 4 36 prev sibling list - dbl link list */
>> +	nh_t n_cldh;		/* 4 40 children list */
>> +	nh_t n_lnkh;		/* 4 44 hard link list */
>> +	gen_t n_gen;		/* 2 46 generation count mod 0x10000 */
>> +	u_char_t n_flags;	/* 1 47 action and state flags */
>> +	u_char_t n_nodehkbyte;	/* 1 48 given to node abstraction */
>>   };
>>
>>   typedef struct node node_t;
>> @@ -3393,9 +3392,9 @@ Node_free( nh_t *nhp )
>>   		namreg_del( np->n_nrh );
>>   		np->n_nrh = NRH_NULL;
>>   	}
>> -	if ( np->n_dah != NRH_NULL ) {
>> +	if ( np->n_dah != DAH_NULL ) {
>>   		dirattr_del( np->n_dah );
>> -		np->n_dah = NRH_NULL;
>> +		np->n_dah = DAH_NULL;
>>   	}
>>   	np->n_flags = 0;
>>   	np->n_parh = NH_NULL;
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
