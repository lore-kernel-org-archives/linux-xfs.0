Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1NM4egc112197 for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 16:04:41 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8E13198FF43
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 14:04:09 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id 06Fb3g785qC6llXN for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2009 14:04:09 -0800 (PST)
Message-ID: <49A31AFD.8070804@sandeen.net>
Date: Mon, 23 Feb 2009 15:54:05 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS on ARM-based Linux on USR8700 NAS appliance w/ mdadm/RAID5
References: <200902231243.33897.harry.mangalam@uci.edu>
	<200902231320.05320.harry.mangalam@uci.edu>
	<49A315BE.7090607@sandeen.net>
	<200902231345.25062.harry.mangalam@uci.edu>
In-Reply-To: <200902231345.25062.harry.mangalam@uci.edu>
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
To: Harry Mangalam <harry.mangalam@uci.edu>
Cc: xfs@oss.sgi.com

Harry Mangalam wrote:
> On Monday 23 February 2009, Eric Sandeen wrote:
>>> |<IPStorPartition|
>>> | version="3.0" s|
>>> |ize="595" owner=|
>>> |"NACS-SW-DIST" c|
>>> |hecksum="" signa|
>>> |ture="IpStOrDyNa|
>>> |MiCdIsK" dataSta|
>>> |rtAtSectorNo="16|
>> .... knowing the offsets of these might be helpful.  But perhaps
>> you are simply not trying to mount the thing which actually has xfs
>> on it.
>>
>> I don't know what IPStore is.  Perhaps your volume is encrypted?
>> Dunno... at any rate, doesn't seem at first glance like it's an xfs
>> problem, I'm afraid.
>>
>>> |firstSector="222|
>>> |72" lastSector="|
>>> |2928740095" owne|
>> I might look at sector 22272 (about 10MB in) and see if that looks
>> like xfs :)
> 
> Good guess! :
> At 00AE0000 (11.4MB in) there's "XFSB" altho I can't make out much of 
> the surrounding bytes...
> 
> Is there a way to do anything with this info?  Can it be dd'ed out to 
> use to get the thing mounted?

try mount -o loop,offset=11403264 /dev/whatever /mnt/whatever

I'd probably also add ro,norecovery to the options as well so you don't
actually write anything to it at this point.

-Eric

>> Or maybe just put it back in the NAS box, now, assembled the same
>> way.
> 
> This is just about my last gasp - I'll rec that they try this if 
> nothing else comes to mind..
>> -Eric
> 
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
