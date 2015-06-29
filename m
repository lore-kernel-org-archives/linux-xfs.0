Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E9CA27F54
	for <xfs@oss.sgi.com>; Sun, 28 Jun 2015 19:48:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D8EC9304032
	for <xfs@oss.sgi.com>; Sun, 28 Jun 2015 17:48:53 -0700 (PDT)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
	[209.85.212.182]) by cuda.sgi.com with ESMTP id
	jZO3XGT0grMW7hkq (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 28 Jun 2015 17:48:51 -0700 (PDT)
Received: by wicnd19 with SMTP id nd19so85314528wic.1
	for <xfs@oss.sgi.com>; Sun, 28 Jun 2015 17:48:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150629002449.GD7943@dastard>
References: <CAGqmi75jFGjWvFFT5HTwyO1tv4-d4J=aVJ83L2zqNyWMDOz1RQ@mail.gmail.com>
	<20150629002449.GD7943@dastard>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Mon, 29 Jun 2015 03:48:10 +0300
Message-ID: <CAGqmi76g1fj=r3rS=DGL01Q90kAR1jr4tq2Ayv2FWH2HOHE9Kg@mail.gmail.com>
Subject: Re: Q: xfs_db: invalid numrecs (*) in bmapbtd block
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
Cc: xfs@oss.sgi.com

2015-06-29 3:24 GMT+03:00 Dave Chinner <david@fromorbit.com>:
> On Sun, Jun 28, 2015 at 09:44:20PM +0300, Timofey Titovets wrote:
>> Good time of day list,
>> i do regular check fragmentation on my servers and xfs_db show strange erros:
>>
>> # xfs_db -c frag -r /dev/sdc1
>> invalid numrecs (51914) in bmapbtd block
>
> That's expected behaviour if you are running that on a mounted
> filesystem. I'm assuming this is the case because you are telling
> xfs_db to run in read only mode...
>
> Why? Because an actively modified filesystem is only coherent on
> disk when you consider all the modifications staged in the journal,
> and xfs_db ignores the journal. Hence what it reads of disk is not
> coherent and hence is not guaranteed valid.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com


Big Thanks Dave for explanation.
=^_^=

-- 
Have a nice day,
Timofey.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
