Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 16CB829DF8
	for <linux-xfs@oss.sgi.com>; Thu,  9 May 2013 02:16:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B0AB4AC001
	for <linux-xfs@oss.sgi.com>; Thu,  9 May 2013 00:16:35 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 6Aj5k8QEaOoVwhnl
	for <linux-xfs@oss.sgi.com>; Thu, 09 May 2013 00:16:31 -0700 (PDT)
Message-ID: <518B4D52.2090807@hardwarefreak.com>
Date: Thu, 09 May 2013 02:16:34 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: 3.9.0: general protection fault
References: <kltu6o$33j$1@ger.gmane.org> <km7oop$28c$1@ger.gmane.org>
	<20130506122844.GL19978@dastard> <5187A663.707@itwm.fraunhofer.de>
	<20130507011254.GP19978@dastard>
	<5188E2F5.1090304@itwm.fraunhofer.de>
	<20130507220742.GC24635@dastard>
In-Reply-To: <20130507220742.GC24635@dastard>
Reply-To: stan@hardwarefreak.com
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
Cc: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>, linux-xfs@oss.sgi.com

On 5/7/2013 5:07 PM, Dave Chinner wrote:

>> And I just wonder what you are going to do with the information
>> about the hardware. So it is an Areca hw-raid5 device with 9 disks.
>> But does this help? It doesn't tell if one of the disks reads/writes
>> with hickups or provides any performance characteristics at all.
> 
> Yes, it does, because Areca cards are by far the most unreliable HW
> RAID you can buy, which is not surprising because they are also the
> cheapest. This is through experience - we see reports of filesystems
> being badly corrupted ever few months because of problems with Areca
> controllers.

And the sad part is that they're not that much lower priced than a
comparable LSI card, at least in N. America.  Newegg sells a 28 port LSI
for $1500 and a 28 port Areca for $1300--a paltry 13% difference.  Areca
packs 8x more DRAM onto this board--4GB vs 512MB--via a standard DIMM
socket, and touts the larger RAM capacity and expandability as a big
performance booster.  AIUI this is only partially true.  The larger
capacity for the most part simply helps their weak firmware keep pace
with some workloads, mainly large streaming, but the random IO
performance of the Areca's isn't all that great, and regardless of the
size DIMM once inserts random performance doesn't change much.

Regarding reliability, it's interesting to note that the RAID card
industry as a whole began moving away from standard socketed DRAM quite
some time ago.  When a manufacturer solders DRAM chips to the board they
have direct control over memory quality and the testing/verification
process of the finished product.  So when the customer installs and uses
the board there are no surprises here.  With standard DIMM socketed
boards the customer can insert any DIMM s/he wishes, and there's no
guarantee of the quality/reliability of the DIMM, nor the complete unit.
 AFAIK Areca has the only line of RAID cards on the market with a socket
for standard DRAM.  HP uses a socket design but the daughterboard holds
more than just DRAM, and you must use HP's daughterboard, thus they
control quality.  I wonder how many of the people who have problems with
their Areca board had inserted aftermarket DIMMs, vs those using factory
memory who simply ran into firmware or board QC problems.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
