Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4VFQ75w054440 for <xfs@oss.sgi.com>; Tue, 31 May 2011 10:26:07 -0500
Received: from e9.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A64451BEE983
	for <xfs@oss.sgi.com>; Tue, 31 May 2011 08:26:06 -0700 (PDT)
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id lHOByWxlHezjOlax for
	<xfs@oss.sgi.com>; Tue, 31 May 2011 08:26:06 -0700 (PDT)
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e9.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4VEu3dQ020765
	for <xfs@oss.sgi.com>; Tue, 31 May 2011 10:56:03 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p4VFQ5jd029178 for <xfs@oss.sgi.com>; Tue, 31 May 2011 11:26:05 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p4VFQ44Q015718 for <xfs@oss.sgi.com>; Tue, 31 May 2011 11:26:05 -0400
Message-ID: <4DE50881.90401@linux.vnet.ibm.com>
Date: Tue, 31 May 2011 08:25:53 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: xfsprogs: Fix for xfstest 252 hang on ext4
References: <4DDAC4EF.1050702@linux.vnet.ibm.com>
	<BANLkTiks0NSDTSPN8n446JHWhKtM61_=Mw@mail.gmail.com>
	<4DDB1A0C.5030502@linux.vnet.ibm.com>
In-Reply-To: <4DDB1A0C.5030502@linux.vnet.ibm.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On 5/23/2011 7:38 PM, Allison Henderson wrote:
> On 5/23/2011 6:16 PM, Yongqiang Yang wrote:
>> On Tue, May 24, 2011 at 4:34 AM, Allison Henderson
>> <achender@linux.vnet.ibm.com> wrote:
>>> Hi all,
>>>
>>> While trying to add more punch hole tests to xfstest, I found that
>>> test 252 hangs on ext4 due to a loop in xfsprogs that does not exit.
>>> XFS gets out of this loop because there is logic in the loop that
>>> looks for the last extent flag and breaks out. But it looks like ext4
>>> does not return a last extent when the file has a hole at the end. I
>>> am not sure if this is the correct behavior or not, so I will copy
>>> the ext4 folks on this too. Below is a copy of the fix for xfsprogs:
>>
>> Hi there,
>>
>> What's blocksize of the tested ext4? For now, ext4 returns
>> LAST_EXTENT if the logical offset covered by the extent is greater
>> than file size, so if there is a hole at the end, no last extent is
>> returned. Thx!
>>
>> Yongqiang.
>
> Hi there,
>
> The block size I've been using is 4096. As long as that behavior is
> expected, I think the test will be ok with just the xfsprogs fix,
> though. Thx!
>
> Allison Henderson
>
>>
>>>
>>> diff --git a/io/fiemap.c b/io/fiemap.c
>>> index fa990cc..81fc92c 100644
>>> --- a/io/fiemap.c
>>> +++ b/io/fiemap.c
>>> @@ -246,7 +246,7 @@ fiemap_f(
>>> flg_w, _("FLAGS"));
>>> }
>>>
>>> - while (!last&& ((cur_extent + 1) != max_extents)) {
>>> + while (!last&& (cur_extent<= max_extents)) {
>>> if (max_extents)
>>> num_extents = min(num_extents,
>>> max_extents - (cur_extent + 1));
>>>
>>>
>>> It looks like the loop enters with last=0, cur_extents=0, and
>>> max_extents = 0, and on the first iteration cur_extents get set to 2,
>>> so we dont see ((cur_extent + 1) == max_extents for a very long time.
>>> I doubt the logic was meant to work that way, so this patch should
>>> fix it, but I wanted to make sure that the fiemap for ext4 is working
>>> as intended too. Feed back appreciated! Thx all!
>>>
>>> Allison Henderson
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
>>
>


 >> Hi all,
 >>
 >> I haven't heard much back on this patch, so Im just poking this
 >> thread to make sure it doesn't get forgotten. I have some patches
 >> out there for punch hole, and I'm currently looking at fixing up
 >> some older punch hole tests in the dmapi code, but they wont do much
 >> good for ext4 with out this fix.  If I could get a quick peek from
 >> some one on the xfs list for this patch, that would be much
 >> appreciated.  Thx all!
 >
 > If ext4 is not setting the last extent flag on the last extent then
 > that's an ext4 bug that the test has detected, right? And so you
 > should be fixing ext4 rather than modifying the test to hide the
 > different behaviour?
 >
 > Cheer
 >
 >-- Dave Chinner david@fromorbit.com

Hi All,

Sorry, I should have poked the thread with Yongqiang's response, so I 
will move the dialog into this thread.  At the moment, it sounds like 
the fiemap for ext4 is working as intended.  Yongqiang, do you agree 
that the fiemap for ext4 should be changed?  I think you are more 
familiar with this part of the code than I am, and I just want to make 
sure we find a solution that everyone is happy with.  Thx!

Allison Henderson





> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
