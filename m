Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8O5f0DU168014 for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 00:41:01 -0500
Received: from phd-imap.ethz.ch (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B7A901BA8868
	for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 22:41:54 -0700 (PDT)
Received: from phd-imap.ethz.ch (phd-imap.ethz.ch [129.132.80.51]) by
	cuda.sgi.com with ESMTP id nkPWkDFjkEYWiROJ for
	<xfs@oss.sgi.com>; Thu, 23 Sep 2010 22:41:54 -0700 (PDT)
Subject: Re: XFS errors on large Infiniband fileserver setup
MIME-Version: 1.0
Date: Fri, 24 Sep 2010 07:41:53 +0200
From: Christian Herzog <horeizo@phys.ethz.ch>
In-Reply-To: <20100923235355.GO2614@dastard>
References: <29252416bd0d9dc973a909e411dbec6a@phys.ethz.ch>
	<20100923235355.GO2614@dastard>
Message-ID: <2276da2491527ca8044fa1daec496b48@phys.ethz.ch>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


Hi Dave,

thanks for your feedback.

>> 2 disk backends, each: Quad-Xeon X5550, 12G of RAM, 28T HW
>> SATA-RAID6 sliced into 2T chunks by LVM2 and exported via tgt
>> 1.0.0-2, Ubuntu 10.04 LTS, connected via Mellanox MHRH19B-XTR
>> Infiniband + ISER to
>>
>> 1 frontend Octo-Xeon E5520, 12G of RAM, open-iscsi 2.0.871
>> initiator, Ubuntu 10.04 LTS. LMV2 stitches together the
>> 2T-iSCSI-LUNs and provides a 10T test XFS filesystem
> 
> Out of curiousity, why are you using such a complex storage
> configuration?
> 
> IMO, it is unneccessarily complex - you could easily do this (~30
> drives) with a single server with a couple of external SAS JBOD
> arrays and SAS RAID controllers. That would give you the same
> performance (or better), with many fewer points of failure (both
> hardware and software), use less rack space, and probably be
> significantly cheaper....
basically, our situation is this: we have to supply our astrophysicists
(not just them, but they consume 95%) with large and ever-increasing
amounts of disk space. Up to now we bought individual file servers
whenever space was needed, which is an administrative nightmare as you
can imagine. Hence we decided to come up with a more scalable solution
that would grow with the space needed - and grow it will. We start off
with 52T and can easily add additional disk units to the Infiniband
switch.
It is well possible we have overlooked an easier/cheaper solution, but
what we have now is very flexible and has emerged from discussions we've
had with several 'storage experts'. Do you have any particular/typical
device in mind? I'd like to check it out nonetheless.

thanks,
-Christian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
