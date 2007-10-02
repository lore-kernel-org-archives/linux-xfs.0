Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 02 Oct 2007 09:41:54 -0700 (PDT)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com [208.42.117.202])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l92GfmoP006083
	for <xfs@oss.sgi.com>; Tue, 2 Oct 2007 09:41:50 -0700
Message-ID: <470274BF.7070702@thebarn.com>
Date: Tue, 02 Oct 2007 11:41:35 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: REVIEW: xfs_reno
References: <op.tzj549h63jf8g2@pc-bnaujok.melbourne.sgi.com> <20071002090216.GA22721@infradead.org> <20071002091951.GE995458@sgi.com>
In-Reply-To: <20071002091951.GE995458@sgi.com>
Content-Type: multipart/mixed;
 boundary="------------080904050700000906050104"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

This is a multi-part message in MIME format.
--------------080904050700000906050104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

David Chinner wrote:
> On Tue, Oct 02, 2007 at 10:02:16AM +0100, Christoph Hellwig wrote:
>   
>> On Tue, Oct 02, 2007 at 05:08:59PM +1000, Barry Naujok wrote:
>>     
>>> The attached tool allows an inode64 filesystem to be converted to inode32.
>>> For this to work, the filesystem has to be mounted inode32 before it's run.
>>>
>>> I'm not sure if there is any packaging changes required.
>>>       
>> Together with the stop allocating from specific AGs patch this should be
>> 90% towards an xfs_shrinkfs, right?
>>     
>
> Well, this just moves the inodes - it's one piece of the puzzle.  We
> still need to collide xfs_fsr with xfs_reno to move the data.
>
> After that, we need to work out how to move the orphan metadata
> blocks out of the AGs that are to be truncated off. That's not
> simple....
>
> After that, we need the transaction to shrink the fs.
>
> At that point, we'll got a "working" shrink that will allow
> shrinking to only 50% of the original size because the log will
> get in the way. To fix that, we'll need to implement transactions
> to move the log...
>   
If we do that could be move to an inode based log?
Keep it contagious so recovery won't have to parse
up the file system to find the log.
The normal running case should be easier to deal with if
the log was just a file?

> Cheers,
>
> Dave.
>   


--------------080904050700000906050104
Content-Type: text/x-vcard; charset=utf-8;
 name="cattelan.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cattelan.vcf"

begin:vcard
fn:Russell Cattelan
n:Cattelan;Russell
email;internet:cattelan@thebarn.com
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------080904050700000906050104--
