Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8786D7CA7
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2016 05:52:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 49BF0304032
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2016 03:52:44 -0700 (PDT)
Received: from hotel311.server4you.de (hotel311.server4you.de [85.25.146.15])
	by cuda.sgi.com with ESMTP id mJsW6AtMODVvJMKv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 07 Jun 2016 03:52:42 -0700 (PDT)
Subject: Re: crash in xfs in current
References: <CAAA5faG3Ls0Dh_bx=950db9BV01zoLfmubKbM0UYkWpS0y60BA@mail.gmail.com>
	<79c8e051-24a9-2e2b-553a-bcab17d03e83@sandeen.net>
	<20160607062717.GA30022@infradead.org>
	<c0b9776e-6917-13f2-1948-e7d51f72a909@monom.org>
	<CAAA5faEvt-vrvrkWC8-9Fys0WHN2TBQz7-Y-mtU8FaRHxUM6rw@mail.gmail.com>
From: Daniel Wagner <wagi@monom.org>
Message-ID: <48817b4c-26f4-5eb6-8a97-d8fa34fe7f6a@monom.org>
Date: Tue, 7 Jun 2016 12:52:39 +0200
MIME-Version: 1.0
In-Reply-To: <CAAA5faEvt-vrvrkWC8-9Fys0WHN2TBQz7-Y-mtU8FaRHxUM6rw@mail.gmail.com>
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
To: Reinoud Koornstra <reinoudkoornstra@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, viro@zeniv.linux.org.uk, xfs@oss.sgi.com

>> I try to reproduce it on 4.6. My steps do not always trigger the crash.
>> So I can't be really sure if 4.6 doesn't show it, it does not happen.
> 
> I have never been able to trigger this in 4.6 and it's my failsafe
> reboot (4.6.0).
> In 4.7-rc1 it's just a matter of time before I hit it.
> I do a lot of transactions, using git, extraction of tar.xz etc normally.

This rings a bell. I though the lockperf tests triggered it. Before I
compiled a new kernel I did a 'git checkout' step.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
