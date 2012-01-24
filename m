Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0OHwJK5060190 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 11:58:19 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id U1CPFzxhToQfZJJv for
	<xfs@oss.sgi.com>; Tue, 24 Jan 2012 09:58:18 -0800 (PST)
Message-ID: <4F1EF134.7000808@redhat.com>
Date: Tue, 24 Jan 2012 11:58:12 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: check for size parsing errors in xfs_quota
References: <4F1D9989.8060808@redhat.com> <20120124175612.GH9853@infradead.org>
In-Reply-To: <20120124175612.GH9853@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: James Lawrie <james@jdlawrie.co.uk>, xfs-oss <xfs@oss.sgi.com>

On 1/24/12 11:56 AM, Christoph Hellwig wrote:
>> -		v = (__uint64_t)cvtnum(blocksize, sectorsize, s);
>> -		*value = v >> 9;	/* syscalls use basic blocks */
>> +		v = cvtnum(blocksize, sectorsize, s);
>> +		if (v == -1LL) {
>> +			fprintf(stderr, _("%s: Error: could not parse size %s.\n"), progname, s);
>> +			return 0;
>> +		}
>> +		*value = (__uint64_t)v >> 8;	/* syscalls use basic blocks */
> 
> Why do you replace the shift by nine with a shift by 8?

yeargh, NFI - vi gone wild?

> Also please don't introduce new overly long lines, just move the
> translated string to a line of its own, indented by a single tab similar
> to how we do it in most new xfs/xfsprogs code.

Ok, sure, sorry.  TBH I noticed it but there was such a long line below
I didn't worry.  Will resend.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
