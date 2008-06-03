Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 03 Jun 2008 13:23:09 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m53KN4qM020961
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2008 13:23:06 -0700
Received: from proxy1.bredband.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 839BE17760AC
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2008 13:23:58 -0700 (PDT)
Received: from proxy1.bredband.net (proxy1.bredband.net [195.54.101.71]) by cuda.sgi.com with ESMTP id S01N5b4WNy7iErQ7 for <xfs@oss.sgi.com>; Tue, 03 Jun 2008 13:23:58 -0700 (PDT)
Received: from ironport.bredband.com (195.54.101.120) by proxy1.bredband.net (7.3.127)
        id 4811823A00C1C351 for xfs@oss.sgi.com; Tue, 3 Jun 2008 22:23:57 +0200
Message-ID: <4845A857.3090905@stesmi.com>
Date: Tue, 03 Jun 2008 22:23:51 +0200
From: Stefan Smietanowski <stesmi@stesmi.com>
MIME-Version: 1.0
Subject: Re: XFS: SB validate failed
References: <3607657a0805291005k457791cej1c5f867da0f95965@mail.gmail.com>	 <3607657a0805301019h4a49dc86ne8f1f019629a1c41@mail.gmail.com>	 <4840406F.50402@stesmi.com> <48408D3E.3090401@gmail.com>	 <48409981.1050405@stesmi.com> <48425148.1080105@gmail.com>	 <48427DEE.40400@stesmi.com>	 <3607657a0806031036r702ab6a5w7ca6517c19395b9b@mail.gmail.com>	 <3607657a0806031056w24efa917q625f13bfe9eaa706@mail.gmail.com>	 <4845949F.7080209@stesmi.com> <3607657a0806031239l6d788868u2f5654efcabf4abc@mail.gmail.com>
In-Reply-To: <3607657a0806031239l6d788868u2f5654efcabf4abc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Spam Magnet <spam.wax@gmail.com>
Cc: Timothy Shimmin <tes@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Spam Magnet wrote:
> On Tue, Jun 3, 2008 at 2:59 PM, Stefan Smietanowski <stesmi@stesmi.com> wrote:
>> Spam Magnet wrote:
>>>> (The healthy disk image also doesn't have any XFS but it has: 'S f x'
>>>> (capital s))
>>> Correcting my mistake:
>>>
>>> The healthy image file does have the X F S B at 10000000  (octal) as
>>> fdisk had reported:
>>> Pt#          Device  Info     Start       End   Sectors  Id  System
>>>  8: 2gb-ubuntu.img1            4096   3915599   3911504   a  SGI xfs
>>>
>>> 4096*512=2097152 (10000000 octal):
>>> $ od -t c 2gb-ubuntu.img | grep 10000000
>>> 10000000   X   F   S   B  \0  \0 020  \0  \0  \0  \0  \0  \0  \a   u 350
>>>
>>> I tried to see if I can find do the same thing for jaz7.img:
>>> Pt#    Device  Info     Start       End   Sectors  Id  System
>>>  8: jaz7.img1            3072   2091007   2087936   a  SGI xfs
>>>
>>> $ od -t c jaz7.img | grep 6000000
>>> 6000000  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
>>>
>>> I guess all those zeros are not good signs.
>> Wait a moment. Aren't jaz sectors 2k each?
>>
>> Try at 3072*2048 instead.
>>
>> // Stefan
>>
> 
> I think they are but I used -u option of fdisk:
> $ fdisk -ul jaz7.img
> Disk jaz7.img (SGI disk label): 255 heads, 63 sectors, 0 cylinders
> Units = sectors of 1 * 512 bytes
> ----- partitions -----
> Pt#    Device  Info     Start       End   Sectors  Id  System
>  8: jaz7.img1            3072   2091007   2087936   a  SGI xfs
>  9: jaz7.img2               0      3071      3072   0  SGI volhdr
> 11: jaz7.img3               0   2091007   2091008   6  SGI volume
> 
> which lists partitions in sector units. As oppose to:
> 
> $ fdisk -l jaz7.img
> 
> Disk jaz7.img (SGI disk label): 255 heads, 63 sectors, 0 cylinders
> Units = cylinders of 16065 * 512 bytes
> 
> ----- partitions -----
> Pt#    Device  Info     Start       End   Sectors  Id  System
>  8: jaz7.img1               1       130   2087936   a  SGI xfs
>  9: jaz7.img2               0         0      3072   0  SGI volhdr
> 11: jaz7.img3               0       130   2091008   6  SGI volume

I'd give it a shot regardless as I don't remember if the sector size is
actually IN the partition table and if it's NOT then it'll show the
native blocksize of the device, which is 512bytes!

Just try it, what do you have to lose? I mean do the od ..
Worst case you get garbage or zeroes.

// Stefan
