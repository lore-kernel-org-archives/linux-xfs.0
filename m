Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Jun 2008 09:15:27 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m55GFOkw021215
	for <xfs@oss.sgi.com>; Thu, 5 Jun 2008 09:15:24 -0700
Received: from rv-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8DF1E1EF9C8
	for <xfs@oss.sgi.com>; Thu,  5 Jun 2008 09:16:18 -0700 (PDT)
Received: from rv-out-0708.google.com (rv-out-0708.google.com [209.85.198.242]) by cuda.sgi.com with ESMTP id lOFMmqf1U2nVrM6M for <xfs@oss.sgi.com>; Thu, 05 Jun 2008 09:16:18 -0700 (PDT)
Received: by rv-out-0708.google.com with SMTP id f25so621401rvb.32
        for <xfs@oss.sgi.com>; Thu, 05 Jun 2008 09:16:18 -0700 (PDT)
Message-ID: <3607657a0806050916rd26b4f4tee83305644e66416@mail.gmail.com>
Date: Thu, 5 Jun 2008 12:16:17 -0400
From: "Spam Magnet" <spam.wax@gmail.com>
Subject: Re: XFS: SB validate failed
In-Reply-To: <4845A857.3090905@stesmi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3607657a0805291005k457791cej1c5f867da0f95965@mail.gmail.com>
	 <48408D3E.3090401@gmail.com> <48409981.1050405@stesmi.com>
	 <48425148.1080105@gmail.com> <48427DEE.40400@stesmi.com>
	 <3607657a0806031036r702ab6a5w7ca6517c19395b9b@mail.gmail.com>
	 <3607657a0806031056w24efa917q625f13bfe9eaa706@mail.gmail.com>
	 <4845949F.7080209@stesmi.com>
	 <3607657a0806031239l6d788868u2f5654efcabf4abc@mail.gmail.com>
	 <4845A857.3090905@stesmi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stefan Smietanowski <stesmi@stesmi.com>
Cc: Timothy Shimmin <tes@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Tue, Jun 3, 2008 at 4:23 PM, Stefan Smietanowski <stesmi@stesmi.com> wrote:

>> I think they are but I used -u option of fdisk:
>> $ fdisk -ul jaz7.img
>> Disk jaz7.img (SGI disk label): 255 heads, 63 sectors, 0 cylinders
>> Units = sectors of 1 * 512 bytes
>> ----- partitions -----
>> Pt#    Device  Info     Start       End   Sectors  Id  System
>>  8: jaz7.img1            3072   2091007   2087936   a  SGI xfs
>>  9: jaz7.img2               0      3071      3072   0  SGI volhdr
>> 11: jaz7.img3               0   2091007   2091008   6  SGI volume
>>
>> which lists partitions in sector units. As oppose to:
>>
>> $ fdisk -l jaz7.img
>>
>> Disk jaz7.img (SGI disk label): 255 heads, 63 sectors, 0 cylinders
>> Units = cylinders of 16065 * 512 bytes
>>
>> ----- partitions -----
>> Pt#    Device  Info     Start       End   Sectors  Id  System
>>  8: jaz7.img1               1       130   2087936   a  SGI xfs
>>  9: jaz7.img2               0         0      3072   0  SGI volhdr
>> 11: jaz7.img3               0       130   2091008   6  SGI volume
>
> I'd give it a shot regardless as I don't remember if the sector size is
> actually IN the partition table and if it's NOT then it'll show the
> native blocksize of the device, which is 512bytes!
>
> Just try it, what do you have to lose? I mean do the od ..
> Worst case you get garbage or zeroes.

3072*2048=6,291,456 (30000000 octal)

$ od -t c jaz7.img | grep 30000000
30000000 377 377 367 371  \0  \0   0 365  \0  \0   ?   y  \0  \0 004 016
130000000 201 244  \0 001  \0  \0  \0  \0  \0  \0 006 201   B 373 306 307

So I guess that didn't work either :(
