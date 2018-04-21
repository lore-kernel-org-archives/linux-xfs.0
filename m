Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:25956 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750748AbeDUFbg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Apr 2018 01:31:36 -0400
Message-ID: <5ADACCB1.7070304@cn.fujitsu.com>
Date: Sat, 21 Apr 2018 13:31:29 +0800
From: Xiao Yang <yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: question about mkfs.xfs
References: <5ADAAE79.5020803@cn.fujitsu.com> <b663f0ab-ab78-961f-7e24-a9794eb07d98@sandeen.net> <855f13dc-7cb7-b211-94e6-65f600c99ddd@redhat.com>
In-Reply-To: <855f13dc-7cb7-b211-94e6-65f600c99ddd@redhat.com>
Content-Type: text/plain; charset="x-gbk"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On 2018/04/21 12:43, Eric Sandeen wrote:
> On 4/20/18 11:34 PM, Eric Sandeen wrote:
>>
>> On 4/20/18 10:22 PM, Xiao Yang wrote:
>>> Hi Eric£¬
>>>
>>> Before commit 16adcb8 in xfsprogs-dev, only "sunit=0,swidth=0" is vaild
>>> and will convert
>>> into the default stripe config as expected.
>> It behaved the same as the default, because it looked the same as
>> "not set" to all the conditionals in mkfs.
>>
>>> After this commit, both
>>> "sunit=0,swidth=0"
>>> and "sunit=0,swidth=64" will be forced to convert into the default
>>> stripe config.
>> 0,0 should be allowed, to force mkfs to ignore any stripe geometry
>> reported by the device.
>>
>>> If either of sunit and swidth is not 0, should we do a forced conversion?
>>> I am not sure if we should reject the combination(e.g. sunit=0,swidth=64).
>> I am not sure what you mean by "forced conversion" - can you give specific
>> examples?
Hi Eric,

Sorry, i didn't describe it clearly.
I meant a stripe unit of 0 with a non-zero stripe width shouldn't 
behaved the
same as "sunit=0,swidth=0.
>> However, a stripe unit of 0 with a non-zero stripe width should probably
>> also be rejected, because it has no meaning.  I think it was rejected
>> before, and my commit accidentally allowed it again.
>>
>> It probably needs another test added back in, to check for "both options
>> were specified, but (only) one was zero."
> Maybe like this:
>
> mkfs.xfs: if either sunit or swidth is nonzero, the other must be as well
Thanks for your fix, and it looks good to me.

Thanks,
Xiao Yang
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---
>
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 78d0ce5..b356d4d 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2271,7 +2271,8 @@ _("data stripe width (%lld) is too large of a multiple of the data stripe unit (
>   		dswidth = big_dswidth;
>   	}
>
> -	if (dsunit&&  (!dswidth || (dswidth % dsunit != 0))) {
> +	if ((dsunit&&  !dswidth) || (!dsunit&&  dswidth) ||
> +           (dsunit&&  (dswidth % dsunit != 0))) {
>   		fprintf(stderr,
>   _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
>   			dswidth, dsunit);
>
>
> which yields:
>
> # mkfs.xfs -f -dsunit=0,swidth=64,file,name=fsfile,size=1g
> data stripe width (64) must be a multiple of the data stripe unit (0)
>
> # mkfs.xfs -f -dsunit=64,swidth=0,file,name=fsfile,size=1g
> data stripe width (0) must be a multiple of the data stripe unit (64)
>
> # mkfs.xfs -f -dsunit=64,swidth=7,file,name=fsfile,size=1g
> data stripe width (7) must be a multiple of the data stripe unit (64)
>
> # mkfs.xfs -f -dsunit=0,swidth=0,file,name=fsfile,size=1g
> <success>
>
> -Eric
>
>
> .
>



