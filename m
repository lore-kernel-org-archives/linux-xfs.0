Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 107E57CBF
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 20:32:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 95007AC002
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 18:32:24 -0700 (PDT)
Received: from mail-qe0-f41.google.com (mail-qe0-f41.google.com
	[209.85.128.41]) by cuda.sgi.com with ESMTP id MYNRH0Nqg1C3fXVY
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 30 Jul 2013 18:32:22 -0700 (PDT)
Received: by mail-qe0-f41.google.com with SMTP id a11so68364qen.28
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 18:32:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51F7BF25.6010103@oracle.com>
References: <1374759524-10061-1-git-send-email-zwu.kernel@gmail.com>
	<20130726020318.GD21982@dastard>
	<CAEH94LiXtG=DD+Qn4kbNT_Y_Qn65wVYrpYvHKXOob6wru3SeDw@mail.gmail.com>
	<20130726113717.GN13468@dastard>
	<CAEH94Lj27DCzCiWxwerEgwsExtdtviB_+S4bDbxg-wwq445rSA@mail.gmail.com>
	<CAEH94Lj8FLB-F14hLA880H=OY66vdt1mxjLxwJ9poVSS0xDf8w@mail.gmail.com>
	<51F7BF25.6010103@oracle.com>
Date: Wed, 31 Jul 2013 09:32:22 +0800
Message-ID: <CAEH94Li5kkG5HrLVztOmofSm8Hzn7niOGLUxo_338a-YiCOL=A@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix an assertion failure
From: Zhi Yong Wu <zwu.kernel@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfstests <xfs@oss.sgi.com>
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

On Tue, Jul 30, 2013 at 9:27 PM, Jeff Liu <jeff.liu@oracle.com> wrote:
> On 07/30/2013 07:06 PM, Zhi Yong Wu wrote:
>
>> On Mon, Jul 29, 2013 at 4:33 PM, Zhi Yong Wu <zwu.kernel@gmail.com> wrote:
>>> On Fri, Jul 26, 2013 at 7:37 PM, Dave Chinner <david@fromorbit.com> wrote:
>>>> On Fri, Jul 26, 2013 at 02:01:23PM +0800, Zhi Yong Wu wrote:
>>>>> No, it still raised the same assertion as below:
>>>>>
>>>>> [  521.715103] XFS: Assertion failed: !(bip->bli_item.li_flags &
>>>>> XFS_LI_IN_AIL), file: fs/xfs/xfs_buf_item.c, line: 940
>>>>
>>>> How are you reproducing it?
>>>>
>>>> Can you take an event trace with trace-cmd and attach the output of
>>>> the report?
>>> After kernel base is switched to Linux 3.11-rc3, when i try to take
>>> event trace with trace-cmd, that issue doesn't appear any more in my
>>> environment. :)
>> When your patch is not applied, i hit this issue sometime today, and
>> take some event trace with trace-cmd, and attach it in this mail. But
>> after your patch is applied, i tried some times, but haven't hit so
>> far, so i  want to see if i can hit it in next days.
>
>
> I have ran compilebench multiple times combine with different options against
> xfs-next in the past few days, but I can not reproduce this issue.
I ran it against Linus' tree, and hit this assertion sometimes, not
every time regardless that Dave's patch is applied.
>
> Could you please show us your test case as Dave has asked?  Sometimes, the test
> steps is more useful for someone who has interest in your post.
I just modified the test steps post by Dave.

root@debian-i386:/home/zwu# cat recovery_time_compilebench.sh
#!/bin/bash

i=1
while(($i > 0))
do
    mkfs.xfs -f /dev/sda;
    mount /dev/sda /mnt/scratch
    chmod 777 /mnt/scratch;
    cd ~
    trace-cmd record -e xfs/* &
    cd /home/zwu/compilebench-0.6/
    ./compilebench --no-sync -D /mnt/scratch &
    sleep 55
    /home/zwu/xfstests/src/godown /mnt/scratch
    umount /mnt/scratch
    xfs_logprint -t /dev/sda |head -20
    time mount /dev/sda /mnt/scratch
    umount /mnt/scratch

    sleep 5

    pkill trace-cmd
    rm -rf ~/trace.dat*

    sleep 5
done

>
> Thanks,
> -Jeff



-- 
Regards,

Zhi Yong Wu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
