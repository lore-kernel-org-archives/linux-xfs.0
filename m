Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 46A737CA0
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2016 12:05:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 161AC30407F
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2016 10:05:30 -0700 (PDT)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com
	(mail-sn1nam02on0081.outbound.protection.outlook.com
	[104.47.36.81]) by cuda.sgi.com with ESMTP id A2bXmgwzmxsr8dYw
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2016 10:05:24 -0700 (PDT)
From: Jeff Gibson <jgibson@spscommerce.com>
Subject: Re: XFS on top of LVM span in AWS.  Stripe or are AG's good enough?
Date: Tue, 16 Aug 2016 17:05:11 +0000
Message-ID: <CY1PR04MB20106F50E177A61934986A92AC130@CY1PR04MB2010.namprd04.prod.outlook.com>
References: <CY1PR04MB20100FE6C3039717BD27825AAC120@CY1PR04MB2010.namprd04.prod.outlook.com>,
	<20160816005931.GD19025@dastard>
In-Reply-To: <20160816005931.GD19025@dastard>
Content-Language: en-US
MIME-Version: 1.0
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

>On Mon, Aug 15, 2016 at 11:36:14PM +0000, Jeff Gibson wrote:
>> So I'm creating an LVM volume with 8 AWS EBS disks that are
>> spanned (linear) per Redhat's documentation for Gluster
>> (https://access.redhat.com/documentation/en-US/Red_Hat_Storage/3.1/html/=
Deployment_Guide_for_Public_Cloud/>ch02s03.html#Provisioning_Storage_for_Th=
ree-way_Replication_Volumes).
>> =

>> 2 questions-
>> =

>> 1.=A0 Will XFS's Allocation Groups essentially stripe the data for
>> me
>
>No. XFS does not stripe data. It does, however, *distribute* data
>different AGs according to locality policy (e.g. inode32 vs
>inode64), so it uses all the AGs as the directory structure grows.
Poor wording on my part.  By "essentially stripe" I mean distribute data th=
roughout all of the EBS subvolumes instead of just using one EBS subvolume =
at a time until full.  I do plan on using inode64.

>> or should I stripe the underlying volumes with LVM?
>
>No, you're using EBS. Forget anything you know about storage layout
>and geometry, because EBS has no guaranteed physical layout you can
>optimise for.
Right.  However there could still be some gains from striping due to IOP li=
mits for single volumes. - That is the combined IOPS for all the volumes st=
riped together can be higher than they are for a single volume. =


>> I'm not
>> worried as much about data integrity with a stripe/span since
>> Gluster is doing the redundancy work.
>> =

>> 2.=A0 AWS volumes sometimes have inconsistent performance.=A0 If I
>> understand things correctly, AG's run in parallel.
>
>Define "run". AGs can allocate/free blocks in parallel.
By run I meant read/write data to/from the AGs.

>If IO does
>not require allocation, then AGs play no part in the IO path.
Can you explain this a bit please?  From my understanding data is written a=
nd read from space inside of AGs, so I don't see how it couldn't be part of=
 the IO path.  Or do you simply mean reads just use inodes and don't care a=
bout the AGs?

>> In a
>> non-striped volume, if some of the AGs are temporarily slower to
>> respond than others due to one of the underlying volumes being
>> slow, will XFS prefer the quicker responding AGs
>
>No, it does not.
>
>> or is I/O always
>> evenly distributed?
>
>No, it is not.
>
>> If XFS prefers the more responsive AG's it
>> seems to me that it would be better NOT to stripe the underlying
>> disk since all AG's that are distributed in a stripe will
>> continuously hit all component volumes, including the slow volume
>> (unless if XFS compensates for this?)
>
>I think you have the wrong idea about what allocation groups do.
I'm reading the XFS File System Structure doc on xfs.org.  It says, "XFS fi=
lesystems are divided into a number of equally sized chunks called Allocati=
on Groups. Each AG can almost be thought of as an individual filesystem." s=
o that's where most of my assumptions are coming from.

>They are for maintaining allocation concurrency and locality of
>related objects on disk - they have no influence on where IO is
>directed based on IO load or response time.
I understand that XFS has locality as far as trying to write files to the s=
ame AG as the parent directory.  Are there other cases?
I get that it's probably not measuring the responsiveness of each AG. I gue=
ss what I'm trying to ask is - will XFS *indirectly* compensate if one subv=
olume is busier?  For example, if writes to a "slow" subvolume and resident=
 AGs take longer to complete, will XFS tend to prefer to use other less-bus=
y AGs more often (with the exception of locality) for writes?  What is the =
basic algorithm for determining where new data is written?  In load-balance=
r terms, does it round-robin, pick the least busy, etc?

Thank you very much!
JG
    =

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
