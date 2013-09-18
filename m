Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EF4B77F37
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 12:43:23 -0500 (CDT)
Message-ID: <5239E638.4060908@sgi.com>
Date: Wed, 18 Sep 2013 12:43:20 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: v2 xfs directory unbalance assert test
References: <20130917192538.230164044@sgi.com>
	<CAJzLF9kacDY3gu7moxfFDRMTCxjQOzp_574Ojagk-kvNySedfg@mail.gmail.com>
In-Reply-To: <CAJzLF9kacDY3gu7moxfFDRMTCxjQOzp_574Ojagk-kvNySedfg@mail.gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 09/18/13 11:36, Michael L. Semon wrote:
> Looks good.  I tried it on an 11-GB partition with an unpatched git kernel
> 3.12.0 + xfs-oss/master, coupled with the latest git xfsprogs.  It took a
> reasonable amount of time, relatively speaking.  It put forth the error I was
> expecting, and a new 32-bit core is available upon your request but not
> uploaded yet.
>
> As for the assert itself, according to kgdb, these are the first, last, and
> BBTOB(bp->b_length) numbers for this run:
>
> 1544 4591 4096
>
> Good work!
>
> Michael

Thanks for the feedback.

last > BBTOB(bp->b_length) was also true for the longer version of the 
test. The only difference is that it happens earlier in the remove.

I take a closer look at the code.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
