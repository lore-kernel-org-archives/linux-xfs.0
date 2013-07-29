Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DA69D7F3F
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 03:34:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B4F5D304032
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 01:34:00 -0700 (PDT)
Received: from mail-qa0-f54.google.com (mail-qa0-f54.google.com
	[209.85.216.54]) by cuda.sgi.com with ESMTP id uDsCTm6GATbTxqeR
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 29 Jul 2013 01:33:59 -0700 (PDT)
Received: by mail-qa0-f54.google.com with SMTP id bv4so1539514qab.13
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 01:33:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130726113717.GN13468@dastard>
References: <1374759524-10061-1-git-send-email-zwu.kernel@gmail.com>
	<20130726020318.GD21982@dastard>
	<CAEH94LiXtG=DD+Qn4kbNT_Y_Qn65wVYrpYvHKXOob6wru3SeDw@mail.gmail.com>
	<20130726113717.GN13468@dastard>
Date: Mon, 29 Jul 2013 16:33:58 +0800
Message-ID: <CAEH94Lj27DCzCiWxwerEgwsExtdtviB_+S4bDbxg-wwq445rSA@mail.gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, linux-kernel mlist <linux-kernel@vger.kernel.org>, xfstests <xfs@oss.sgi.com>

On Fri, Jul 26, 2013 at 7:37 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Jul 26, 2013 at 02:01:23PM +0800, Zhi Yong Wu wrote:
>> No, it still raised the same assertion as below:
>>
>> [  521.715103] XFS: Assertion failed: !(bip->bli_item.li_flags &
>> XFS_LI_IN_AIL), file: fs/xfs/xfs_buf_item.c, line: 940
>
> How are you reproducing it?
>
> Can you take an event trace with trace-cmd and attach the output of
> the report?
After kernel base is switched to Linux 3.11-rc3, when i try to take
event trace with trace-cmd, that issue doesn't appear any more in my
environment. :)

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Regards,

Zhi Yong Wu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
