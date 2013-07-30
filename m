Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B4C717CBF
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 08:27:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 391FFAC002
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 06:26:57 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id f2OIRuHgwnV8DUfo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 30 Jul 2013 06:26:55 -0700 (PDT)
Message-ID: <51F7BF25.6010103@oracle.com>
Date: Tue, 30 Jul 2013 21:27:01 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix an assertion failure
References: <1374759524-10061-1-git-send-email-zwu.kernel@gmail.com>
	<20130726020318.GD21982@dastard>
	<CAEH94LiXtG=DD+Qn4kbNT_Y_Qn65wVYrpYvHKXOob6wru3SeDw@mail.gmail.com>
	<20130726113717.GN13468@dastard>
	<CAEH94Lj27DCzCiWxwerEgwsExtdtviB_+S4bDbxg-wwq445rSA@mail.gmail.com>
	<CAEH94Lj8FLB-F14hLA880H=OY66vdt1mxjLxwJ9poVSS0xDf8w@mail.gmail.com>
In-Reply-To: <CAEH94Lj8FLB-F14hLA880H=OY66vdt1mxjLxwJ9poVSS0xDf8w@mail.gmail.com>
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
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, xfstests <xfs@oss.sgi.com>

On 07/30/2013 07:06 PM, Zhi Yong Wu wrote:

> On Mon, Jul 29, 2013 at 4:33 PM, Zhi Yong Wu <zwu.kernel@gmail.com> wrote:
>> On Fri, Jul 26, 2013 at 7:37 PM, Dave Chinner <david@fromorbit.com> wrote:
>>> On Fri, Jul 26, 2013 at 02:01:23PM +0800, Zhi Yong Wu wrote:
>>>> No, it still raised the same assertion as below:
>>>>
>>>> [  521.715103] XFS: Assertion failed: !(bip->bli_item.li_flags &
>>>> XFS_LI_IN_AIL), file: fs/xfs/xfs_buf_item.c, line: 940
>>>
>>> How are you reproducing it?
>>>
>>> Can you take an event trace with trace-cmd and attach the output of
>>> the report?
>> After kernel base is switched to Linux 3.11-rc3, when i try to take
>> event trace with trace-cmd, that issue doesn't appear any more in my
>> environment. :)
> When your patch is not applied, i hit this issue sometime today, and
> take some event trace with trace-cmd, and attach it in this mail. But
> after your patch is applied, i tried some times, but haven't hit so
> far, so i  want to see if i can hit it in next days.


I have ran compilebench multiple times combine with different options against
xfs-next in the past few days, but I can not reproduce this issue.

Could you please show us your test case as Dave has asked?  Sometimes, the test
steps is more useful for someone who has interest in your post.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
