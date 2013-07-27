Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BACD67F3F
	for <xfs@oss.sgi.com>; Sat, 27 Jul 2013 13:32:48 -0500 (CDT)
Message-ID: <51F41250.9010703@sgi.com>
Date: Sat, 27 Jul 2013 13:32:48 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 44/49] xfs: Reduce allocations during CIL insertion
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-45-git-send-email-david@fromorbit.com>
	<51EEF26F.5040001@sgi.com> <51EEF949.9020104@gmail.com>
	<51EFD68A.40400@sgi.com> <51F2E011.5020904@gmail.com>
	<51F2E4DD.4020301@sgi.com> <20130727015822.GV13468@dastard>
In-Reply-To: <20130727015822.GV13468@dastard>
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
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, xfs@oss.sgi.com

On 07/26/13 20:58, Dave Chinner wrote:
> On Fri, Jul 26, 2013 at 04:06:37PM -0500, Mark Tinguely wrote:
>>
>> I can reproduce a problem in patch 44 too. It takes my copy test 20
>> minutes to deplete the log space with patch 44, Same test with patch
>> 43 has been running a day and a half. I do not think that patch 44
>> is 100 times faster than patch 43 but I will let patch 43 spin all
>> weekend on a couple machines to verify that patch 43 does not hang.
>
> Details, please. What's your "copy test"?
>
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
>
> Cheers,
>
> Dave.

Micheal found the problem using a simple copy, so I am using copy-like test.

I have hung patch 44 with fsstress but I am currently using the simple 
perl scripts from bugzilla bug 922, but I do not do the silly step of 
reducing the log to an abnormal amount.

Just mkfs the filesystem

Create the the test files. the creation script:
   http://oss.sgi.com/bugzilla/attachment.cgi?id=304

Run the test script:
   http://oss.sgi.com/bugzilla/attachment.cgi?id=305
           ----
This test seems to stress the log much like xfstest 273 only it runs 
forever.

I have a 32 bit machine:
meta-data=/dev/sda4              isize=256    agcount=4, agsize=601152 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=2404608, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=2560, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

and 64 bit machines with a little larger filesystems:

meta-data=/dev/sdb2              isize=256    agcount=4, agsize=2622080
meta-data=/dev/sda2              isize=256    agcount=4, agsize=4194432 blks
          =                       sectsz=512   attr=2, projid32bit=1
          =                       crc=0
data     =                       bsize=4096   blocks=16777728, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=8192, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

I am running patch 43, I know that patch 44 will hang in about 20 
minutes. One 64 bit machine is at hour 50 on patch 43. Monday I will 
stop the test one of the machines and try to account for the log space.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
