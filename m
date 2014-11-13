Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1330E7F37
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 12:00:11 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F38BB304064
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 10:00:10 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id nPr60eHK33POC8PN for <xfs@oss.sgi.com>;
	Thu, 13 Nov 2014 10:00:09 -0800 (PST)
Message-ID: <5464F1A7.20008@sandeen.net>
Date: Thu, 13 Nov 2014 12:00:07 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/9 V2] xfsdump: Fix overflow of "question" string in
	Media_prompt_erase()
References: <1415818638-32700-1-git-send-email-sandeen@redhat.com>	<1415818638-32700-3-git-send-email-sandeen@redhat.com>	<5463AF7A.8040006@sandeen.net>
	<20141113173813.GA9959@infradead.org>
In-Reply-To: <20141113173813.GA9959@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

On 11/13/14 11:38 AM, Christoph Hellwig wrote:
>> +	asprintf( &question, 
>> +		 "overwrite data on media in drive %u?\n",
>>  		 (unsigned int)drivep->d_index );
> 
> Where is the error handling?

Well, ok.

The error handling ahead of this is crap; if the
function returns !ok, we change the media:

                                ok = Media_prompt_overwrite( drivep );
                                if ( intr_allowed && cldmgr_stop_requested( )) {
                                        return RV_INTR;
                                }
                                if ( ! ok ) {
                                        goto changemedia;
                                }

I don't want to try to understand and rework all the ways we can
back out of this if we don't have ~100 bytes available.

So, what would you prefer:

I could make a 110-byte array, and snprintf max 110 bytes to it.
Or I could asprintf, and exit the whole program if it fails.

I'm not trying to make xfsdump perfect, I'm trying to make it
suck less. ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
