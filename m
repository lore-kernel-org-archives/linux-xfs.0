Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B124829DF9
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2014 10:02:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9C03A8F8040
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2014 08:02:53 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id AYMlZPj0G3yJYGUC for <xfs@oss.sgi.com>;
	Wed, 30 Apr 2014 08:02:52 -0700 (PDT)
Message-ID: <5361109C.4000502@sandeen.net>
Date: Wed, 30 Apr 2014 10:02:52 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfsprogs: remove unused argument in trans_iput
References: <20140430134844.924376330@sgi.com>
	<20140430135319.660238697@sgi.com>
	<53610D16.9040609@sandeen.net> <53610DA7.8070806@sgi.com>
In-Reply-To: <53610DA7.8070806@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On 4/30/14, 9:50 AM, Mark Tinguely wrote:
> On 04/30/14 09:47, Eric Sandeen wrote:
>> On 4/30/14, 8:48 AM, Mark Tinguely wrote:
>>> >  Remove the unused second argument to xfs_iput() and
>>> >  xfs_trans_iput().
>>> >
>>> >  Introduce the define "IRELE()" and use in place of xfs_iput().
>> Why do this?  We had been moving away from the upper-case-macro-
>> redefined-to-a-function meme... what does this #define gain?
>>
>> libxfs_iget/libxfs_iput pairs seem more obvious than
>> libxfs_iget/IRELE()...
>>
>> Thanks,
>> -Eric
>>
> 
> To be consistent with the kernel code.

Gah, hohum, I'm not even going to try to explain why I thought
we didn't have it in kernel code.

sorry for the noise,
-Eric

> --Mark.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
