Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C6A407F3F
	for <xfs@oss.sgi.com>; Tue, 16 Apr 2013 08:26:38 -0500 (CDT)
Message-ID: <516D518F.1000708@sgi.com>
Date: Tue, 16 Apr 2013 08:26:39 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: kernels 3.4 slower due to allocation workqueue
References: <516BCACE.1040900@univ-nantes.fr> <516C046C.8080908@sgi.com>
	<516CFCB8.1060804@univ-nantes.fr>
In-Reply-To: <516CFCB8.1060804@univ-nantes.fr>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Yann Dupont <Yann.Dupont@univ-nantes.fr>
Cc: xfs@oss.sgi.com

On 04/16/13 02:24, Yann Dupont wrote:
> Le 15/04/2013 15:45, Mark Tinguely a =E9crit :
>>
>> Here are the allocation worker changes.
>>
>
> Hello mark, thanks for you answer
>
>> The biggest performance commit should be aa292847, which limits the
>> callers to the worker.
>>
>> commit 3b876c8f2a361ceeed3fed894980c69066f903a0
>> Author: Jeff Liu <jeff.liu@oracle.com>
>> Date: Thu Jun 7 15:44:32 2012 +0800
>>
>> xfs: fix debug_object WARN at xfs_alloc_vextent()
>>
>> commit aa292847b9fc6e187547110de833a7d3131bbddf
>> Author: Dave Chinner <dchinner@redhat.com>
>> Date: Thu Jul 12 07:40:43 2012 +1000
>>
>> xfs: don't defer metadata allocation to the workqueue
>>
>
> Only These 2 commits are candidates, the others are post 3.5.
> I'll try to patch a 3.4 with each patch.
>
>> commit 2455881c0b52f87be539c4c7deab1afff4d8a560
>> Author: Dave Chinner <dchinner@redhat.com>
>> Date: Fri Oct 5 11:06:58 2012 +1000
>>
>> xfs: introduce XFS_BMAPI_STACK_SWITCH
>>
>> commit e04426b9202bccd4cfcbc70b2fa2aeca1c86d8f5
>> Author: Dave Chinner <dchinner@redhat.com>
>> Date: Fri Oct 5 11:06:59 2012 +1000
>>
>> xfs: move allocation stack switch up to xfs_bmapi_allocate
>>
>> commit 9e96fe6df44425b69ed89f6ac20352cec1f127d7
>> Author: Brian Foster <bfoster@redhat.com>
>> Date: Thu Jan 17 13:11:29 2013 -0500
>>
>> xfs: pull up stack_switch check into xfs_bmapi_write
>>
>>
>> The last 3 patches address an AGF buffer hang with the allocation worker.
>>
>> --Mark.
>
> As 3.4 Kernels don't have thoses patches, is there a risk associated
> with 3.4 kernels ?
>
> Cheers,
>

The filesystem can hang but only if the OS cannot allocate another =

worker when doing certain calls.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
