Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9EBD27F61
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 23:26:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 72FC630406B
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 21:26:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id QCRH7GZm0XsSZPKH for <xfs@oss.sgi.com>;
	Tue, 01 Oct 2013 21:26:10 -0700 (PDT)
Message-ID: <524BA060.8090309@sandeen.net>
Date: Tue, 01 Oct 2013 23:26:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsrestore: fix multi stream support
References: <524AF8AE.5030300@sgi.com> <524B34D4.10807@sandeen.net>
	<524B4119.8020005@sgi.com> <524B4677.40200@sgi.com>
In-Reply-To: <524B4677.40200@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 10/1/13 5:02 PM, Rich Johnston wrote:

>> If partialmax != 0
>> (multi-stream) and no extents exist (entire file is a hole), is there
>> anything to restore? Nope so why call parial_reg().  If you do call it
>> you will not find anything to restore:
>>


Sorry for the scattered replies.

But simply getting here w/ no extents doesn't make us reach the comment
/* Should never get here */ below.

first:

        /* Search for a matching inode.  Gaps can exist so we must search
         * all entries. 
         */
        for (i=0; i < partialmax; i++ ) {
                if (persp->a.parrest[i].is_ino == ino) {
                        isptr = &persp->a.parrest[i];
                        break;
                }
        }

so first it tries to find to see if this inode has another stream (?)
which has partially restored it.

If not:

>> 8977         /* If not found, find a free one, fill it in and return */
>> 8978         if ( ! isptr ) {
>> 8979                 mlog(MLOG_NITTY | MLOG_NOLOCK,
>> 8980                         "partial_reg: no entry found for %llu\n",
>> ino);
>> 8981                 /* find a free one */
>> 8982                 for (i=0; i < partialmax; i++ ) {
>> 8983                         if (persp->a.parrest[i].is_ino == 0) {

find a stream which doesn't have is_ino set

>> 8984                                 int j;
>> 8985
>> 8986                                 isptr = &persp->a.parrest[i];
>> 8987                                 isptr->is_ino = ino;

set ino

>> 8988                                 persp->a.parrestcnt++;
>> 8989
>> 8990                                 /* Clear all endoffsets (this value is
>> 8991                                  * used to decide if an entry is used or
>> 8992                                  * not
>> 8993                                  */
>> 8994                                 for (j=0, bsptr=isptr->is_bs;
>> 8995                                      j < drivecnt; j++, bsptr++) {
>> 8996                                      bsptr->endoffset = 0;
>> 8997                                 }
>> 8998

etc, and go to found, and everything's fine:

>> 8999                                 goto found;
>> 9000                         }
>> 9001                 }
>> 9002
>> 9003                 /* Should never get here. */
>>
>> And we reach the dreaded comment above :)

the only way to reach that comment & the associated warning is if the first
loop I pasted finds no matching is_ino on any stream, but the 2nd loop finds
no is_ino == 0.  i.e. persp->a.parrest[i].is_ino for every stream ("i") has
a different, non-zero is_ino.  How can that happen?  (I'm not sure...)

-Eric 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
