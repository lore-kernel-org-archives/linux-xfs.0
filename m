Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0A44F7F3F
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 05:15:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 02971304032
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 03:14:59 -0700 (PDT)
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]) by cuda.sgi.com with
	ESMTP id VjB7GrjQQg5lttU5 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 12 May 2014 03:14:58 -0700 (PDT)
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id DA8083EE0BD
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 19:14:56 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id C7E6645DF33
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 19:14:56 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.nic.fujitsu.com [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id AE25945DF31
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 19:14:56 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 9A9D11DB8040
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 19:14:56 +0900 (JST)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local
	(g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 409E4E18003
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 19:14:56 +0900 (JST)
Message-ID: <53709EE3.5090407@jp.fujitsu.com>
Date: Mon, 12 May 2014 19:13:55 +0900
From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
MIME-Version: 1.0
Subject: Re: xfs: processes are stuck at xlog_grant_head_wait()
References: <53708354.2060103@jp.fujitsu.com> <20140512082748.GX5421@dastard>
In-Reply-To: <20140512082748.GX5421@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, esandeen@redhat.com, xfs@oss.sgi.com

Hi Dave,

On Mon, 12 May 2014 18:27:48 +1000 Dave Chinner wrote:
> On Mon, May 12, 2014 at 05:16:20PM +0900, Masayoshi Mizuma wrote:
>> Hi all,
>>
>> Processes are stuck at xlog_grant_head_wait() when I ran a heavy stress
>> test (xfstests, ltpstress and fsstress concurrently) on linux-next
>> (3.15.0-rc4-next-20140506) kernel.
>> I got the crash dump, then I think this problem is similar as a problem
>> fixed by the following commit.
>
> Already fixed in the for-next branch.
>
> 49abc3a xfs: truncate_setsize should be outside transactions

Oh good! thank you!

Thanks,
Masayoshi Mizuma

>
> Cheers,
>
> Dave.
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
