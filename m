Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7D93B8028
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 13:08:48 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0185AAC002
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 11:08:47 -0800 (PST)
Received: from slmp-550-94.slc.westdc.net (slmp-550-94.slc.westdc.net
	[50.115.112.57]) by cuda.sgi.com with ESMTP id cjGqLGQxEDXEZEZQ
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Feb 2013 11:08:43 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] xfs_mkfs: wipe old signatures from the device
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <511D1DF5.2060802@redhat.com>
Date: Thu, 14 Feb 2013 12:08:37 -0700
Message-Id: <504D1E58-CFFB-459A-A215-A5BB9BEB8BBE@colorremedies.com>
References: <1360667215-14701-1-git-send-email-lczerner@redhat.com>
	<20130212202753.GC26694@dastard>
	<20130213080154.GC18597@x2.net.home>
	<alpine.LFD.2.00.1302131127070.2315@(none)>
	<20130213121655.GA7799@x2.net.home>
	<20130213221720.GH26694@dastard>
	<982B8DBB-3FBA-4213-BC92-848A64C60110@colorremedies.com>
	<alpine.LFD.2.00.1302140929570.2315@(none)>
	<511D1DF5.2060802@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com, Karel Zak <kzak@redhat.com>, Zach Brown <zabrown@redhat.com>, =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>, linux-btrfs@vger.kernel.org


On Feb 14, 2013, at 10:25 AM, Eric Sandeen <sandeen@redhat.com> wrote:
> 
> I was thinking, as annoying as it might be, requiring the user to
> use "-f $OLD_FS_TYPE" might require a bit more positive action
> and cognition on the admin's part.
> 
> OTOH, that could get annoying, and break old scripts.  :)


Yes, it's possible to get carried away with this: An "are you sure" prompt that requires typing "yes"; or even more deliciously irritating, only accepts as positive:

"primateconfirmspreviousfilesystemdestructionwontsubsequentlyaskaboutdatarecovery"

Way, way more people will copy/paste that from a list or man entry, than acquire muscle memory for -f.


Chris Murphy
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
