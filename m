Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3EG7NJK004232 for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 11:07:24 -0500
Received: from mail-pz0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4B5B650D3B0
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 09:10:45 -0700 (PDT)
Received: from mail-pz0-f53.google.com (mail-pz0-f53.google.com
	[209.85.210.53]) by cuda.sgi.com with ESMTP id kvolytUGbi0cxg8V
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 09:10:45 -0700 (PDT)
Received: by pzk3 with SMTP id 3so911988pzk.26
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 09:10:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTikW72q_2pEoVTmag8+gMsCcZ-fR8w@mail.gmail.com>
References: <20110414102608.GA1678@x4.trippels.de>
	<20110414120635.GB1678@x4.trippels.de>
	<20110414140222.GB1679@x4.trippels.de>
	<4DA70BD3.1070409@draigBrady.com> <4DA717B2.3020305@sandeen.net>
	<4DA7182B.8050409@draigBrady.com> <4DA71920.9@sandeen.net>
	<BANLkTikW72q_2pEoVTmag8+gMsCcZ-fR8w@mail.gmail.com>
Date: Fri, 15 Apr 2011 00:10:45 +0800
Message-ID: <BANLkTimoLeWMJgNFGW+zdeUeJyZ-_+8fMQ@mail.gmail.com>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
From: Yongqiang Yang <xiaoqiangnk@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-ext4@vger.kernel.org, =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigbrady.com>, coreutils@gnu.org, Markus Trippelsdorf <markus@trippelsdorf.de>, xfs-oss <xfs@oss.sgi.com>

Hi,

I am off my working computer.  Maybe below fix could fix the problem.

fs/ext4/extent.c
static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
1877                 } else if (block >=3D le32_to_cpu(ex->ee_block)) {
1878                         /*
1879                          * some part of requested space is covered
1880                          * by found extent
1881                          */
1882                         start =3D block;
1883                         end =3D le32_to_cpu(ex->ee_block)
1884                                 + ext4_ext_get_actual_len(ex);
1885                         if (block + num < end)
1886                                 end =3D block + num;
       +                        if (!ext4_ext_is_uninitialized(ex))
1887                         exists =3D 1;
1888                 } else {
1889                         BUG();
1890                 }


On Fri, Apr 15, 2011 at 12:04 AM, Yongqiang Yang <xiaoqiangnk@gmail.com> wr=
ote:
> 2011/4/14 Eric Sandeen <sandeen@sandeen.net>:
>> On 4/14/11 10:52 AM, P=E1draig Brady wrote:
>>> On 14/04/11 16:50, Eric Sandeen wrote:
>>>> On 4/14/11 9:59 AM, P=E1draig Brady wrote:
>>>>> On 14/04/11 15:02, Markus Trippelsdorf wrote:
>>>>>>>> Hi P=E1draig,
>>>>>>>>
>>>>>>>> here you go:
>>>>>>>> + filefrag -v unwritten.withdata
>>>>>>>> Filesystem type is: ef53
>>>>>>>> File size of unwritten.withdata is 5120 (2 blocks, blocksize 4096)
>>>>>>>> =A0ext logical physical expected length flags
>>>>>>>> =A0 =A00 =A0 =A0 =A0 0 =A0 274432 =A0 =A0 =A0 =A0 =A0 =A02560 unwr=
itten,eof
>>>>>>>> unwritten.withdata: 1 extent found
>>>>>>>>
>>>>>>>> Please notice that this also happens with ext4 on the same kernel.
>>>>>>>> Btrfs is fine.
>>>>>>>
>>>>>> `filefrag -vs` fixes the issue on both xfs and ext4.
>>>>>
>>>>> So in summary, currently on (2.6.39-rc3), the following
>>>>> will (usually?) report a single unwritten extent,
>>>>> on both ext4 and xfs
>>>>>
>>>>> =A0 fallocate -l 10MiB -n k
>>>>> =A0 dd count=3D10 if=3D/dev/urandom conv=3Dnotrunc iflag=3Dfullblock =
of=3Dk
>>>>> =A0 filefrag -v k # grep for an extent without unwritten || fail
>>>>
>>>> right, that's what I see too in testing.
>>>>
>>>> But would the coreutils install have done a preallocation of the desti=
nation file?
>>>>
>>>> Otherwise this looks like a different bug...
>>>>
>>>>> This particular issue has been discussed so far at:
>>>>> http://debbugs.gnu.org/cgi/bugreport.cgi?bug=3D8411
>>>>> Note there it was stated there that ext4 had this
>>>>> fixed as of 2.6.39-rc1, so maybe there is something lurking?
>>>>
>>>> ext4 got a fix, but not xfs, I guess. =A0My poor brain can't remember,=
 I think I started looking into it, but it's clearly still broken.
>>>>
>>>> Still, I don't know for sure what happened to Markus - did something p=
reallocate, in his case?
>>>
>>> Well that preallocate test is failing for him
>>> when the source file is either on ext4 or xfs.
>>> He noticed the issue initially on XFS when copying
>>> none preallocated files, so XFS probably just has
>>> the general issue of needing a sync before fiemap,
>>> where as EXT4 just has this preallocate one
>>> (though I've not seen it myself).
>>>
>>> cheers,
>>> P=E1draig.
>>>
>>
>> well, if I simply take the preallocation step out of the testcase, it wo=
rks fine on xfs without a sync.
>>
>> So I still don't know what Markus hit...
> Sorry for that my patch ignored fallocate. =A0The situation is like this:
> An user allocated space for a file with fallocate, and write a small
> part of it. and the written is not flushed.
> The extent stays one unwritten extent in disk and memory with delayed
> allocation.
>
> In ext4 ext4_ext_walk_space() thinks an extent does not exist only if
> there is no any extents on disk. =A0So ext4_ext_walk_space()
> thinks there is a extent and =A0 ext4_ext_fiemap_cb() thus ignores pageca=
che.
>
> I think ext4_ext_walk_space() should take unwritten extent not exist.
>
> Yongqiang.
>>
>> -Eric
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Best Wishes
> Yongqiang Yang
>



-- =

Best Wishes
Yongqiang Yang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
