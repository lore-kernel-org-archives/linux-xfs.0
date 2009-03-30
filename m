Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2UIv96D209917 for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 13:57:24 -0500
Date: Mon, 30 Mar 2009 14:56:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: fix async io error handling in fsx
Message-ID: <20090330185624.GA21753@infradead.org>
References: <1238391050-14211-1-git-send-email-felixb@sgi.com>
	<20090330175451.GA1041@infradead.org>
	<2466E954-2122-4FEB-B3DA-8F06AA22BAB7@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2466E954-2122-4FEB-B3DA-8F06AA22BAB7@sgi.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Mar 30, 2009 at 01:53:21PM -0500, Felix Blyakher wrote:
>>> +		/*
>>> +		 * The b0rked libaio defines event.res as signed.
>>> +		 * However the kernel strucuture has it unsigned,
>>> +		 * and it's used to pass negated error value.
>>> +		 * Till the library is fixed use the temp var.
>>> +		 */
>>
>> This comment seems backwards to the patch description and the actual
>> code.
>
> Hmm, not really.
> If the libaio library would be correct (do you know whom to talk
> to and where to send a patch), the code would look like this:

Yeah, but shouldn't the comment read:

	/*
	 * The b0rked libaio defines event.res as *unsigned*.
	 * However the kernel strucuture has it *signed*,
	 * and it's used to pass negated error value.
	 * Till the library is fixed use the temp var.
	 */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
