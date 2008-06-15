Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jun 2008 08:57:16 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5FFvEQ6011045
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 08:57:14 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 84A2417C7BF8
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 08:58:10 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id QRvA93vk4GbV2p3H for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 08:58:10 -0700 (PDT)
Message-ID: <48553C11.2060606@sandeen.net>
Date: Sun, 15 Jun 2008 10:58:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS errors / BUG / panic, with 2.6.25.7-queue (and older 2.6.25.y)
References: <6101e8c40806141241h4a23f7a6ka5366c84130f1291@mail.gmail.com>	 <48547604.9060700@sandeen.net> <6101e8c40806150538h4372dcedob2ab9c45aa01741c@mail.gmail.com>
In-Reply-To: <6101e8c40806150538h4372dcedob2ab9c45aa01741c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Oliver Pinter <oliver.pntr@gmail.com>
Cc: xfs@oss.sgi.com

Oliver Pinter wrote:
> this mistake shutdownkor comes out, remount launched because he
> panics, only Alt+Sysrq+foo works

I'm not sure I follow.

Assuming that :
http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00775.jpg

is the first event of interest, it is hitting an assertion on the
remount path:

        ASSERT_ALWAYS(atomic_read(&mp->m_active_trans) == 0);

in xfs_attr_quiesce.

Are you saying something else happen before this?  If so, what?

-Eric

> On 6/15/08, Eric Sandeen <sandeen@sandeen.net> wrote:
>> Oliver Pinter wrote:
>>> http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00775.jpg
>>> http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00776.jpg
>>> http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00777.jpg
>>> http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00778.jpg
>>> http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00779.jpg
>>> http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00780.jpg
>>> http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00781.jpg
>>>
>>> tainted with: nvidia and madwifi
>>> kernel: 2.6.25.6 + queue patches (queue head on
>>> aa8edcb997ff605bd1424630356866b78ef06cdc)
>>>
>> What sort of remount were you doing?
>>
>> -Eric
>>
> 
> 
