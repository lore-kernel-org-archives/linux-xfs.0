Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4931B7F3F
	for <xfs@oss.sgi.com>; Fri, 18 Sep 2015 11:38:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 36E898F8037
	for <xfs@oss.sgi.com>; Fri, 18 Sep 2015 09:38:44 -0700 (PDT)
Received: from mail.nomovok.com (mail.nomovok.com [83.150.122.238]) by
	cuda.sgi.com with ESMTP id LKqdXc39b2gARSUR (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 18 Sep 2015 09:38:41 -0700 (PDT)
Received: from [192.168.0.111]
	(host22-235-dynamic.248-95-r.retail.telecomitalia.it [95.248.235.22])
	by mail.nomovok.com (Postfix) with ESMTPSA id BAA94AE089
	for <xfs@oss.sgi.com>; Fri, 18 Sep 2015 19:38:39 +0300 (EEST)
Message-ID: <55FC3E0E.9060506@nomovok.com>
Date: Fri, 18 Sep 2015 18:38:38 +0200
From: Angelo Dureghello <angelo.dureghello@nomovok.com>
MIME-Version: 1.0
Subject: xfstests, bad generic tests 009 and 308
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
To: xfs@oss.sgi.com

Hi all,

working on arm (32bit arch), kernel 4.1.6.
Looking to find the reason of some bad results on xfstests,

-tests/generic/009
------------------
i get several "all holes" messages

generic/009    [  842.949643] run fstests generic/009 at 2015-09-18 
15:29:36
  - output mismatch (see 
/home/angelo/xfstests/results//generic/009.out.bad)
     --- tests/generic/009.out    2015-09-17 10:54:06.689071257 +0000
     +++ /home/angelo/xfstests/results//generic/009.out.bad 2015-09-18 
15:29:41.412784177 +0000
     @@ -1,79 +1,45 @@
      QA output created by 009
          1. into a hole
     -0: [0..7]: hole
     -1: [8..23]: unwritten
     -2: [24..39]: hole
     +0: [0..39]: hole
      daa100df6e6711906b61c9ab5aa16032

also some other tests are giving the same bad notices.


-tests/generic/308
------------------

I have now: CONFIG_LBDAF=y

In my target device this test creates a 16 Terabytes file 308.tempfile

-rw------- 1 root root  17592186044415 Sep 18 09:40 testfile.308

While "df" is not complaining about:

/dev/mmcblk0p5   8378368   45252   8333116   1% /media/p5

and next rm -f on it hands the cpu to 95%, forever.

This issue seems known from a long time, as it has been discussed in the 
thread:

http://oss.sgi.com/archives/xfs/2013-04/msg00273.html

I was wondering if there was any special reason why the Jeff patch has
never been finally applied.

I applied this patch anyway, and tests pass.

-- 
Best regards,
Angelo Dureghello

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
