Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A931D7F53
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 11:21:29 -0500 (CDT)
Message-ID: <5335A188.4060400@sgi.com>
Date: Fri, 28 Mar 2014 11:21:28 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfs: remove efi from AIL in log recovery error
References: <20140325195733.510384972@sgi.com>
	<20140325195819.638326569@sgi.com>
	<20140328152434.GB21961@bfoster.bfoster> <53359812.3090806@sgi.com>
	<20140328160719.GA15537@bfoster.bfoster>
In-Reply-To: <20140328160719.GA15537@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 03/28/14 11:07, Brian Foster wrote:
> On Fri, Mar 28, 2014 at 10:41:06AM -0500, Mark Tinguely wrote:
>> On 03/28/14 10:24, Brian Foster wrote:
>>> On Tue, Mar 25, 2014 at 03:06:34PM -0500, Mark Tinguely wrote:

...

>>> Hi Mark,
>>>
>>> If we hit the scenario where we start skipping EFIs after an error, is
>>> the equivalent unpin() call from process_efi() not necessary on the
>>> subsequent EFIs?
>>>
>>> Brian
>>
>> yes, good catch. They will have to be decremented twice. something like:
>> +		if (!error)
>> +			error = xlog_recover_process_efi(log->l_mp, efip);
>> +		else
>> +			xfs_efi_item_unpin(&efip->efi_item, 0);
>> +		if (error)
>> ...
>>
>
> Ok, looks reasonable to me. An extra sentence or two in the previous
> comment to explain what's going on there would be nice as well. ;)
>
> Brian

Probably will flip the if statement logic, but a comment is also a good 
idea. Thank-you for the feed back.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
