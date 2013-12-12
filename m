Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4BDED7F50
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 21:27:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DD650AC008
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 19:27:06 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id JDj8TXEyTAPuowb7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 19:27:02 -0800 (PST)
Message-ID: <52A92CFF.5070600@oracle.com>
Date: Thu, 12 Dec 2013 11:26:55 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: return ENOSPC when trying to set more ACLs than
	XFS_ACL_MAX_ENTRIES
References: <52921D12.7040104@oracle.com>
	<5292C557.9020008@sandeen.net>	<5292D8AB.5080003@oracle.com>
	<20131211193622.GG1935@sgi.com>
In-Reply-To: <20131211193622.GG1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Ben,

On 12/12 2013 03:36 AM, Ben Myers wrote:
> Hey Jeff,
> 
> On Mon, Nov 25, 2013 at 12:57:15PM +0800, Jeff Liu wrote:
>>
>> On 11/25 2013 11:34 AM, Eric Sandeen wrote:
>>> On 11/24/13, 9:36 AM, Jeff Liu wrote:
>>>> From: Jie Liu <jeff.liu@oracle.com>
>>>>
>>>> We currently return EINVAL when trying to set more ACL entries than
>>>> XFS_ACL_MAX_ENTRIES(), but it would be a bit more meaningful to return
>>>> ENOSPC in this situation, because the later is used to indicate there
>>>> is no more space to store new ACLs IMHO.
>>>
>>> I'm not quite convinced that it's better; the user will get an
>>> error string of "no space left on device" which is misleading too,
>> I admit that both looks misleading...
>>> and I'd argue that it's no better than "invalid argument."
>>>
>>> To me, I think it's not worth changing, but others may disagree.
>>>
>>> (I guess looking at ext4, it uses ENOSPC for some similar constraints,
>>> so maybe three is precedent for this)
>> Btrfs also uses ENOSPC, but JFS would return something like "Argument list too long"
>> in this case.
> 
> I tend to agree with Eric on this one, but if Dave or Christoph want to weigh
> in that's cool.
I agree to Eric as well since either errno cannot indicate this situation much
cleaner.  I also can not find an existing errno could be used for this situation,
maybe someday there would have a particular errno to be used in this case if users
complain about it.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
