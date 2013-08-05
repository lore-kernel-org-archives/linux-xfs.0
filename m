Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 012257F37
	for <xfs@oss.sgi.com>; Mon,  5 Aug 2013 10:24:47 -0500 (CDT)
Message-ID: <51FFC3BE.20801@sgi.com>
Date: Mon, 05 Aug 2013 10:24:46 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 22/49] xfs: split out on-disk transaction definitions
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-23-git-send-email-david@fromorbit.com>
	<51FFC353.4010805@sgi.com>
In-Reply-To: <51FFC353.4010805@sgi.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 08/05/13 10:22, Mark Tinguely wrote:
> On 07/19/13 01:44, Dave Chinner wrote:
>> From: Dave Chinner<dchinner@redhat.com>
>>
>> There's a bunch of definitions in xfs_trans.h that define on-disk
>> formats - transaction headers taht get written into the log, log
>> item type definitions, etc. Split out everything into a separate
>> file so that all which remains in xfs_trans.h are kernel only
>> definitions.
>>
>> Signed-off-by: Dave Chinner<dchinner@redhat.com>
>> ---
>
> There are a couple comments that now wrap because of new indentation,
> but they are fixed in a later patch.
>

my mistake they are removed, not added.

but ...

> The following entries deviates from kernel patch 07/49 in they are not
> moved from xfs_trans.h - never are:
>
>

...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
