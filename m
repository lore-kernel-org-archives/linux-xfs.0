Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AA7AA7CA1
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2016 03:09:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0F76AAC004
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2016 01:09:55 -0700 (PDT)
Received: from mail-qk0-f170.google.com (mail-qk0-f170.google.com
	[209.85.220.170]) by cuda.sgi.com with ESMTP id
	NxqjdGMIZdk82WQq (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 07 Jun 2016 01:09:50 -0700 (PDT)
Received: by mail-qk0-f170.google.com with SMTP id p22so37272360qka.2
	for <xfs@oss.sgi.com>; Tue, 07 Jun 2016 01:09:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c0b9776e-6917-13f2-1948-e7d51f72a909@monom.org>
References: <CAAA5faG3Ls0Dh_bx=950db9BV01zoLfmubKbM0UYkWpS0y60BA@mail.gmail.com>
	<79c8e051-24a9-2e2b-553a-bcab17d03e83@sandeen.net>
	<20160607062717.GA30022@infradead.org>
	<c0b9776e-6917-13f2-1948-e7d51f72a909@monom.org>
From: Reinoud Koornstra <reinoudkoornstra@gmail.com>
Date: Tue, 7 Jun 2016 02:09:49 -0600
Message-ID: <CAAA5faEvt-vrvrkWC8-9Fys0WHN2TBQz7-Y-mtU8FaRHxUM6rw@mail.gmail.com>
Subject: Re: crash in xfs in current
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
To: Daniel Wagner <wagi@monom.org>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, viro@zeniv.linux.org.uk, xfs@oss.sgi.com

On Tue, Jun 7, 2016 at 1:51 AM, Daniel Wagner <wagi@monom.org> wrote:
>> Given that 4.7-rc1 comes with the new shared locks for lookups, and
>> there are very little other changes I wonder if there is any relation
>> It would be good if Reinoud and/or Daniel can confirm that Linux 4.6
>> is ok.
>
> I try to reproduce it on 4.6. My steps do not always trigger the crash.
> So I can't be really sure if 4.6 doesn't show it, it does not happen.

I have never been able to trigger this in 4.6 and it's my failsafe
reboot (4.6.0).
In 4.7-rc1 it's just a matter of time before I hit it.
I do a lot of transactions, using git, extraction of tar.xz etc normally.
I am normally able to trigger this by a move of a big directory.
It gets stuck there, a kill -9 doesn't either.
So 4.6 is my safehaven to any xfs operation.
Thanks,

Reinoud.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
