Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5CFsYG3212901 for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 10:54:35 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 45C74AC052
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 08:54:54 -0700 (PDT)
Message-Id: <1FF0104F-7D97-4A6A-B80E-E7EE511AA916@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <alpine.DEB.2.00.0906120420080.26259@p34.internal.lan>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: Kernel 2.6.30: Memory/XFS leak, OOM killer kills many processes
Date: Fri, 12 Jun 2009 10:54:53 -0500
References: <alpine.DEB.2.00.0906111158470.2563@p34.internal.lan>
	<alpine.DEB.2.00.0906111255280.6809@p34.internal.lan>
	<4A313F84.20900@sandeen.net>
	<96F5FBF8-17B6-4AA9-BAB4-377AF596692C@sgi.com>
	<alpine.DEB.2.00.0906120420080.26259@p34.internal.lan>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com


On Jun 12, 2009, at 3:37 AM, Justin Piszcz wrote:

>
>
> On Thu, 11 Jun 2009, Felix Blyakher wrote:
>
>>
>> On Jun 11, 2009, at 12:31 PM, Eric Sandeen wrote:
>>
>>> Justin Piszcz wrote:
>>>> On Thu, 11 Jun 2009, Justin Piszcz wrote:
>> The following should fix it:
>>
>> diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
>> index 4b0f6ef..7928b99 100644
>> --- a/fs/xfs/xfs_bmap.c
>> +++ b/fs/xfs/xfs_bmap.c
>> @@ -6086,6 +6086,7 @@ xfs_getbmap(
>>                     break;
>>     }
>>
>> +       kmem_free(out);
>>     return error;
>> }
>>
>>
>> Felix
>
> Just FYI if anyone tries to run the patch it will not work:
>
> # patch -p1 < ../xfs.patch patching file fs/xfs/xfs_bmap.c
> patch: **** malformed patch at line 11: }

Must have been copy-and-paste problem. The real one is good :)

> So just goto line ~6086 and add the kmem_free(out); above the return  
> error.
>
> Status:
> This patch fixes the problem, thanks!

Thanks for reporting and verifying the fix!
It's ready now for the linux-next in the official xfs repo,
going upstream with the pull request later today and then be
ready for inclusion in 2.6.30.

Felix

>
>
> Justin.
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
