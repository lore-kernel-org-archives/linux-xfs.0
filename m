Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 02 Oct 2006 00:27:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k927RQaG030957
	for <xfs@oss.sgi.com>; Mon, 2 Oct 2006 00:27:28 -0700
Message-ID: <4520BF8A.4090602@sgi.com>
Date: Mon, 02 Oct 2006 17:28:10 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: LVM and XFS cannot set blocksize on block device
References: <45185424.2030707@tulane.edu> <20060926001737.GA10224@tuatara.stupidest.org> <45193204.3030500@tulane.edu> <20060926224053.GA31542@tuatara.stupidest.org> <451A669D.9020503@agami.com> <451BA2AF.9090703@sgi.com> <20060928153218.GA26366@tuatara.stupidest.org>
In-Reply-To: <20060928153218.GA26366@tuatara.stupidest.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: Shailendra Tripathi <stripathi@agami.com>, Rene Salmon <rsalmon@tulane.edu>, xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>

Chris Wedgwood wrote:
> On Thu, Sep 28, 2006 at 08:23:43PM +1000, Tim Shimmin wrote:
> 
>> I'll have a look soon at passing the mkfs.xfs -s option thru to
>> libxfs which is consistent with the existing code.
> 
> (following up on something mentioned off the list)
> 
> When you do this change please consider *not* making the code fallback
> to a different blocksize if the ioctl fails when "-s size=" is given.
> 
> The logic here is that if someone clearly wants a specific value and
> if that cannot be met it should error out with a suitable message, not
> silently do something else.

I agree.
I prefer default behaviour to happen when we are using the defaults -
so we can do fallback behaviour under the assumption the user
doesn't mind.
But when we ask for something explicitly, then do it or error out.
:)

I'd be tempted to reuse libxfs_init_t's setblksize to be 1 as it currently
is if one wants the device blksize to be set and
 >1 (really > 512 etc...) if one wants to set it to a particular value.

--Tim
