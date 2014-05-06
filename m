Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 58DB67F37
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 18:20:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DD524AC003
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 16:20:47 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id gNKke1TkqkmgCVy8
	for <xfs@oss.sgi.com>; Tue, 06 May 2014 16:20:46 -0700 (PDT)
Message-ID: <53696E4E.5030404@hardwarefreak.com>
Date: Tue, 06 May 2014 18:20:46 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS tune to adaptec ASR71605
References: <alpine.LRH.2.02.1405061104580.24742@becks.mcs.st-and.ac.uk>	<20140506130008.13a1a7ee@harpe.intellique.com>	<alpine.LRH.2.02.1405061408480.24742@becks.mcs.st-and.ac.uk>	<20140506155149.5cf056b5@harpe.intellique.com>
	<20140506200917.GM5421@dastard>
In-Reply-To: <20140506200917.GM5421@dastard>
Reply-To: stan@hardwarefreak.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, Emmanuel Florac <eflorac@intellique.com>
Cc: Steve Brooks <steveb@mcs.st-and.ac.uk>, xfs@oss.sgi.com

On 5/6/2014 3:09 PM, Dave Chinner wrote:
> On Tue, May 06, 2014 at 03:51:49PM +0200, Emmanuel Florac wrote:
>> Le Tue, 6 May 2014 14:14:35 +0100 (BST)
>> Steve Brooks <steveb@mcs.st-and.ac.uk> =E9crivait:
>>
>>> Thanks for the reply Emmanuel, I installed and rua bonnie++ although
>>> I will need to research the results
>>
>> Yup, they're... weird :) Write speed is abysmal, but random seeks very
>> high. Please try my settings so that we can compare the numbers more
>> directly:
> =

> Friends don't let friends use bonnie++ for benchmarking storage.
> The numbers you get will be irrelevant to you application, and it's
> so synthetic is doesn't reflect any real-world workload at all.
> =

> The only useful benchmark for determining if changes are going to
> improve application performance is to measure your application's
> performance.

Exactly.  The OP's post begins with:

"After much reading around this is what I came up with...  All hosts
have 16x4TB WD RE WD4000FYYZ drives and will run RAID 6...

Stripe-unit size                         : 512 KB"

That's a 7 MB stripe width.  Such a setup is suitable for large
streaming workloads which generate no RMW, and that's about it.  For
anything involving random writes the performance will be very low, even
with write cache enabled, because each writeback operation will involve
reading and writing 1.5 MB minimum.  Depending on the ARC firmware, if
it does scrubbing, it may read/write 7 MB for each RMW operation.

"Everything begins and ends with the workload".

Describe the workload on each machine, if not all the same, and we'll be
in a far better position to advise what RAID level and stripe unit size
you should use, and how best to configure XFS.

All the best,

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
